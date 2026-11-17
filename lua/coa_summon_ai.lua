-- GetHealth / GetMaxHealth return a 64-bit userdata on this Eluna (Midnight health is uint64): plain Lua arithmetic needs a number
local function Num(v) return tonumber(tostring(v)) or 0 end
-- Generic AI for CoA summons (wards, effigies, totems...). CoA ran these in C++; here the 90 imported creatures have no AIName / SmartAI, so a ward just stood there.
-- 1) BEHAVIOR (below) = hand-made behaviour per ward, using retail spells that exist in this build (ids checked in SpellName.db2):
--      Serpent Ward  7050105 / 7050587  fireballs at the owner's target                 Fireball 133
--      (Healing / Voodoo / Shadow Effigy and the other Witch Doctor wards: coa_wards.lua, built from the CoA descriptions)
-- 2) every other creature with creature_template_spell rows casts them from a 2 s tick; the target comes from the spell's first-effect implicit target:
--      enemy (6, 15, 16, 24, 25, 26) -> owner's / own victim, only in combat;  self / area (1, 22, 53, 56...) -> the summon;  ally (21) -> the owner
-- Necromancer minions (COA_LF.SUMMON) have their own engine in coa_necro_minions.lua and are skipped.
local OFF = 7000000
local ATTACK_SOUND = {[7050105] = 2520, [7050587] = 2520}   -- Serpent Ward: SoundKit 2520 = sound/creature/totemall/serpenttotemattack a/b/c
local ENEMY = {[6] = true, [15] = true, [16] = true, [24] = true, [25] = true, [26] = true}
local COOLDOWN = 6   -- seconds between casts of the same spell (generic loop)

-- {spell, kind, cooldown seconds}   kinds: "enemy", "heal", "fear" (fear is an enemy spell that is not wasted on a feared target)
local BEHAVIOR = {
    [7050105] = {{133, "enemy", 3}},
    [7050587] = {{133, "enemy", 3}},
}

local SPELLS = {}    -- creature entry -> { {spell, targetKind, cd}, ... }
local q = WorldDBQuery("SELECT s.CreatureID, s.Spell, COALESCE((SELECT e.ImplicitTarget1 FROM hotfixes.spell_effect e WHERE e.SpellID = s.Spell AND e.EffectIndex = 0 LIMIT 1), 1) "
    .. "FROM creature_template_spell s WHERE s.CreatureID BETWEEN 7000000 AND 7099999")
if q then
    repeat
        local entry, spell, tgt = q:GetUInt32(0), q:GetUInt32(1), q:GetUInt32(2)
        if not HAS_CPP_SCRIPT[entry] then
            local kind = ENEMY[tgt] and "enemy" or (tgt == 21 and "ally" or "self")
            SPELLS[entry] = SPELLS[entry] or {}
            table.insert(SPELLS[entry], {spell, kind, COOLDOWN})
        end
    until not q:NextRow()
end
for entry, list in pairs(BEHAVIOR) do SPELLS[entry] = list end   -- hand-made behaviour wins

local function Alive(u) return u and u.IsAlive and u:IsAlive() end

local function HealTarget(a, ow)   -- lowest health % among the owner and the group members near the ward
    local best, bp = nil, 0.95
    local function Consider(m)
        if not (m and Alive(m)) then return end
        local ok, d = pcall(function() return a:GetDistance(m) end)
        if not ok or d > 40 then return end
        local mx = Num(m:GetMaxHealth()); if not mx or mx <= 0 then return end
        local p = Num(m:GetHealth()) / mx
        if p < bp then best, bp = m, p end
    end
    Consider(ow)
    local okg, grp = pcall(function() return ow:GetGroup() end)
    if okg and grp then
        local okm, mem = pcall(function() return grp:GetMembers() end)
        if okm and mem then for _, m in ipairs(mem) do Consider(m) end end
    end
    return best
end

local function Start(_, c)
    if COA_WARD_SPEC and COA_WARD_SPEC[c:GetEntry()] then return end   -- coa_wards.lua owns these
    local list = SPELLS[c:GetEntry()]
    if not list or (COA_LF and COA_LF.SUMMON and COA_LF.SUMMON[c:GetEntry() - OFF]) then return end
    local ready = {}
    for i = 1, #list do ready[i] = 1 end
    pcall(function()
        c:RegisterEvent(function(_, _, _, a)
            local ow = a:GetOwner()
            if not (ow and Alive(a) and Alive(ow)) then return end
            for i, s in ipairs(list) do
                ready[i] = ready[i] - 1
                if ready[i] <= 0 then
                    local kind, t = s[2]
                    if kind == "self" then t = a
                    elseif kind == "ally" then t = ow
                    elseif kind == "heal" then t = HealTarget(a, ow)
                    else
                        t = a:GetVictim() or ow:GetVictim()
                        if not (Alive(t) and t:GetFaction() ~= ow:GetFaction() and (ow:IsInCombat() or a:IsInCombat())) then t = nil end
                        if t and kind == "fear" and t:HasAura(s[1]) then t = nil end
                    end
                    if t then
                        if kind == "enemy" or kind == "fear" then
                            pcall(function() a:PerformEmote(26) end)   -- one-shot attack animation (anim 17 in the converted ward model)
                            local snd = ATTACK_SOUND[a:GetEntry()]; if snd then pcall(function() a:PlayDistanceSound(snd) end) end
                        end
                        pcall(function() a:CastSpell(t, s[1], true) end)
                        ready[i] = (s[3] or COOLDOWN) / 2
                    end
                end
            end
        end, 2000, 0)
    end)
end

local n = 0
for entry in pairs(SPELLS) do RegisterCreatureEvent(entry, 5, Start); n = n + 1 end   -- 5 = ON_SPAWN
print(string.format("[coa_summon_ai] %d CoA summons get a spell loop", n))
