-- 86769 Last Bastion escort pilot: Liadrin 236693 A(11127,-4477) -> B Parhelion Plaza(11014,-4409).
-- Gossip link 912046715 mrtvy -> nove menu s Wiki textom (bez buttonov).
-- Chodenie: Eluna accept-handler (MoveToSafe navmesh, fallback MoveTo) + accept-say. Turn-in u B spawnu ostava.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
INSERT IGNORE INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES ('We prayed for aid and the Sunwell responded. Now we must prove we are worthy of it.', '', 9900135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES (9500135, 1, 0, 0, 0, 0, 0, 0, 0, 9900135, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (40418, 9500135, 0);
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40418 WHERE `CreatureID` = 236693 AND `MenuID` = 912046715;
