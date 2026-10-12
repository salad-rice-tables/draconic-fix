-- Undo pre worldforge_items.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900120;
DELETE FROM `hotfixes`.`item` WHERE `ID` BETWEEN 9700001 AND 9701383;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` BETWEEN 9700001 AND 9701383;
DELETE FROM `hotfixes`.`item_modified_appearance` WHERE `ID` BETWEEN 9700001 AND 9701383;
DROP TABLE IF EXISTS `world`.`worldforge_item`;
