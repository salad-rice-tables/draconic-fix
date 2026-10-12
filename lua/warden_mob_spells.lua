-- =====================================================================
-- Warden campaign mob abilities (weak custom versions).
-- Betrayer wardens cast Fel Glaive / Deepening Shadows / Detonation with
-- heavily reduced base points via CastCustomSpell (originals would
-- one-shot players for ~220k). Tuned for the campaign level ranges.
-- Dolanaar mobs hit ~150-220, Ashenvale mobs ~250-400.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

-- {spellId, basePoints, cdMinSec, cdMaxSec}
local KITS = {
    [95114] = { -- Felsong Renegade (Dolanaar)
        {spell = 197333, bp = 180, cdmin = 6, cdmax = 9}, -- Fel Glaive (weak)
    },
    [95115] = { -- Shadowfen Betrayer (Dolanaar)
        {spell = 197333, bp = 180, cdmin = 7, cdmax = 10},
        {spell = 213583, bp = 120, cdmin = 9, cdmax = 13}, -- Deepening Shadows (weak)
    },
    [95116] = { -- Talonbreaker Renegade (Dolanaar)
        {spell = 197333, bp = 220, cdmin = 6, cdmax = 9},
    },
    [95124] = { -- Ashenfall Betrayer (Ashenvale)
        {spell = 213583, bp = 250, cdmin = 7, cdmax = 10},
    },
    [95125] = { -- Pineshadow Turncloak (Ashenvale)
        {spell = 213583, bp = 250, cdmin = 7, cdmax = 10},
        {spell = 197333, bp = 250, cdmin = 8, cdmax = 12},
    },
    [95126] = { -- Felbriar Warden (Ashenvale, biggest)
        {spell = 197541, bp = 400, cdmin = 9, cdmax = 13}, -- Detonation (weak AoE)
        {spell = 213583, bp = 250, cdmin = 7, cdmax = 10},
    },
    [95127] = { -- Duskwarden Turncoat (Jadefire Run)
        {spell = 197333, bp = 300, cdmin = 6, cdmax = 9},
    },
    [95128] = { -- Felsworn Warden (Thistlefur Den)
        {spell = 213583, bp = 300, cdmin = 7, cdmax = 10},
    },
    [95129] = { -- High Betrayer Sarthis (boss)
        {spell = 197541, bp = 600, cdmin = 9, cdmax = 13},
        {spell = 213583, bp = 350, cdmin = 6, cdmax = 9},
    },
}

local warned = false

local function CastTick(eventId, delay, repeats, creature)
    if not creature then return end
    local aliveOk, alive = pcall(function() return creature:IsAlive() end)
    local combatOk, combat = pcall(function() return creature:IsInCombat() end)
    if not aliveOk or not alive or not combatOk or not combat then return end
    local vok, victim = pcall(function() return creature:GetVictim() end)
    if not vok or not victim then return end
    local aok, avive = pcall(function() return victim:IsAlive() end)
    if not aok or not avive then return end
    local kit = KITS[creature:GetEntry()]
    if not kit then return end
    local pick = kit[math.random(#kit)]
    local ok, err = pcall(function()
        creature:CastCustomSpell(victim, pick.spell, true, pick.bp, 0, 0)
    end)
    if not ok and not warned then
        warned = true
        print("[warden-spells] CastCustomSpell failed: " .. tostring(err))
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

print("[warden-spells] loaded: weak Fel Glaive / Deepening Shadows / Detonation")
