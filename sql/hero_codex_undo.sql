-- Undo pre hero_codex.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900200;
DELETE FROM `hotfixes`.`item` WHERE `ID` = 9730002;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` = 9730002;
DELETE FROM `hotfixes`.`item_effect` WHERE `ID` = 9730002;
DELETE FROM `hotfixes`.`item_x_item_effect` WHERE `ID` = 9730002;
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` = 1402300;
DELETE FROM `hotfixes`.`spell` WHERE `ID` = 1402300;
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` = 1402300;
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` = 1402300;
