-- Gossip texty 9900122/9900123 mali LanguageID=7 (Common): Horde hrac vidi scramblovany text ("Ver nostyec ruftos").
-- Retail gossip broadcasty su univerzalne => LanguageID=0. Menene len nase 2 riadky (pattern zdielaju aj 9900101-9900103, follow-up).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `hotfixes`.`broadcast_text` SET `LanguageID` = 0 WHERE `ID` IN (9900122, 9900123);
