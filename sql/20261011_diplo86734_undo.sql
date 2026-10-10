-- UNDO: 20261011_diplo86734.sql.
UPDATE `world`.`quest_template` SET `AreaDescription` = '', `QuestCompletionLog` = '', `RewardBonusMoney` = 319000, `RewardNextQuest` = 0 WHERE `ID` = 86734;
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Hört dem Gespräch zu' WHERE `ID` = 459139 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Écoutez la discussion' WHERE `ID` = 459139 AND `locale` = 'frFR';
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 38452 AND `SourceEntry` IN (0, 1);
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 235787 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 86734;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 235787 AND `source_type` = 0 AND `id` IN (5, 6) AND `comment` LIKE '%86734%';
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` = 38452;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` = 38452;
DELETE FROM `world`.`npc_text` WHERE `ID` = 9500132;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900132;
DELETE FROM `world`.`creature` WHERE `guid` IN (3001001112, 3001001113, 3001001114);
