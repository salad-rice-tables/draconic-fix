-- =====================================================================
-- Living World: hliadky. Logika: Custom/lua/lw_patrol.lua. Undo: lw_patrol_undo.sql
-- NPC: 9900113 Patrol Sergeant (cestna hliadka), 9900114 Night Watch Captain
-- Trasy: 1 = Orgrimmar - Razor Hill - Sen'jin, 2 = nocny okruh Orgrimmarom
-- (body sa nahraju v hre cez .lw rec)
-- =====================================================================

CREATE TABLE IF NOT EXISTS `world`.`lw_patrol` (
  `id` int unsigned NOT NULL,
  `name` varchar(64) NOT NULL,
  `route` int unsigned NOT NULL,
  `leader_entry` int unsigned NOT NULL,
  `member_entry` int unsigned NOT NULL,
  `members` tinyint unsigned NOT NULL DEFAULT '2',
  `loop_route` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '1 = okruh, 0 = tam a spat',
  `camp_chance` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '% na bod trasy, ze si spravia taborak',
  `camp_minutes` tinyint unsigned NOT NULL DEFAULT '10',
  `night_only` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 3296;
UPDATE `world`.`tmp_ct` SET `entry` = 9900113, `name` = 'Patrol Sergeant', `subname` = 'Durotar Road Watch', `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 3296;
UPDATE `world`.`tmp_ct` SET `entry` = 9900114, `name` = 'Night Watch Captain', `subname` = 'Orgrimmar Watch', `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0 WHERE `entry` = 3296;
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900113, 9900114);
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900113, 9900114);
INSERT INTO `world`.`creature_template_model` SELECT 9900113, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, 0 FROM `world`.`creature_template_model` WHERE `CreatureID` = 3296;
INSERT INTO `world`.`creature_template_model` SELECT 9900114, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, 0 FROM `world`.`creature_template_model` WHERE `CreatureID` = 3296;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE `Entry` = 3296 AND `DifficultyID` = 0;
INSERT INTO `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE `Entry` = 3296 AND `DifficultyID` = 0;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900113 LIMIT 1;
UPDATE `world`.`tmp_cd` SET `Entry` = 9900114 WHERE `Entry` = 3296;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900113, 9900114);
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;

DELETE FROM `world`.`lw_patrol` WHERE `id` IN (1, 2);
INSERT INTO `world`.`lw_patrol` (`id`, `name`, `route`, `leader_entry`, `member_entry`, `members`, `loop_route`, `camp_chance`, `camp_minutes`, `night_only`) VALUES
(1, 'Durotar Road Patrol', 1, 9900113, 3296, 4, 0, 3, 10, 0),
(2, 'Orgrimmar Night Watch', 2, 9900114, 3296, 2, 1, 0, 0, 1);
