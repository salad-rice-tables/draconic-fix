-- 92061: talking civilians per Wiki (texts without buttons, model: retail menu 38452).
-- Citizens (252569, 252844) -> evacuation text; Residents (250980) -> children/portals text (split by Wiki blocks).
-- Template npcflag 0->1 (window would not open otherwise); template links (apply to all spawns of the entry).
-- Yells handled by lua/rising_storm_chatter.lua (ambient, only during 92061).
-- Do NOT apply while players are testing; deploy before restart.
INSERT IGNORE INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES ('I heard the Amani and cultists are coming from the south. Is it too late for us to evacuate?\n\nWhere would we run to?', '', 9900130, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES ('We... we should at least get the children out.\n\nMaybe use portals?\n\nSuramar owes our people something.', '', 9900131, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES (9500130, 1, 0, 0, 0, 0, 0, 0, 0, 9900130, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES (9500131, 1, 0, 0, 0, 0, 0, 0, 0, 9900131, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (40414, 9500130, 0);
INSERT IGNORE INTO `world`.`gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (40415, 9500131, 0);
UPDATE `world`.`creature_template` SET `npcflag` = 1 WHERE `entry` IN (250980, 252569, 252844) AND `npcflag` = 0;
INSERT IGNORE INTO `world`.`creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES (252569, 40414, 0);
INSERT IGNORE INTO `world`.`creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES (252844, 40414, 0);
INSERT IGNORE INTO `world`.`creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES (250980, 40415, 0);
