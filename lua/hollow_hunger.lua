-- =====================================================================
-- Quest 86515 Hollow Hunger v1: Severum 235495 fight VO (retail kits).
--   318550 "Hungry. So hungry."  -> enter combat (aggro)
--   318551 "More for the feast!" -> Severum kills a player (target died)
--  Sigil 236752 loot + areatrigger 9108445 consume credit 238379 already
--  exist (SQL 20261017_abyss15 = objective Flags/StorageIndex TDB align).
-- =====================================================================
if IS_WORLD_STATE then return end

local lastKillLine = 0

-- Ag: Severum sa chyti do boja
RegisterCreatureEvent(235495, 1, function(_, creature, target)
    if not (creature and target) then return end
    pcall(function() creature:SendUnitSay("Hungry. So hungry.", 0) end)
    pcall(function() creature:PlayDistanceSound(318550, target) end)
    pcall(function() PrintInfo("[hollowhunger] severum aggro") end)
end)

-- Severum zabije hraca -> "More for the feast!"
RegisterCreatureEvent(235495, 3, function(_, creature, victim)
    if not (creature and victim) then return end
    local okP, isP = pcall(function() return victim:IsPlayer() end)
    if not (okP and isP) then return end
    local now = os.time()
    if now - lastKillLine < 20 then return end
    lastKillLine = now
    pcall(function() creature:SendUnitSay("More for the feast!", 0) end)
    pcall(function() creature:PlayDistanceSound(318551, victim) end)
    pcall(function() PrintInfo("[hollowhunger] severum kill line") end)
end)

print("[hollow_hunger] loaded")
