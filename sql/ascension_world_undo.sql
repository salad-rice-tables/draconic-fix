-- Undo pre ascension_world.sql
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 9709998;
DROP TABLE IF EXISTS `characters`.`hero_bounty`;
