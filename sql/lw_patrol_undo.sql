-- Undo pre lw_patrol.sql
DELETE FROM `world`.`creature` WHERE `id` IN (9900113, 9900114);
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900113, 9900114);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900113, 9900114);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900113, 9900114);
DROP TABLE IF EXISTS `world`.`lw_patrol`;
