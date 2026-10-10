-- Gossip texts 9900122/9900123 had LanguageID=7 (Common): Horde players see scrambled text ("Ver nostyec ruftos").
-- Retail gossip broadcasts are universal => LanguageID=0. Only our 2 rows changed (9900101-9900103 share the pattern, follow-up).
-- Do NOT apply while players are testing; deploy before restart.
UPDATE `hotfixes`.`broadcast_text` SET `LanguageID` = 0 WHERE `ID` IN (9900122, 9900123);
