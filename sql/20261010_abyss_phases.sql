-- Into the Abyss fazy 3/3: chybajuce spawny objektivovych NPC (POI body bez NPC).
-- A) Bellamy 250587 (Vanguard consulted, 92061): jediny spawn je mapa 2912 (Void-moba mapa, nie Silvermoon).
--    Wiki: Shining Span [45.7,46.4] Silvermoon City. POI bod objektivu: (8911,-4616,23) mapa 0.
--    Custom spawn do fazy 45749 'Rising Storm' (tam prebiehaju objektivy, Turalyon tam spawn ma).
--    Orientacia neverifikovana (POI nema smer) - follow-up. npcflag NULL = template default 3 (gossip+quest).
--    Gossip link 250587->40411 uz existuje (wiki3), plati pre kazdy spawn entry.
-- B) Umbric 239944 (starter 86543): retail spawn len vo faze 45584; hrac vo faze 46726 ho nevidi.
--    Presna kopia spawnu 3000207639, len PhaseId 46726 (vzor: 20261010_lorthemar_46726.sql).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
INSERT IGNORE INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001105, 250587, 0, 15969, 0, '0', 0, 45749, 0, -1, 0, 0, 8911, -4616, 23, 0, 300, 0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1);
INSERT IGNORE INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001106, 239944, 0, 15969, 0, '0', 0, 46726, 0, -1, 0, 1, 8450.58, -4624.54, 48.2726, 0.530818, 300, 0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1);
