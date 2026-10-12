-- Undo pre mystic_items.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900650;
DELETE FROM `hotfixes`.`item` WHERE `ID` IN (9730030,9730031);
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` IN (9730030,9730031);
DELETE FROM `hotfixes`.`item_effect` WHERE `ID` IN (9730030,9730031);
DELETE FROM `hotfixes`.`item_x_item_effect` WHERE `ID` IN (9730030,9730031);
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` IN (1402340,1402341);
DELETE FROM `hotfixes`.`spell` WHERE `ID` IN (1402340,1402341);
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` IN (1402340,1402341);
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` IN (1402340,1402341);
