-- Tuning cooldownov klonov (tune_cooldowns.py). Push 1901801.
-- Zdroj: data/cooldowns.csv. Undo: wildcard_cooldowns_undo.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1901801;
DELETE FROM `hotfixes`.`spell_cooldowns` WHERE `SpellID` IN (1410550);
INSERT INTO `hotfixes`.`spell_cooldowns` (`ID`, `DifficultyID`, `CategoryRecoveryTime`, `RecoveryTime`, `StartRecoveryTime`, `AuraSpellID`, `SpellID`, `VerifiedBuild`) VALUES
(1460318, 0, 0, 6000, 0, 0, 1410550, 69933);
INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(1901801, 4289422977, 4193483863, 1460318, 1, 69933);
