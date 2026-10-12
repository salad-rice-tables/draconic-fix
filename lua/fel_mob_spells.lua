-- =====================================================================
-- Fel Hunt mob abilities (weak custom versions via CastCustomSpell).
-- Spell IDs are verified from shipped SmartAI data (Felboar, Reaver kits)
-- so originals stay untouched. Self-buffs target the caster itself.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

-- {spellId, basePoints, cdMinSec, cdMaxSec, selfBuff?}
local KITS = {
    [95140] = { -- Felbound Hound (Satyrnaar)
        {spell = 35570, bp = 100, cdmin = 8, cdmax = 12},           -- Charge
        {spell = 33908, bp = 0, cdmin = 12, cdmax = 18, self = true}, -- Burning Spikes
        {spell = 1400000, bp = 50, cdmin = 10, cdmax = 14},         -- TEST custom spell
    },
    [95215] = { -- Felwing Terror (Satyrnaar skies)
        {spell = 184822, bp = 200, cdmin = 7, cdmax = 10},
        {spell = 184824, bp = 200, cdmin = 9, cdmax = 13},
    },
    [95218] = { -- Fel Lasher (Jadefire Run, rooted)
        {spell = 158082, bp = 150, cdmin = 6, cdmax = 9},
        {spell = 183863, bp = 150, cdmin = 8, cdmax = 12},
    },
    [95252] = { -- Felsworn Marauder (Felwood)
        {spell = 158082, bp = 300, cdmin = 7, cdmax = 10},
        {spell = 183863, bp = 300, cdmin = 8, cdmax = 12},
        {spell = 184824, bp = 300, cdmin = 10, cdmax = 14},
    },
    [95287] = { -- Fel Commander Urgoz (Mardum, boss)
        {spell = 184824, bp = 400, cdmin = 7, cdmax = 10},
        {spell = 197541, bp = 500, cdmin = 10, cdmax = 14}, -- Detonation
    },
    [95293] = { -- Felborne Overfiend (Jadefire, boss)
        {spell = 197541, bp = 700, cdmin = 9, cdmax = 13},
        {spell = 213583, bp = 400, cdmin = 6, cdmax = 9},
    },
}

local warned = false

local function CastTick(eventId, delay, repeats, creature)
    if not creature then return end
    local aliveOk, alive = pcall(function() return creature:IsAlive() end)
    local combatOk, combat = pcall(function() return creature:IsInCombat() end)
    if not aliveOk or not alive or not combatOk or not combat then return end
    local kit = KITS[creature:GetEntry()]
    if not kit then return end
    local pick = kit[math.random(#kit)]
    local target = creature
    if not pick.self then
        local vok, victim = pcall(function() return creature:GetVictim() end)
        if not vok or not victim then return end
        local aok, avive = pcall(function() return victim:IsAlive() end)
        if not aok or not avive then return end
        target = victim
    end
    local ok, err = pcall(function()
        creature:CastCustomSpell(target, pick.spell, true, pick.bp, 0, 0)
    end)
    if not ok and not warned then
        warned = true
        print("[fel-spells] CastCustomSpell failed: " .. tostring(err))
    end
    creature:RegisterEvent(CastTick, math.random(pick.cdmin * 1000, pick.cdmax * 1000), 1)
end

local function EnterCombat(event, creature, target)
    creature:RegisterEvent(CastTick, math.random(3000, 5000), 1)
end

local function LeaveOrDie(event, creature)
    creature:RemoveEvents()
end

for entry, _ in pairs(KITS) do
    RegisterCreatureEvent(entry, 1, EnterCombat) -- OnEnterCombat
    RegisterCreatureEvent(entry, 2, LeaveOrDie) -- OnLeaveCombat
    RegisterCreatureEvent(entry, 4, LeaveOrDie) -- OnDied
end

print("[fel-spells] loaded: Fel Hunt kits (hound/bat/lasher/marauder)")
