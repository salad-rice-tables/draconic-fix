-- Undo pre inn_rooms.sql
DELETE FROM `world`.`gameobject` WHERE `guid` BETWEEN 3100200001 AND 3100201000;
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 9709997;
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900180;
DELETE FROM `hotfixes`.`item` WHERE `ID` = 9730001;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` = 9730001;
