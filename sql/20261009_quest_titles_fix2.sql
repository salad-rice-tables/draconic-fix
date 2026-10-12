-- Nazvy podla wowheadu (najdene exhaustive checkom). NEAPLIKOVAT pocas testu hráča.
-- 46727/50668: retail ma prefix "Battle for Azeroth: ".
-- 49852: preklep "Pandari" + prefix navyse.
UPDATE `world`.`quest_template` SET `LogTitle` = 'Battle for Azeroth: Tides of War' WHERE `ID` = 46727;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Battle for Azeroth: Tides of War' WHERE `ID` = 50668;
UPDATE `world`.`quest_template` SET `LogTitle` = 'To Pandaria!' WHERE `ID` = 49852;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Arathi Donations: Tidespray Linen' WHERE `ID` = 53226;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Arathi Donations: Versatile Kyanite' WHERE `ID` = 53238;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Arathi Donations: Straddling Viridium' WHERE `ID` = 53258;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Arathi Donations: Incendiary Ammunition' WHERE `ID` = 53260;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Arathi Donations: Frost-Laced Ammunition' WHERE `ID` = 53261;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Choosing Your Purpose' WHERE `ID` = 57878;
UPDATE `world`.`quest_template` SET `LogTitle` = 'The Master of Lies' WHERE `ID` = 58086;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Mnemis, At Your Service' WHERE `ID` = 58980;
UPDATE `world`.`quest_template` SET `LogTitle` = 'On Swift Wings' WHERE `ID` = 59198;
UPDATE `world`.`quest_template` SET `LogTitle` = 'The Brand Holds the Key' WHERE `ID` = 59959;
