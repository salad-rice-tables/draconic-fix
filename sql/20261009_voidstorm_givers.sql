-- Voidstorm giveri podla wowheadu (aditivne, idempotentne).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
-- 86810 starter Selune (ender uz je); 93426 ender Zerella (starter uz je);
-- 93428 ender Perodius (start = miesto Shadowguard Point, auto);
-- 93999/94052/94056 starter+ender Vidious + spawn (APPROX: zona 15958 stred, zem -150).
INSERT IGNORE INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(248114, 86810, 0),
(257130, 93999, 0),
(257130, 94052, 0),
(257130, 94056, 0);
INSERT IGNORE INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(254971, 93426, 0),
(254765, 93428, 0),
(257130, 93999, 0),
(257130, 94052, 0),
(257130, 94056, 0);
DELETE FROM `world`.`creature` WHERE `guid` = 3001001103;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001001103, 257130, 2771, 15958, 0, '0', 0, 0, 0, -1, 0, 0, 3800.0, -1010.0, -150.0, 1.6, 120, 0, 0, NULL, 0, 2, NULL, NULL, NULL, '', NULL, 0, -1);
