-- 86735 Paved in Ash (Alliance): missing quest_offer_reward.RewardText.
-- Source: Warcraft Wiki Paved_in_Ash (Alliance block, Completion):
--   "Remember, you are a guest here. Your aid is appreciated, but our rules
--    must be followed while you are within these walls."
-- Cross-check: tooltip name 'Paved in Ash' == DB LogTitle; Wiki Start/End
-- Lor'themar Theron == DB creature_queststarter/ender id 235787.
-- Sibling Horde quest 86736 already has its own RewardText in DB; this adds
-- only the missing Alliance row. Additive (INSERT IGNORE), no deletes.
INSERT IGNORE INTO `world`.`quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`, `VerifiedBuild`) VALUES (86735, 1, 0, 0, 0, 0, 0, 0, 0, 'Remember, you are a guest here. Your aid is appreciated, but our rules must be followed while you are within these walls.', 0);
