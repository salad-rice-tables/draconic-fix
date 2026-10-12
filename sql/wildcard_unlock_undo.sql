-- Undo pre wildcard_unlock.sql (push zaznamy prec; hodnoty v unlock_backup.csv).
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1901802;
