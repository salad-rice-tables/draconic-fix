-- Undo for 20261019_harandar_achievement_rewards.sql
DELETE FROM `char_titles` WHERE `ID` = 1049 AND `VerifiedBuild` = 70391;
DELETE FROM `achievement_reward` WHERE `ID` = 61344 AND `TitleA` = 1049 AND `TitleH` = 1049 AND `ItemID` = 0;
