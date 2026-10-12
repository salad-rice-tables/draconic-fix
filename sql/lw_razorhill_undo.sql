-- Undo pre lw_razorhill.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000964 AND 3001000980;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900123;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900123;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900123;
