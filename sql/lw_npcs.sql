-- =====================================================================
-- Living World: vlastne NPC (kopie retail sablon s nasimi ID), aby nase
-- skripty riadili iba nase NPC a nemiesali sa do retail entry.
--  9900115 Durotar Road Grunt   (clen cestnej hliadky, kopia 5953)
--  9900116 Orgrimmar Night Watch (clen nocnej straze, kopia 3296)
--  9900120 Orgrimmar Citizen    (23 vzhladov, kopia 156508)
--  9900121 Darkspear Villager   (kopia 152294)
--  9900122 Orgrimmar Laborer    (peon, kopia 85203)
-- Spawny: guid 3001000901-3001000960 v Orgrimmari. Undo: lw_npcs_undo.sql
-- =====================================================================

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_map`;
CREATE TEMPORARY TABLE `world`.`tmp_map` (`src` int unsigned, `dst` int unsigned, `nm` varchar(64), `sub` varchar(64), `fac` int unsigned, `flag` bigint unsigned);
INSERT INTO `world`.`tmp_map` VALUES
(5953,   9900115, 'Durotar Road Grunt',    'Road Watch',      85, 0),
(3296,   9900116, 'Orgrimmar Night Watch', NULL,              85, 0),
(156508, 9900120, 'Orgrimmar Citizen',     NULL,              29, 1),
(152294, 9900121, 'Darkspear Villager',    NULL,             126, 1),
(85203,  9900122, 'Orgrimmar Laborer',     NULL,              29, 1);

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT t.* FROM `world`.`creature_template` t JOIN `world`.`tmp_map` m ON m.src = t.entry;
UPDATE `world`.`tmp_ct` t JOIN `world`.`tmp_map` m ON m.src = t.entry
   SET t.entry = m.dst, t.name = m.nm, t.subname = m.sub, t.faction = m.fac, t.npcflag = m.flag,
       t.ScriptName = '', t.AIName = '', t.VerifiedBuild = 0;
DELETE FROM `world`.`creature_template` WHERE `entry` IN (SELECT `dst` FROM `world`.`tmp_map`);
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (SELECT `dst` FROM `world`.`tmp_map`);
INSERT INTO `world`.`creature_template_model`
SELECT m.dst, x.Idx, x.CreatureDisplayID, x.DisplayScale, x.Probability, 0
  FROM `world`.`creature_template_model` x JOIN `world`.`tmp_map` m ON m.src = x.CreatureID;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT d.* FROM `world`.`creature_template_difficulty` d JOIN `world`.`tmp_map` m ON m.src = d.Entry WHERE d.DifficultyID = 0;
UPDATE `world`.`tmp_cd` d JOIN `world`.`tmp_map` m ON m.src = d.Entry SET d.Entry = m.dst;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (SELECT `dst` FROM `world`.`tmp_map`);
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;

-- hliadky pouzivaju nase grunty namiesto retail 3296
UPDATE `world`.`lw_patrol` SET `member_entry` = 9900115 WHERE `id` = 1;
UPDATE `world`.`lw_patrol` SET `member_entry` = 9900116 WHERE `id` = 2;

-- --- spawny: na mieste, kde uz stoja obyvatelia/robotnici, posunute o par yardov ---
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000901 AND 3001000960;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_spot`;
CREATE TEMPORARY TABLE `world`.`tmp_spot` (`n` int AUTO_INCREMENT PRIMARY KEY, `kind` int, `x` float, `y` float, `z` float, `o` float);
-- 24 obcanov pri miestach, kde stoja ludia s gossipom alebo bez sluzby
INSERT INTO `world`.`tmp_spot` (`kind`, `x`, `y`, `z`, `o`)
SELECT 9900120, c.position_x + 2.5, c.position_y + 1.5, c.position_z, c.orientation
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.zoneId = 1637 AND t.type = 7 AND t.npcflag IN (0, 1) AND t.faction NOT IN (85, 83, 14)
   AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0 AND c.position_z < 60
 ORDER BY c.guid LIMIT 24;
-- 8 trollov vo Valley of Spirits (pri Darkspear NPC)
INSERT INTO `world`.`tmp_spot` (`kind`, `x`, `y`, `z`, `o`)
SELECT 9900121, c.position_x - 2.5, c.position_y + 2, c.position_z, c.orientation
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.zoneId = 1637 AND t.name LIKE 'Darkspear%' AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0
 ORDER BY c.guid LIMIT 8;
-- 8 robotnikov pri peonoch/robotnikoch
INSERT INTO `world`.`tmp_spot` (`kind`, `x`, `y`, `z`, `o`)
SELECT 9900122, c.position_x + 2, c.position_y - 2, c.position_z, c.orientation
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.zoneId = 1637 AND (t.name LIKE '%Peon%' OR t.name LIKE '%Siegeworker%' OR t.name LIKE '%Laborer%')
   AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0
 ORDER BY c.guid LIMIT 8;

INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`)
SELECT 3001000900 + ROW_NUMBER() OVER (ORDER BY s.n), s.kind, 1, 1637, 0, '0', 0, 0, 0, -1, 0, 0, s.x, s.y, s.z, s.o, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1
  FROM `world`.`tmp_spot` s;
SELECT kind, COUNT(*) spawned FROM `world`.`tmp_spot` GROUP BY kind;
DROP TEMPORARY TABLE `world`.`tmp_spot`;
DROP TEMPORARY TABLE `world`.`tmp_map`;
