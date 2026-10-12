-- =====================================================================
-- Living World: The Crossroads (Northern Barrens, area 380) ozije. Faza 9600.
--  9900124 Crossroads Settler (kopia Orc Commoner 152293)
--  9900125 Mulgore Wanderer   (tauren, kopia Tauren Commoner 19176)
-- Spawny 3001000992-3001001004: 8 osadnikov, 3 tauri, 2 robotnici.
-- Undo: lw_crossroads_undo.sql
-- =====================================================================

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_map`;
CREATE TEMPORARY TABLE `world`.`tmp_map` (`src` int unsigned, `dst` int unsigned, `nm` varchar(64), `fac` int unsigned);
INSERT INTO `world`.`tmp_map` VALUES (152293, 9900124, 'Crossroads Settler', 29), (19176, 9900125, 'Mulgore Wanderer', 104);

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT t.* FROM `world`.`creature_template` t JOIN `world`.`tmp_map` m ON m.src = t.entry;
UPDATE `world`.`tmp_ct` t JOIN `world`.`tmp_map` m ON m.src = t.entry
   SET t.entry = m.dst, t.name = m.nm, t.subname = NULL, t.faction = m.fac, t.npcflag = 1, t.ScriptName = '', t.AIName = '', t.VerifiedBuild = 0;
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900124, 9900125);
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900124, 9900125);
INSERT INTO `world`.`creature_template_model`
SELECT m.dst, x.Idx, x.CreatureDisplayID, x.DisplayScale, x.Probability, 0
  FROM `world`.`creature_template_model` x JOIN `world`.`tmp_map` m ON m.src = x.CreatureID;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT d.* FROM `world`.`creature_template_difficulty` d JOIN `world`.`tmp_map` m ON m.src = d.Entry WHERE d.DifficultyID = 0;
UPDATE `world`.`tmp_cd` d JOIN `world`.`tmp_map` m ON m.src = d.Entry SET d.Entry = m.dst;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900124, 9900125);
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_map`;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_spot`;
CREATE TEMPORARY TABLE `world`.`tmp_spot` (`n` int, `x` float, `y` float, `z` float, `o` float)
SELECT ROW_NUMBER() OVER (ORDER BY c.guid) AS n, c.position_x + 2.5 AS x, c.position_y - 2 AS y, c.position_z AS z, c.orientation AS o
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.areaId = 380 AND t.type = 7 AND t.name NOT LIKE '%Watch%' AND t.name NOT LIKE '%Grunt%'
   AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0
 ORDER BY c.guid LIMIT 13;

DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000992 AND 3001001004;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`)
SELECT 3001000991 + s.n, CASE WHEN s.n <= 8 THEN 9900124 WHEN s.n <= 11 THEN 9900125 ELSE 9900122 END,
       1, 17, 380, '0', 0, 9600, 0, -1, 0, 0, s.x, s.y, s.z, s.o, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1
  FROM `world`.`tmp_spot` s;
DROP TEMPORARY TABLE `world`.`tmp_spot`;
SELECT id, COUNT(*) spawned FROM `world`.`creature` WHERE guid BETWEEN 3001000992 AND 3001001004 GROUP BY id;
