-- CoA necromancer minion behaviours (port of AscensionNecromancerSummons.cpp UpdateAI events / IsSummonedBy / DamageTaken).
-- Runs next to coa_necro_minions.lua (scaling, commands, role loops): this file adds the autonomous abilities the CoA minions cast on their own.
-- CoA spell / creature ids get +7000000. Every cast is pcall-guarded.
local OFF = 7000000
local PACIFY = OFF + 500983
local function Num(v) return tonumber(tostring(v)) or 0 end

-- creature (CoA id) -> spell it casts on its victim every 3 s (CoA AttackSpell, UpdateAI event 2)
local AUTO = { [50067] = 805976, [500650] = 572211, [50075] = 805955, [50076] = 800609, [50130] = 800609, [50323] = 803406, [500484] = 801513 }
local RANGED = { [50067] = true, [50075] = true, [50076] = true, [50130] = true, [50323] = true }   -- CoA Ranged(): 40 yd
-- creature -> {spell, period s, target = "self"|"victim"}  (CoA events 10 / 11 / 12)
local PERIODIC = {
    [50385] = { 704706, 1, "victim" },                                   -- Plaguefather
    [503030] = { 504022, 3, "self", true }, [503031] = { 504022, 3, "self", true }, [503032] = { 504022, 3, "self", true },   -- Zombie Plague (needs a victim)
    [50309] = { 801412, 10, "self", true },                              -- Bone Wraith bonestorm
}
-- passive auras the creature gets on spawn (CoA IsSummonedBy)
local SPAWN_AURA = { [500482] = 805050, [500483] = 808017, [500484] = 807812 }   -- ghoul 805290 removed: its proc trigger (7707000) crashes the worldserver when the ghoul dies

local function Owner(c) local ok, o = pcall(function() return c:GetOwner() end); return ok and o or nil end
local function Busy(ow) return not ow or ow:HasAura(PACIFY) end
local function Victim(c, ow)
    local t = c:GetVictim() or ow:GetVictim()
    if not t then local ok, s = pcall(function() return ow:GetSelection() end); if ok then t = s end end
    if t and t.IsAlive and t:IsAlive() and t:GetFaction() ~= ow:GetFaction() then return t end
end

local function Hook(entry)
    pcall(RegisterCreatureEvent, OFF + entry, 5, function(_, c)   -- ON_SPAWN
        local ow = Owner(c)
        if not ow then return end
        if SPAWN_AURA[entry] then pcall(function() c:AddAura(OFF + SPAWN_AURA[entry], c) end) end
        local auto, per = AUTO[entry], PERIODIC[entry]
        if auto then
            c:RegisterEvent(function(_, _, _, a)
                local o = Owner(a); if Busy(o) or not a:IsAlive() then return end
                local t = a:GetVictim() or Victim(a, o)
                if not t or not (o:IsInCombat() or a:IsInCombat()) then return end
                if a:GetDistance(t) > (RANGED[entry] and 40 or 6) then return end
                pcall(function() a:CastSpell(t, OFF + auto, true) end)
            end, 3000, 0)
        end
        if per then
            c:RegisterEvent(function(_, _, _, a)
                local o = Owner(a); if Busy(o) or not a:IsAlive() then return end
                local t = per[3] == "self" and a or (a:GetVictim() or Victim(a, o))
                if per[4] and not (a:GetVictim() or o:GetVictim()) then return end
                if t then pcall(function() a:CastSpell(t, OFF + per[1], true) end) end
            end, per[2] * 1000, 0)
        end
        if entry == 50133 or entry == 50303 then   -- Bone Bomb: explodes after the aura period (5 s) and goes away
            c:RegisterEvent(function(_, _, _, a)
                pcall(function() a:CastSpell(a, OFF + 500585, true) end)
                pcall(function() a:DespawnOrUnsummon(100) end)
            end, 5000, 1)
        end
        if entry == 542064 then   -- Tombstone: the owner casts the ground spell at its position every 3 s
            c:RegisterEvent(function(_, _, _, a)
                local o = Owner(a); if not o then return end
                pcall(function() o:CastSpellAoF(a:GetX(), a:GetY(), a:GetZ(), OFF + 500365, true) end)
            end, 3000, 0)
        end
        if entry == 50177 then   -- Frost Wyrm: hovers, breathes on the nearest enemy every 2 s, splash on everyone near it
            pcall(function() c:SetHover(true) end)
            c:RegisterEvent(function(_, _, _, a)
                local o = Owner(a); if Busy(o) or not a:IsAlive() then return end
                local t = Victim(a, o)
                if not t or a:GetDistance(t) > 40 then return end
                pcall(function() a:CastSpell(t, 45200, true) end)
                a:RegisterEvent(function() pcall(function() t:CastSpell(t, OFF + 807339, true) end) end, 800, 1)
            end, 2000, 0)
        end
    end)
    if entry == 50068 then   -- Abomination: when hit it releases a Disease Cloud (CoA DamageTaken), at most once a second
        local last = 0
        pcall(RegisterCreatureEvent, OFF + entry, 9, function(_, c, attacker, damage)
            local ow = Owner(c); if Busy(ow) or not attacker or not damage or damage <= 0 then return end
            local now = GetCurrTime and GetCurrTime() or 0
            if now - last < 1000 then return end
            last = now
            pcall(function() c:CastSpell(c, OFF + 802353, true) end)
        end)
    end
end
for _, e in ipairs({ 50067, 500650, 50075, 50076, 50323, 500484, 50385, 503030, 503031, 503032, 50309, 50133, 50303, 542064, 50177, 500482, 500483, 50073, 50068 }) do Hook(e) end
print("[coa_necro_behaviors] loaded")

