-- Into the Abyss phases 3/3: missing objective-NPC spawns (POI points with no NPC).
-- A) Bellamy 250587 (Vanguard consulted, 92061): only spawn was map 2912 (Void-mob map, not Silvermoon).
--    Wiki: Shining Span [45.7,46.4] Silvermoon City. Objective POI point: (8911,-4616,23) map 0.
--    Custom spawn into phase 45749 'Rising Storm' (objectives run there; Turalyon has a spawn there).
--    Orientation unverified (POI has no facing) - follow-up. npcflag NULL = template default 3 (gossip+quest).
--    NOTE: this spawn (guid 3001001105) was later REMOVED by 20261010_abyss_wiki4.sql (hostile twin, use friendly 9100622).
-- B) Umbric 239944 (starter 86543): retail spawn only in phase 45584; players in phase 46726 cannot see him.
--    Exact copy of spawn 3000207639 with PhaseId 46726 (pattern: 20261010_lorthemar_46726.sql).
-- Do NOT apply while players are testing; deploy before restart.
INSERT IGNORE INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001105, 250587, 0, 15969, 0, '0', 0, 45749, 0, -1, 0, 0, 8911, -4616, 23, 0, 300, 0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1);
INSERT IGNORE INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001106, 239944, 0, 15969, 0, '0', 0, 46726, 0, -1, 0, 1, 8450.58, -4624.54, 48.2726, 0.530818, 300, 0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1);
