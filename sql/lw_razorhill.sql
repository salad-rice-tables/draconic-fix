-- =====================================================================
-- Living World: Razor Hill ozije. Faza 9600. Undo: lw_razorhill_undo.sql
--  9900123 Razor Hill Villager (kopia Orc Commoner 152293, 4 vzhlady)
--  spawny 3001000964-3001000980: 10 obyvatelov, 4 robotnici (9900122),
--  3 trolovia (9900121) - posunute od miest, kde stoja NPC Razor Hill
-- =====================================================================

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 152293;
UPDATE `world`.`tmp_ct` SET `entry` = 9900123, `name` = 'Razor Hill Villager', `subname` = NULL, `faction` = 29, `npcflag` = 1,
       `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900123;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900123;
INSERT INTO `world`.`creature_template_model`
SELECT 9900123, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, 0 FROM `world`.`creature_template_model` WHERE `CreatureID` = 152293;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE `Entry` = 152293 AND `DifficultyID` = 0;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900123;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900123;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;

-- miesta: NPC Razor Hill (bez strazi a eventovych), posunute o par yardov
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_spot`;
CREATE TEMPORARY TABLE `world`.`tmp_spot` (`n` int, `x` float, `y` float, `z` float, `o` float)
SELECT ROW_NUMBER() OVER (ORDER BY c.guid) AS n, c.position_x + 2.5 AS x, c.position_y - 2 AS y, c.position_z AS z, c.orientation AS o
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.areaId = 362 AND t.type = 7 AND c.id NOT IN (5953, 23537, 23971, 23973, 6491)
   AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0
 ORDER BY c.guid LIMIT 17;

DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000964 AND 3001000980;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`)
SELECT 3001000963 + s.n,
       CASE WHEN s.n <= 10 THEN 9900123 WHEN s.n <= 14 THEN 9900122 ELSE 9900121 END,
       1, 14, 362, '0', 0, 9600, 0, -1, 0, 0, s.x, s.y, s.z, s.o, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1
  FROM `world`.`tmp_spot` s;
SELECT id, COUNT(*) spawned FROM `world`.`creature` WHERE `guid` BETWEEN 3001000964 AND 3001000980 GROUP BY id;
DROP TEMPORARY TABLE `world`.`tmp_spot`;
