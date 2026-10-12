-- Undo pre challenges.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002200001 AND 3002200100;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900133;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900133;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900133;
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900150;
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` BETWEEN 1400 AND 1406;
DROP TABLE IF EXISTS `characters`.`hero_challenge`;
