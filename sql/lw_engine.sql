-- =====================================================================
-- Living World engine v1: trasy + karavany. Logika: Custom/lua/lw_engine.lua
-- Undo: lw_engine_undo.sql
-- NPC: 9900110 Caravan Master, 9900111 Caravan Kodo (vozidlo, kopia 34576),
--      9900112 Caravan Guard
-- =====================================================================

CREATE TABLE IF NOT EXISTS `world`.`lw_route_node` (
  `route` int unsigned NOT NULL,
  `idx` int unsigned NOT NULL,
  `map` int unsigned NOT NULL,
  `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL,
  `stop` varchar(48) DEFAULT NULL COMMENT 'meno osady, ak tu karavana zastavi',
  `wait_s` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`route`, `idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `world`.`lw_caravan` (
  `route` int unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `master_entry` int unsigned NOT NULL DEFAULT '9900110',
  `kodo_entry` int unsigned NOT NULL DEFAULT '9900111',
  `guard_entry` int unsigned NOT NULL DEFAULT '9900112',
  `guards` tinyint unsigned NOT NULL DEFAULT '2',
  `copper_per_yard` int unsigned NOT NULL DEFAULT '2',
  `pingpong` tinyint unsigned NOT NULL DEFAULT '1' COMMENT '1 = na konci sa otoci',
  PRIMARY KEY (`route`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --- NPC sablony: kopie existujucich retail NPC, zmenene ID/meno/frakcia ---
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` IN (34261, 34576, 3296);
UPDATE `world`.`tmp_ct` SET `entry` = 9900110, `name` = 'Caravan Master Grukk', `subname` = 'Durotar Caravans', `npcflag` = 1, `faction` = 29, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0 WHERE `entry` = 34261;
UPDATE `world`.`tmp_ct` SET `entry` = 9900111, `name` = 'Caravan Kodo', `subname` = NULL, `npcflag` = 0, `faction` = 29, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0 WHERE `entry` = 34576;
UPDATE `world`.`tmp_ct` SET `entry` = 9900112, `name` = 'Caravan Guard', `subname` = NULL, `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0 WHERE `entry` = 3296;
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900110, 9900111, 9900112);
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cm`;
CREATE TEMPORARY TABLE `world`.`tmp_cm` SELECT * FROM `world`.`creature_template_model` WHERE `CreatureID` IN (34261, 34576, 3296);
UPDATE `world`.`tmp_cm` SET `CreatureID` = 9900110 WHERE `CreatureID` = 34261;
UPDATE `world`.`tmp_cm` SET `CreatureID` = 9900111 WHERE `CreatureID` = 34576;
UPDATE `world`.`tmp_cm` SET `CreatureID` = 9900112 WHERE `CreatureID` = 3296;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900110, 9900111, 9900112);
INSERT INTO `world`.`creature_template_model` SELECT * FROM `world`.`tmp_cm`;
DROP TEMPORARY TABLE `world`.`tmp_cm`;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (34261, 34576, 3296) AND `DifficultyID` = 0;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900110 WHERE `Entry` = 34261;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900111 WHERE `Entry` = 34576;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900112 WHERE `Entry` = 3296;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900110, 9900111, 9900112);
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;

-- Pilot: trasa 1 Orgrimmar - Razor Hill - Sen'jin (body sa nahraju v hre: .lw rec)
DELETE FROM `world`.`lw_caravan` WHERE `route` = 1;
INSERT INTO `world`.`lw_caravan` (`route`, `name`, `guards`, `copper_per_yard`, `pingpong`) VALUES
(1, 'Durotar Road Caravan', 2, 2, 1);
