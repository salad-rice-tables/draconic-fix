-- Zul'Aman/Eversong giveri podla wowheadu (aditivne, idempotentne).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
-- 93409 starter Fallen Amani Scout 254726 (spawnuty); ender Tavikko uz je.
-- 96388 starter+ender Depthdiver Jeju 9504160 (SPAWNUTY dvojnik; 240195 spawn nema).
-- 91829/30/31 starter Valeera 248982 (spawnuta); ender Blood Elf Spy (spawn nizsie).
-- 94867 starter Vakala 258950 (spawnuty); ender Jehnira uz je.
INSERT IGNORE INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(254726, 93409, 0),
(9504160, 96388, 0),
(248982, 91829, 0),
(248982, 91830, 0),
(248982, 91831, 0),
(258950, 94867, 0);
INSERT IGNORE INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(9504160, 96388, 0),
(250295, 91829, 0),
(250295, 91830, 0),
(250295, 91831, 0);
-- Depthdiver Jeju 9504160 template nema questgiver flag (0) -> 3 ako ostatne (gossip+quest).
UPDATE `world`.`creature_template` SET `npcflag` = 3 WHERE `entry` = 9504160 AND `npcflag` = 0;
-- Blood Elf Spy 250295 spawn vedla Valeery (rovnaka terasa 287, APPROX pozicia).
-- Guid 3001001102 overeny volny rozsah custom guidov.
DELETE FROM `world`.`creature` WHERE `guid` = 3001001102;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001001102, 250295, 0, 15947, 0, '0', 0, 0, 0, -1, 0, 0, 4029.5, -7257.5, 287.0, 4.55, 120, 0, 0, NULL, 0, 2, NULL, NULL, NULL, '', NULL, 0, -1);
