-- 94871 Eversong + 89388 Voidstorm: missing quest_offer_reward.RewardText.
-- Sources: Wowhead quest pages, Completion field (page data, same class as
-- Start/End which the research skill allows from Wowhead pages):
--   94871: "The wildlife is going out of control!"
--   89388: "I hope you are ready for a challenge. This will not be easy."
-- Mapping Completion -> RewardText confirmed 4x against TDB staging
-- (86708, 89402, 89193, 86874: TDB RewardText == Completion verbatim).
-- Cross-check: tooltip names match DB LogTitles; 94871 ender 236739
-- (Magistrix Landra, spawned 1x), 89388 ender 235411 (Umbric, spawned).
-- Additive (INSERT IGNORE), no deletes.
INSERT IGNORE INTO `world`.`quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`, `VerifiedBuild`) VALUES
(94871, 0, 0, 0, 0, 0, 0, 0, 0, 'The wildlife is going out of control!', 0),
(89388, 0, 0, 0, 0, 0, 0, 0, 0, 'I hope you are ready for a challenge. This will not be easy.', 0);
