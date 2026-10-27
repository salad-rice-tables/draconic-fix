-- Gossip window headers (retail texts from the user's video notes): custom broadcast_text rows in hotfixes + npc_text in world.
-- Needs a worldserver restart to be read (hotfix DB is loaded at startup); until then the header stays empty.
DELETE FROM hotfixes.broadcast_text WHERE ID IN (1000000012, 1000000013, 1000000014, 1000000015);
INSERT INTO hotfixes.broadcast_text (Text, Text1, ID, LanguageID, ConditionID, EmotesID, Flags, ChatBubbleDurationMs, VoiceOverPriorityID, SoundKitID1, SoundKitID2, EmoteID1, EmoteID2, EmoteID3, EmoteDelay1, EmoteDelay2, EmoteDelay3, VerifiedBuild) VALUES
('It is almost the end of your ceremony, $n. What have you seen? What did the legacy stones show you?', NULL, 1000000012, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('I was on routine patrol in Elwynn Forest near a large tree. There was a flash of green light, and then I was here. The nature in this place is brutal and unforgiving.', NULL, 1000000013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('You have been marked by the goddess $n. It is time for you to embark on a journey.', NULL, 1000000014, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
('Are you taking part in the ceremony? How wonderful...', NULL, 1000000015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
DELETE FROM world.npc_text WHERE ID IN (1000000012, 1000000013, 1000000014, 1000000015);
INSERT INTO world.npc_text (ID, Probability0, Probability1, Probability2, Probability3, Probability4, Probability5, Probability6, Probability7, BroadcastTextId0, BroadcastTextId1, BroadcastTextId2, BroadcastTextId3, BroadcastTextId4, BroadcastTextId5, BroadcastTextId6, BroadcastTextId7, VerifiedBuild) VALUES
(1000000012, 1, 0, 0, 0, 0, 0, 0, 0, 1000000012, 0, 0, 0, 0, 0, 0, 0, 0),
(1000000013, 1, 0, 0, 0, 0, 0, 0, 0, 1000000013, 0, 0, 0, 0, 0, 0, 0, 0),
(1000000014, 1, 0, 0, 0, 0, 0, 0, 0, 1000000014, 0, 0, 0, 0, 0, 0, 0, 0),
(1000000015, 1, 0, 0, 0, 0, 0, 0, 0, 1000000015, 0, 0, 0, 0, 0, 0, 0, 0);
-- the third stone's hidden objective ("Vision of The Goddess Guidance concluded") must be visible: Flags 24 (hidden) -> 2 (sequenced)
UPDATE world.quest_objectives SET Flags = 2 WHERE ID = 462477 AND QuestID = 90960;
