-- =====================================================================
-- FIX retail kolizie: custom questy 95008/95009 prepisovali retail Midnight
--   95008 retail = "Adventuring in Midnight" (wowhead 200)
--   95009 retail = "Doing the Dash" (wowhead 200)
-- Presun: custom 95008 -> 95018 (Debts of Shadow), 95009 -> 95019
--   (Whispers of the Dreadlord). 95018/95019/95020 overene FREE (wowhead 404).
-- Objektivy: 955008 -> 955018, 955009 -> 955019.
-- Retaz: 95007 -> 95018 -> 95019 -> 95010 (predtym 95007->95008->95009->95010).
-- Idempotentne (WHERE guardy). Po aplikacii upravit aj warden_ch3.sql/ch4.sql.
-- Retail 95008/95009 sa TOUTO migraciou NEOBNOVI (boli prepisane) - treba
-- re-import z TDB 22111 full world dumpu, pozri 20261008_retail_95008_95009_TODO.sql
-- =====================================================================

-- --- custom 95008 -> 95018 ---
UPDATE `world`.`quest_template` SET `ID` = 95018 WHERE `ID` = 95008;
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95018 WHERE `RewardNextQuest` = 95008;
UPDATE `world`.`quest_template_addon` SET `ID` = 95018 WHERE `ID` = 95008;
UPDATE `world`.`quest_template_addon` SET `PrevQuestID` = 95018 WHERE `PrevQuestID` = 95008;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95018 WHERE `NextQuestID` = 95008;
UPDATE `world`.`quest_objectives` SET `ID` = 955018, `QuestID` = 95018 WHERE `QuestID` = 95008;
UPDATE `world`.`creature_queststarter` SET `quest` = 95018 WHERE `quest` = 95008;
UPDATE `world`.`creature_questender` SET `quest` = 95018 WHERE `quest` = 95008;
UPDATE `world`.`quest_poi` SET `QuestID` = 95018 WHERE `QuestID` = 95008;
UPDATE `world`.`quest_poi` SET `QuestObjectiveID` = 955018 WHERE `QuestObjectiveID` = 955008;
UPDATE `world`.`quest_poi_points` SET `QuestID` = 95018 WHERE `QuestID` = 95008;

-- --- custom 95009 -> 95019 ---
UPDATE `world`.`quest_template` SET `ID` = 95019 WHERE `ID` = 95009;
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95019 WHERE `RewardNextQuest` = 95009;
UPDATE `world`.`quest_template_addon` SET `ID` = 95019 WHERE `ID` = 95009;
UPDATE `world`.`quest_template_addon` SET `PrevQuestID` = 95019 WHERE `PrevQuestID` = 95009;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95019 WHERE `NextQuestID` = 95009;
UPDATE `world`.`quest_objectives` SET `ID` = 955019, `QuestID` = 95019 WHERE `QuestID` = 95009;
UPDATE `world`.`creature_queststarter` SET `quest` = 95019 WHERE `quest` = 95009;
UPDATE `world`.`creature_questender` SET `quest` = 95019 WHERE `quest` = 95009;
UPDATE `world`.`quest_poi` SET `QuestID` = 95019 WHERE `QuestID` = 95009;
UPDATE `world`.`quest_poi` SET `QuestObjectiveID` = 955019 WHERE `QuestObjectiveID` = 955009;
UPDATE `world`.`quest_poi_points` SET `QuestID` = 95019 WHERE `QuestID` = 95009;

-- --- retaz po presune: 95007 -> 95018 -> 95019 -> 95010 ---
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95018 WHERE `ID` = 95007 AND `RewardNextQuest` = 95008;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95018 WHERE `ID` = 95007 AND `NextQuestID` = 95008;
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95019 WHERE `ID` = 95018 AND `RewardNextQuest` = 95009;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95019 WHERE `ID` = 95018 AND `NextQuestID` = 95009;
UPDATE `world`.`quest_template_addon` SET `PrevQuestID` = 95018 WHERE `ID` = 95019 AND `PrevQuestID` = 95008;
UPDATE `world`.`quest_template_addon` SET `PrevQuestID` = 95019 WHERE `ID` = 95010 AND `PrevQuestID` = 95009;
