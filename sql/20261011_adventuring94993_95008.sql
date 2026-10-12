-- 95008 Adventuring in Midnight: missing quest_offer_reward.RewardText.
-- 94993 Adventuring in Midnight: missing starter, ender only unspawned Umbric 235386.
-- Sources:
--   Wiki Adventuring_in_Midnight (quest=95008): Start/End Soridormi, Completion
--   "<Your decision has been made. You can return to the scouting map at any
--   time to choose another location.>", rewards 3g41s.
--   Forums (Midnight alt skip thread): Soridormi offers "Adventuring in Midnight".
--   Wiki Notes: map interaction unlocks Arator / Gates of Zul'Aman / Harandar
--   (= the no-starter Scouting-Map pattern, no classic starter links in TDB either).
-- Cross-check: Soridormi 259153 spawned Silvermoon (guid 3001001100, map 0,
-- 8452,-4612, next to Lor'themar); already starter/ender of 95008 family.
-- 94993 keeps existing Umbric ender (harmless alternative). Additive only.
INSERT IGNORE INTO `world`.`quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`, `VerifiedBuild`) VALUES (95008, 0, 0, 0, 0, 0, 0, 0, 0, '<Your decision has been made. You can return to the scouting map at any time to choose another location.>', 0);
INSERT IGNORE INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES (259153, 94993, 0);
INSERT IGNORE INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES (259153, 94993, 0);
