-- UNDO: 20261010_rising_storm_wiki.sql (Rising Storm 92061 Wiki fix).
-- Quest texty spat na predosle hodnoty (Completion prazdny, Progress prazdny, 309800, next 0).
UPDATE `world`.`quest_template` SET `QuestCompletionLog` = '', `AreaDescription` = '', `RewardBonusMoney` = 309800, `RewardNextQuest` = 0 WHERE `ID` = 92061;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (250580, 250587) AND `source_type` = 0 AND `event_type` = 62 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`creature_text` WHERE `CreatureID` IN (250580, 250587) AND `GroupID` = 0 AND `comment` = 'Rising Storm 92061 wiki';
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` IN (40410, 40411);
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` IN (40410, 40411);
DELETE FROM `world`.`npc_text` WHERE `ID` IN (9500122, 9500123);
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` IN (9900122, 9900123);
