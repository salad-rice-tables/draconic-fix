-- Undo pre worldforge_objects.sql (aj spawny, ktore urobil worldforge.lua)
DELETE FROM `world`.`gameobject` WHERE `id` BETWEEN 9700004 AND 9701383;
DELETE FROM `world`.`gameobject_template` WHERE `entry` BETWEEN 9700004 AND 9701383;
DROP TABLE IF EXISTS `characters`.`worldforge_looted`;
UPDATE `world`.`worldforge_item` SET `spawn_guid` = 0;
