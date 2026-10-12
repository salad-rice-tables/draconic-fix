-- UNDO: 20261011_eversong_b1texts.sql (predosle hodnoty z DB 2026-10-10).
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 31900, `RewardNextQuest` = 0, `QuestCompletionLog` = 'Meet Lor''themar in the Sanctum of Light in Silvermoon City.' WHERE `ID` = 86733;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `QuestCompletionLog` = '' WHERE `ID` = 86735;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `QuestCompletionLog` = '' WHERE `ID` = 86736;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 30900, `QuestCompletionLog` = '' WHERE `ID` = 86737;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 315900, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86738;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86739;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86740;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `QuestCompletionLog` = '' WHERE `ID` = 86741;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86742;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 309800, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86743;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 631800, `RewardNextQuest` = 0, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86744;
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 312800, `AreaDescription` = '', `QuestCompletionLog` = '' WHERE `ID` = 86745;
INSERT IGNORE INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (461480, 86738, 0, 2, 2, 0, 1, 0, 6, 0, 0.0, 0, 1, NULL, 0);
