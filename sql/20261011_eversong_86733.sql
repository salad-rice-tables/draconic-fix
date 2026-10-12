-- 86733 Silvermoon Negotiations (Wiki: Eversong_Woods_storyline).
-- Template: RewardBonusMoney 31900->23400 (2g34s), RewardNextQuest ->86734 Diplomacy,
-- Completion (Wiki). Choice gear (11x Golden City) NOT SET (IDs unverified).
-- Accept scena (Wiki Notes): Turalyon + Lorthemar say (Eluna, sekvencne; VO 290883/290413 existuje,
-- ale Eluna nema sound parameter - follow-up C++ patch). Mount-up + Rommath/Umbric/Halduron Sanctum scena
-- a Orweyna gossip: retail spawny pre 45583 chybaju, follow-up (nevymyslat pozicie).
-- Liadrin 241068: mrtvy link 912046808 -> nove menu s Wiki textom (bez buttonov).
-- Arator 236734: link 999999999 mrtvy, ale ziadny gossip text pre neho vo Wiki nie je -> nemenene.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 23400, `RewardNextQuest` = 86734, `QuestCompletionLog` = 'I''m glad you''ve arrived. Let''s begin.' WHERE `ID` = 86733;
INSERT IGNORE INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES ('My duty is to protect the whole of Eversong.', '', 9900134, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES (9500134, 1, 0, 0, 0, 0, 0, 0, 0, 9900134, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (40416, 9500134, 0);
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40416 WHERE `CreatureID` = 241068 AND `MenuID` = 912046808;