-- Sacrifice Undead (CoA 805027 + ranks 807938-41): destroys every owned undead minion; per minion the caster is healed m1 + 0.3 x spell power.
-- Life Force returns by itself (it is the occupancy of living minions). Rank value m1 = effect 0 base points of the rank.
local SAC = { [805027] = 49, [807938] = 199, [807939] = 302, [807940] = 555, [807941] = 802 }
local KEEP = { [50132] = true, [542064] = true, [575091] = true, [542065] = true }   -- phylactery / tombstone / ritual circle are not minions
RegisterPlayerEvent(5, function(_, p, spell)
    local m1 = SAC[spell:GetEntry() - OFF]
    if not m1 then return end
    local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
    local n = 0
    for _, c in ipairs(ok and list or {}) do
        local o, e = Owner(c), c:GetEntry() - OFF
        if o and o:GetGUID() == p:GetGUID() and c:IsAlive() and not KEEP[e] then
            n = n + 1
            pcall(function() c:DealDamage(c, Num(c:GetMaxHealth()) * 2, false, 0) end)
        end
    end
    if n == 0 then return end
    local sp = 0
    sp = Num(p:GetStat(3))   -- ponytail: intellect stands in for spell power; Unit:GetBaseSpellPower crashes this core natively (RVA 1DC8730)
    local heal = math.floor((m1 + sp * 0.3) * n)
    if p:HasAura(OFF + 704684) then heal = math.floor(Num(p:GetMaxHealth()) * 0.05 * n) end   -- CoA: the 704684 passive turns it into 5% max health per minion (45 s cooldown)
    pcall(function() p:DealHeal(p, OFF + 805031, heal) end)
    p:SendBroadcastMessage(string.format("[necro] Sacrifice Undead: %d minions destroyed, healed %d", n, heal))
end)

-- Phylactery recovery (CoA UpdateAI entry 50132): a Shade that reaches its Phylactery (< 3 yd) is restored to 40% health and the Phylactery is consumed.
pcall(RegisterCreatureEvent, OFF + 50132, 5, function(_, c)   -- ON_SPAWN
    local ow0 = Owner(c)   -- CoA: a new Phylactery replaces the previous one of the same owner
    if ow0 then
        local okp, near = pcall(function() return ow0:GetCreaturesInRange(200) end)
        for _, o in ipairs(okp and near or {}) do
            if o:GetEntry() == OFF + 50132 and o:GetGUID() ~= c:GetGUID() and Owner(o) and Owner(o):GetGUID() == ow0:GetGUID() then pcall(function() o:DespawnOrUnsummon(0) end) end
        end
    end
    c:RegisterEvent(function(_, _, _, a)
        local ow = Owner(a)
        if not (ow and a:IsAlive()) then return end
        if ow:HasAura(OFF + 500730) and a:GetDistance(ow) < 3 then
            pcall(function() ow:RemoveAura(OFF + 500730) end)
            pcall(function() ow:RemoveAura(OFF + 500729) end)
            pcall(function() ow:SetHealth(math.floor(Num(ow:GetMaxHealth()) * 0.4)) end)
            pcall(function() a:DespawnOrUnsummon(0) end)
        end
    end, 1000, 0)
end)

-- ===== Undead stances (CoA: Assault 500982 / Pacify 500983 / Protect 500985): only ONE stance is active, and the minions follow it =====
local STANCE = { [500982] = "assault", [500983] = "pacify", [500985] = "protect" }
RegisterPlayerEvent(5, function(_, p, spell)   -- ON_SPELL_CAST: the new stance replaces the others
    local id = spell:GetEntry() - OFF
    if not STANCE[id] then return end
    for sid in pairs(STANCE) do
        if sid ~= id then pcall(function() p:RemoveAura(OFF + sid) end) end
    end
end)
local function StanceOf(ow)
    if ow:HasAura(OFF + 500983) then return "pacify" end
    if ow:HasAura(OFF + 500982) then return "assault" end
    return "protect"   -- CoA default state is REACT_DEFENSIVE
end
local MINIONS = { 50065, 51065, 50073, 50075, 50076, 50078, 50115, 50323, 50068, 51275, 50177, 50067, 500650, 50309, 50385, 500482, 500483, 500484, 50130, 50133, 50303, 503030, 503031, 503032 }
for _, entry in ipairs(MINIONS) do
    pcall(RegisterCreatureEvent, OFF + entry, 5, function(_, c)   -- ON_SPAWN
        c:RegisterEvent(function(_, _, _, a)
            local ow = Owner(a)
            if not (ow and a:IsAlive()) then return end
            local st = StanceOf(ow)
            if st == "pacify" then
                pcall(function() a:SetReactState(0) end)             -- REACT_PASSIVE: no attacks, no spells (the loops above also check the aura)
                if a:GetVictim() then pcall(function() a:AttackStop() end) end
            elseif st == "assault" then
                pcall(function() a:SetReactState(2) end)             -- REACT_AGGRESSIVE: engages anything hostile nearby
                if not a:GetVictim() then
                    local t = ow:GetVictim()
                    if not t then
                        local ok, l = pcall(function() return a:GetCreaturesInRange(20) end)
                        for _, u in ipairs(ok and l or {}) do
                            if u:IsAlive() and u:GetFaction() ~= ow:GetFaction() and u:IsInCombat() then t = u; break end
                        end
                    end
                    if t and t:IsAlive() and t:GetFaction() ~= ow:GetFaction() then pcall(function() a:AttackStart(t) end) end
                end
            else
                pcall(function() a:SetReactState(1) end)             -- REACT_DEFENSIVE
            end
        end, 1000, 0)
    end)
end
