-- Undo pre living_world4.sql
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900135, 9900136, 9900137);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900135, 9900136, 9900137);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900135, 9900136, 9900137);
DROP TABLE IF EXISTS `characters`.`inn_room`;
DROP TABLE IF EXISTS `world`.`lw_economy`;
