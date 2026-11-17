-- GetHealth / GetMaxHealth return a 64-bit userdata on this Eluna (Midnight health is uint64): plain Lua arithmetic needs a number
local function Num(v) return tonumber(tostring(v)) or 0 end
-- CoA Witch Doctor wards / idols / effigies, rebuilt from the CoA spell descriptions (data/coa/all_spells_raw.json "description"):
-- the CoA export has no helper / aura spells (1052 referenced ids are missing), so the behaviour is data-driven here, one line of SPEC per creature.
-- Numbers are CoA's, scaled to the owner's level (CoA tooltips are level-1 values): amount * (1 + level / 2).
--   Healing Ward 7050104  "heals 8 nearby allies within 30 yds every 2.5 sec" (1 min)
--   Spirit Idol  7050106  "allies within 30 yds regenerate 4% maximum mana every 3 sec" (15 sec)
--   Stasis Ward  7050108  "after 2 sec bursts with lightning, stunning nearby enemies for 4 sec and dealing 12 Nature damage"
--   Voodoo Ward  7050123  "45 Firestorm damage to up to 4 targets every 2 sec for 8 sec; at the end 119 damage to all enemies within 6 yds"
--   Hexing Effigy 7050120 "the next enemy that casts a spell on you is transformed into a frog" (one effigy at a time)
--   Shadow Effigy 7050119 "enemies nearby: casting speed and movement speed reduced" (Curse of Tongues + Hamstring)
-- NOT done (needs spells the build lacks): Graven Effigy (CC duration +%), Serene Idol (pushback), Jungle / Dark Idol (resistance), Sentry Ward (reveal stealth).
local function Scale(lv) return 1 + (lv or 1) / 2 end
local FIRE, NATURE = 4, 8

COA_WARD_SPEC = {   -- also read by coa_summon_ai.lua (it skips these entries)
    [7050104] = {life = 60, radius = 30, tick = 2.5, acts = {{"heal", n = 8, pct = 2}}},
    [7050106] = {life = 15, radius = 30, tick = 3,   acts = {{"mana", pct = 4}}},
    [7050108] = {life = 2.5, burst = {delay = 2, stun = 853, stun_s = 4, dmg = 12, school = NATURE, radius = 8}},
    [7050123] = {life = 8, radius = 12, tick = 2, acts = {{"dmg", n = 4, amt = 45, school = FIRE}}, final = {dmg = 119, radius = 6, school = FIRE}},
    [7050120] = {life = 60, radius = 20, tick = 1, acts = {{"frog", spell = 11641}}},
    [7050119] = {life = 60, radius = 10, tick = 2, acts = {{"debuff", spells = {1714, 1715}}}},
}

local function Alive(u) return u and u.IsAlive and u:IsAlive() end
local function Near(a, r, list) local out = {} for _, u in ipairs(list or {}) do local ok, d = pcall(function() return a:GetDistance(u) end) if ok and d <= r then out[#out + 1] = u end end return out end
local function Hostile(ow, u) return Alive(u) and u:GetGUID() ~= ow:GetGUID() and u:GetFaction() ~= ow:GetFaction() and u:IsInCombat() end

local function Allies(a, ow, r)   -- owner + group members in range (players)
    local out = {ow}
    local okp, pl = pcall(function() return a:GetPlayersInRange(r) end)
    for _, p in ipairs(okp and pl or {}) do
        if p:GetGUID() ~= ow:GetGUID() then
            local okg, same = pcall(function() return p:IsInSameGroupWith(ow) end)
            if okg and same then out[#out + 1] = p end
        end
    end
    return out
end
local function Enemies(a, ow, r)
    local ok, l = pcall(function() return a:GetCreaturesInRange(r) end)
    local out = {} for _, u in ipairs(ok and l or {}) do if Hostile(ow, u) then out[#out + 1] = u end end
    return out
end
local function Hit(a, u, amt, school) pcall(function() a:DealDamage(u, math.floor(amt), false, school) end) end

local function Act(a, ow, spec, act)
    local lv = ow:GetLevel() or 1
    if act[1] == "heal" then
        local list = Allies(a, ow, spec.radius); table.sort(list, function(x, y) return Num(x:GetHealth()) / math.max(1, Num(x:GetMaxHealth())) < Num(y:GetHealth()) / math.max(1, Num(y:GetMaxHealth())) end)
        for i = 1, math.min(act.n, #list) do local u = list[i]; local mx = Num(u:GetMaxHealth()); if Num(u:GetHealth()) < mx then pcall(function() u:SetHealth(math.min(mx, Num(u:GetHealth()) + mx * act.pct / 100)) end) end end
    elseif act[1] == "mana" then
        for _, u in ipairs(Allies(a, ow, spec.radius)) do local mx = u:GetMaxPower(0); if mx and mx > 0 then pcall(function() u:SetPower(math.min(mx, u:GetPower(0) + mx * act.pct / 100), 0) end) end end
    elseif act[1] == "dmg" then
        local list = Enemies(a, ow, spec.radius)
        for i = 1, math.min(act.n, #list) do Hit(a, list[i], act.amt * Scale(lv), act.school) end
    elseif act[1] == "debuff" then
        for _, u in ipairs(Enemies(a, ow, spec.radius)) do for _, s in ipairs(act.spells) do pcall(function() a:CastSpell(u, s, true) end) end end
    elseif act[1] == "frog" then   -- the next enemy that is casting at the owner
        for _, u in ipairs(Enemies(a, ow, spec.radius)) do
            local ok, casting = pcall(function() return u:IsNonMeleeSpellCast(false) end)
            if ok and casting and u:GetVictim() and u:GetVictim():GetGUID() == ow:GetGUID() then
                pcall(function() a:CastSpell(u, act.spell, true) end); pcall(function() a:DespawnOrUnsummon(500) end); return true
            end
        end
    end
end

local function Start(_, c)
    local spec = COA_WARD_SPEC[c:GetEntry()]; if not spec then return end
    local ow0 = c:GetOwner(); if not ow0 then return end
    if spec.burst then   -- Stasis Ward: wait, then burst once
        c:RegisterEvent(function(_, _, _, a)
            local ow = a:GetOwner(); if not ow then return end
            for _, u in ipairs(Enemies(a, ow, spec.burst.radius)) do
                Hit(a, u, spec.burst.dmg * Scale(ow:GetLevel()), spec.burst.school)
                pcall(function() a:CastSpell(u, spec.burst.stun, true) end)   -- Hammer of Justice stun (retail duration), CoA says 4 sec
            end
            pcall(function() a:DespawnOrUnsummon(800) end)
        end, spec.burst.delay * 1000, 1)
        return
    end
    c:RegisterEvent(function(_, _, _, a)   -- periodic actions
        local ow = a:GetOwner(); if not (ow and Alive(a) and Alive(ow)) then return end
        for _, act in ipairs(spec.acts) do if Act(a, ow, spec, act) then return end end
    end, spec.tick * 1000, 0)
    c:RegisterEvent(function(_, _, _, a)   -- end of life
        local ow = a:GetOwner()
        if ow and spec.final then for _, u in ipairs(Enemies(a, ow, spec.final.radius)) do Hit(a, u, spec.final.dmg * Scale(ow:GetLevel()), spec.final.school) end end
        pcall(function() a:DespawnOrUnsummon(300) end)
    end, spec.life * 1000, 1)
end

local n = 0
for entry in pairs(COA_WARD_SPEC) do RegisterCreatureEvent(entry, 5, Start); n = n + 1 end   -- 5 = ON_SPAWN
print(string.format("[coa_wards] %d CoA wards rebuilt from their descriptions", n))
