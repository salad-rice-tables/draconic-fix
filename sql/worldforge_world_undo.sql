-- Undo pre worldforge_world.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900140;
DELETE FROM `hotfixes`.`item` WHERE `ID` BETWEEN 9720001 AND 9723399;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` BETWEEN 9720001 AND 9723399;
DELETE FROM `hotfixes`.`item_modified_appearance` WHERE `ID` BETWEEN 9720001 AND 9723399;
DELETE FROM `world`.`gameobject` WHERE `guid` BETWEEN 3100000001 AND 3100004320;
DELETE FROM `world`.`gameobject_template` WHERE `entry` BETWEEN 9720001 AND 9723399;
DELETE FROM `world`.`worldforge_item` WHERE `item` BETWEEN 9720001 AND 9723399;
