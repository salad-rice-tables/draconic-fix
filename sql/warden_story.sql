-- =====================================================================
-- Warden Velarys story gossip (Dolanaar): why Wardens, what threatens
-- the woods, why demon hunters, what the path is.
-- Broadcasts 9900001-9900005 + npc_texts 95001-95005.
-- Idempotent (DELETE + INSERT). Hotfix text needs restart/relog.
-- =====================================================================

DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` IN (9900001, 9900002, 9900003, 9900004, 9900005);
INSERT INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES
('You have come to Dolanaar, hunter. I am Velarys, Warden of this watch. Our order is broken, the woods are sick, and my mistress hunts shadows far from here. Ask, and I will tell you why the Wardens now knock on demon hunters\' doors.', '', 9900001, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('We are the Watchers. Since the War of the Ancients we have been the jailers of demons and of all that festers in the dark. Our sisterhood bled dry in the Vault of the Wardens and in the wars since. Maiev Shadowsong herself leads what remains, hunting a prey she will not name. I hold Dolanaar with six blades and a prayer.', '', 9900002, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('The Legion is broken, but its leavings fester. Fel shards fallen from the sky quicken the beasts - grellkin grow bold, timberlings walk with green fire in their bark, and the strigids carry word of darker wings. Satyrs whisper in the deep thickets, and deserters of every banner prey on the weak. The wards fail. The forest bleeds. That is our chaos, hunter.', '', 9900003, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('Because Maiev freed your kind in the Vault when the demons came, and you bled beside us. Jailers are no longer enough - these woods need killers who know demons from the inside. But freedom is not trust. The trials will carve the answer out of you, or bury you. That is why you are here.', '', 9900004, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('Three trials under these boughs: cull the bold, learn the shadow, dance the talon. After that, greater hunts - and if you endure them all, Maiev herself will come to see what her mercy has wrought. Stand ready, and you will kneel a hunter and rise a Warden.', '', 9900005, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`npc_text` WHERE `ID` IN (95001, 95002, 95003, 95004, 95005);
INSERT INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES
(95001, 1, 0, 0, 0, 0, 0, 0, 0, 9900001, 0, 0, 0, 0, 0, 0, 0, 0),
(95002, 1, 0, 0, 0, 0, 0, 0, 0, 9900002, 0, 0, 0, 0, 0, 0, 0, 0),
(95003, 1, 0, 0, 0, 0, 0, 0, 0, 9900003, 0, 0, 0, 0, 0, 0, 0, 0),
(95004, 1, 0, 0, 0, 0, 0, 0, 0, 9900004, 0, 0, 0, 0, 0, 0, 0, 0),
(95005, 1, 0, 0, 0, 0, 0, 0, 0, 9900005, 0, 0, 0, 0, 0, 0, 0, 0);
