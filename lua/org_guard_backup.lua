-- =====================================================================
-- Orgrimmar guard backup: when a city guard drops under 50% in combat,
-- he whistles (yell) and two backup grunts run in. Once per combat.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local GUARD_ENTRIES = {144288, 3296, 156731, 140750, 173279, 143964}
local BACKUP_ENTRY  = 3296      -- Orgrimmar Grunt
local HP_THRESHOLD  = 50        -- percent
local CHECK_MS      = 3000      -- re-check interval while in combat

local function GuardBackupCheck(_, _, _, creature)
    if not creature or not creature:IsAlive() then return end
    if not creature:IsInCombat() then return end
    if creature:Data():Get("org_backup_called") == 1 then return end
    if creature:GetHealthPct() >= HP_THRESHOLD then
        creature:RegisterEvent(GuardBackupCheck, CHECK_MS, 1)
        return
    end
    -- call for help
    creature:Data():Set("org_backup_called", 1)
    creature:SendUnitYell("To arms! To me! The city is attacked!", 0)
    creature:PerformEmote(5)
    local x, y, z, o = creature:GetLocation()
    local victim = creature:GetVictim()
    for i = 1, 2 do
        local ox = x + (i * 3 - 1.5)
        local guard = creature:SpawnCreature(BACKUP_ENTRY, ox, y + 2, z, o, 60)
        if guard and victim and victim:IsAlive() then
            guard:AttackStart(victim)
        end
    end
end

local function GuardEnterCombat(event, creature, target)
    creature:Data():Set("org_backup_called", 0)
    creature:RegisterEvent(GuardBackupCheck, CHECK_MS, 1)
end

local function GuardReset(event, creature)
    creature:Data():Set("org_backup_called", 0)
    creature:RemoveEvents()
end

for _, entry in ipairs(GUARD_ENTRIES) do
    RegisterCreatureEvent(entry, 1, GuardEnterCombat)  -- OnEnterCombat
    RegisterCreatureEvent(entry, 2, GuardReset)        -- OnLeaveCombat
    RegisterCreatureEvent(entry, 4, GuardReset)        -- OnDied
end

print("[OrgGuardBackup] loaded")
