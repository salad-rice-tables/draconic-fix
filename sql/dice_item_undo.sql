-- Undo pre dice_item.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900210;
DELETE FROM `hotfixes`.`item` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_effect` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_x_item_effect` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` = 1402301;
DELETE FROM `hotfixes`.`spell` WHERE `ID` = 1402301;
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` = 1402301;
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` = 1402301;
