-- Undo pre wildcard_cooldowns.sql.
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1901801;
DELETE FROM `hotfixes`.`spell_cooldowns` WHERE `SpellID` IN (1410550);
