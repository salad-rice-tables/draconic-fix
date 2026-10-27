-- hotfixes: Gods Before Us accept conversation (custom ConversationLine ids 64890-64895, 3s pauses), real audio durations
DELETE FROM conversation_line WHERE ID BETWEEN 64890 AND 64895;
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64890,287411,0,0,3000,64891,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64891,298405,0,0,3000,64892,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64892,298406,0,0,3000,64893,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64893,298407,0,0,3000,64894,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64894,298408,0,0,3000,64895,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (64895,298409,0,0,0,0,0,0,60,60,70391);
DELETE FROM broadcast_text_duration WHERE BroadcastTextID IN (287411,298405,298406,298407,298408,298409,290440,285079,285080);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108760,287411,0,2714,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108761,298405,0,6819,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108762,298406,0,8381,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108763,298407,0,6075,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108764,298408,0,9015,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108765,298409,0,1278,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108766,290440,0,2651,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108767,285079,0,4311,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108768,285080,0,1477,70391);
