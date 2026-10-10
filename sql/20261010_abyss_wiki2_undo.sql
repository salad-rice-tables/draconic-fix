-- UNDO: 20261010_abyss_wiki2.sql.
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 235411 AND `quest` = 89388 AND `VerifiedBuild` = 0;
UPDATE `world`.`quest_template` SET `QuestCompletionLog` = 'Meet Magister Umbric in Duskglow Gloriette in Silvermoon City.', `RewardNextQuest` = 0 WHERE `ID` = 86543;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 235787 AND `source_type` = 0 AND `id` IN (0, 1, 2) AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (239944, 235395) AND `source_type` = 0 AND `id` = 0 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`creature_text` WHERE `CreatureID` = 235787 AND `GroupID` IN (0, 1, 2) AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`creature_text` WHERE `CreatureID` IN (239944, 235395) AND `GroupID` = 0 AND `comment` LIKE '%(wiki)';
