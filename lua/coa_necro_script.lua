-- CoA necromancer cast-time logic (port of AscensionNecromancerAbilities.cpp: necromancer_casts::OnSpellCast + spell_ascension_necromancer_ability::Hit).
-- Eluna only sees player spell casts (no damage / proc / aura hooks), so the proc layer (AscensionNecromancerEvents.cpp) is NOT here: it needs the C++ module.
-- CoA spell ids get +7000000. Everything is pcall-guarded; a talent that is not learned (aura missing) simply does nothing.
local OFF = 7000000
local function Num(v) return tonumber(tostring(v)) or 0 end
local function Id(p) return tostring(p:GetGUIDLow()) end

-- ---- helpers (CoA Cast / Chance / Plague / Reduce / Minions) -------------------------------------------------
local PC, CD = {}, {}
local function ProcChance(talent)          -- ProcChance of the talent spell (hotfix spell_auras_options)
    if PC[talent] == nil then
        local ok, q = pcall(WorldDBQuery, "SELECT ProcChance FROM hotfixes.spell_aura_options WHERE SpellID=" .. (OFF + talent) .. " LIMIT 1")
        PC[talent] = (ok and q and q:GetUInt32(0)) or 0
    end
    return PC[talent]
end
local function Has(p, talent) return p:HasAura(OFF + talent) end
local function Chance(p, talent, mult, cdms)   -- CoA Chance(): talent aura present, not on internal cooldown, proc chance roll
    if not Has(p, talent) then return false end
    local key, now = Id(p) .. ":" .. talent, GetCurrTime()
    if CD[key] and CD[key] > now then return false end
    if math.random() * 100 >= math.min(ProcChance(talent) * (mult or 1), 100) then return false end
    if cdms then CD[key] = now + cdms end
    return true
end
local function Cast(c, t, spell) if c and t and t:IsAlive() then pcall(function() c:CastSpell(t, OFF + spell, true) end) end end
local function Plague(p, t, stacks)            -- CoA Plague(): +stacks of Crypt Plague (570131) on the target
    if not (t and t:IsAlive()) or t:GetFaction() == p:GetFaction() then return end
    local a = t:GetAura(OFF + 570131)
    if not a then pcall(function() p:AddAura(OFF + 570131, t) end); a = t:GetAura(OFF + 570131) end
    if a then pcall(function() a:SetStackAmount(math.min(a:GetStackAmount() + (stacks or 1), 255)) end) end
    if Has(p, 574138) then Cast(p, p, 573131) end
end
local function Reset(p, root) pcall(function() p:ResetSpellCooldown(OFF + root, true) end) end

local COMMAND = {}
for _, id in ipairs({504020, 504489, 504021, 504052, 504318, 504319, 504334, 504905, 504860, 504862, 504864, 504050, 504863, 504316, 504865,
                     500991, 504868, 504907, 504908, 805871}) do COMMAND[id] = true end
local count, busy = {}, {}

RegisterPlayerEvent(5, function(_, p, spell)   -- ON_SPELL_CAST
    local g = Id(p)
    if busy[g] then return end
    local id = spell:GetEntry() - OFF
    if not COMMAND[id] then return end
    busy[g] = true
    local ok, err = pcall(function()
        local okt, t = pcall(function() return spell:GetTarget() end)
        if not (okt and t and t.IsAlive) then t = p:GetVictim() end
        if not t then local oks, s = pcall(function() return p:GetSelection() end); if oks then t = s end end
        local hostile = t and t.IsAlive and t:IsAlive() and t:GetFaction() ~= p:GetFaction()

        if Chance(p, 300940) then Reset(p, 801760) end                                  -- Ice Barrage ready again
        if Chance(p, 805649) then                                                        -- +100 runic power (10 on the bar)
            local rp = Num(p:GetPower(6)); p:SetPower(math.min(rp + 100, Num(p:GetMaxPower(6))), 6)
        end
        count[g] = (count[g] or 0) + 1
        if count[g] % 3 == 0 and hostile and Has(p, 801733) then Cast(p, t, 704860) end  -- every 3rd Command
        if hostile then
            if Has(p, 806328) then Plague(p, t) end
            if Has(p, 806324) then Cast(p, t, 806325) end
            if Has(p, 500572) then                                                       -- Plague on up to 3 enemies near the target
                local n = 0
                local okl, l = pcall(function() return t:GetCreaturesInRange(10) end)
                for _, u in ipairs(okl and l or {}) do
                    if u:IsAlive() and u:GetFaction() ~= p:GetFaction() then Plague(p, u); n = n + 1; if n >= 3 then break end end
                end
            end
            if Has(p, 705754) then Cast(p, t, 500443) end
        end
    end)
    busy[g] = nil
    if not ok then PrintInfo("[necro_script] " .. tostring(err)) end
end)

-- Phase 2 (C++ module needed): damage / proc events (Events.cpp: Soulfreeze, Lichfrost procs, Overwhelming Force, Ghoul Mastery, Phylactery
-- intercept in OnDamage, minion damage share 45%), AllSpellScript checks (cast refusal), Ready-charge consumption, Virulency, Spread.
print("[coa_necro_script] loaded")
