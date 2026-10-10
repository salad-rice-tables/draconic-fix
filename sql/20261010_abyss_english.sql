-- Into the Abyss EN-only: nec-anglicke locale riadky questov 89388/92061/86543 (deDE/frFR, ciastocne rozbite kodovanie)
-- prepisat default-anglickymi retail textami (Wowhead/Wiki overene). Klient v inom jazyku tak vzdy vidi anglictinu.
-- Povodne texty: world.custom_text_backup (src 'qtl'/'qol'/'qor'/'qri'). Undo: 20261010_abyss_english_undo.sql.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
CREATE TABLE IF NOT EXISTS `world`.`custom_text_backup` (`src` varchar(8) NOT NULL, `k` varchar(64) NOT NULL, `old` mediumtext, PRIMARY KEY (`src`,`k`));
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:LogTitle', `LogTitle` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:LogDescription', `LogDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:QuestDescription', `QuestDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:AreaDescription', `AreaDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:PortraitGiverText', `PortraitGiverText` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:PortraitGiverName', `PortraitGiverName` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:PortraitTurnInText', `PortraitTurnInText` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:PortraitTurnInName', `PortraitTurnInName` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '86543:deDE:QuestCompletionLog', `QuestCompletionLog` FROM `world`.`quest_template_locale` WHERE `ID` = 86543 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:LogTitle', `LogTitle` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:LogDescription', `LogDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:QuestDescription', `QuestDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:AreaDescription', `AreaDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:PortraitGiverText', `PortraitGiverText` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:PortraitGiverName', `PortraitGiverName` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:PortraitTurnInText', `PortraitTurnInText` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:PortraitTurnInName', `PortraitTurnInName` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '89388:deDE:QuestCompletionLog', `QuestCompletionLog` FROM `world`.`quest_template_locale` WHERE `ID` = 89388 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:LogTitle', `LogTitle` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:LogDescription', `LogDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:QuestDescription', `QuestDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:AreaDescription', `AreaDescription` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:PortraitGiverText', `PortraitGiverText` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:PortraitGiverName', `PortraitGiverName` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:PortraitTurnInText', `PortraitTurnInText` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:PortraitTurnInName', `PortraitTurnInName` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qtl', '92061:deDE:QuestCompletionLog', `QuestCompletionLog` FROM `world`.`quest_template_locale` WHERE `ID` = 92061 AND `locale` = 'deDE';
UPDATE `world`.`quest_template_locale` `l` JOIN `world`.`quest_template` `q` ON `q`.`ID` = `l`.`ID` SET `l`.`LogTitle` = `q`.`LogTitle`, `l`.`LogDescription` = `q`.`LogDescription`, `l`.`QuestDescription` = `q`.`QuestDescription`, `l`.`AreaDescription` = `q`.`AreaDescription`, `l`.`PortraitGiverText` = `q`.`PortraitGiverText`, `l`.`PortraitGiverName` = `q`.`PortraitGiverName`, `l`.`PortraitTurnInText` = `q`.`PortraitTurnInText`, `l`.`PortraitTurnInName` = `q`.`PortraitTurnInName`, `l`.`QuestCompletionLog` = `q`.`QuestCompletionLog` WHERE `l`.`ID` IN (89388, 92061, 86543);
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qol', CONCAT(`ID`, ':', `locale`), `Description` FROM `world`.`quest_objectives_locale` WHERE `QuestId` IN (89388, 92061, 86543);
UPDATE `world`.`quest_objectives_locale` `l` JOIN `world`.`quest_objectives` `o` ON `o`.`ID` = `l`.`ID` SET `l`.`Description` = `o`.`Description` WHERE `l`.`QuestId` IN (89388, 92061, 86543);
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qor', CONCAT(`ID`, ':', `locale`), `RewardText` FROM `world`.`quest_offer_reward_locale` WHERE `ID` IN (89388, 92061, 86543);
UPDATE `world`.`quest_offer_reward_locale` `l` JOIN `world`.`quest_template` `q` ON `q`.`ID` = `l`.`ID` SET `l`.`RewardText` = `q`.`QuestCompletionLog` WHERE `l`.`ID` IN (89388, 92061, 86543);
INSERT IGNORE INTO `world`.`custom_text_backup` SELECT 'qri', CONCAT(`ID`, ':', `locale`), `CompletionText` FROM `world`.`quest_request_items_locale` WHERE `ID` IN (89388, 92061, 86543);
UPDATE `world`.`quest_request_items_locale` `l` JOIN `world`.`quest_template` `q` ON `q`.`ID` = `l`.`ID` SET `l`.`CompletionText` = `q`.`QuestCompletionLog` WHERE `l`.`ID` IN (89388, 92061, 86543);
