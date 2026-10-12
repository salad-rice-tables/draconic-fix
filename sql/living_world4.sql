-- =====================================================================
-- Living world v4: travelling NPC templates (9900135-9900137), spawned and
-- walked along the roads by lua/living_world4.lua; inn rooms table.
-- Undo: living_world4_undo.sql
-- =====================================================================
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900135;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900135;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900135;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 190399;
UPDATE `world`.`tmp_ct` SET `entry` = 9900135, `name` = 'Wandering Merchant', `subname` = 'Traveler', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900135, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 190399;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 190399 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900135;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900136;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900136;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900136;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 33624;
UPDATE `world`.`tmp_ct` SET `entry` = 9900136, `name` = 'Pilgrim of the Light', `subname` = 'Traveler', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900136, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 33624;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 33624 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900136;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900137;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900137;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900137;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900120;
UPDATE `world`.`tmp_ct` SET `entry` = 9900137, `name` = 'Wandering Adventurer', `subname` = 'Traveler', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900137, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900120;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900120 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900137;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
CREATE TABLE IF NOT EXISTS `characters`.`inn_room` (
  `name` varchar(12) NOT NULL, `map` int unsigned NOT NULL, `x` float NOT NULL, `y` float NOT NULL, `z` float NOT NULL,
  `area` int unsigned NOT NULL, `until_ts` int unsigned NOT NULL, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `world`.`lw_economy` (`city` varchar(16) NOT NULL, `trade` int NOT NULL DEFAULT 0, PRIMARY KEY (`city`)) ENGINE=InnoDB;
