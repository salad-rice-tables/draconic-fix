-- UNDO: 20261010_broadcast_lang_fix.sql.
UPDATE `hotfixes`.`broadcast_text` SET `LanguageID` = 7 WHERE `ID` IN (9900122, 9900123);
