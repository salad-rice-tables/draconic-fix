-- Undo pre mystic_altars.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002100001 AND 3002100100;
DELETE FROM `world`.`gameobject` WHERE `guid` BETWEEN 3100100001 AND 3100100100;
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 9709999;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900130, 9900131, 9900132);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900130, 9900131, 9900132);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900130, 9900131, 9900132);
DROP TABLE IF EXISTS `characters`.`mystic_runes`;
DROP TABLE IF EXISTS `characters`.`mystic_rune_claim`;
