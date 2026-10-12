-- Undo pre lw_crossroads.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000992 AND 3001001004;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900124, 9900125);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900124, 9900125);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900124, 9900125);
