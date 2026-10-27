-- hotfixes: accept-quest conversation Arator(82094) -> Lor'themar(82371) -> Halduron(87529..) in one chain with 2.5s pauses
DELETE FROM conversation_line WHERE ID IN (82094,82371);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (82094,290511,0,0,2500,16835,0,0,60,60,70391);
INSERT INTO conversation_line (ID,BroadcastTextID,Unused1020,SpellVisualKitID,AdditionalDuration,NextConversationLineID,AnimKitID,SpeechType,StartAnimation,EndAnimation,VerifiedBuild) VALUES (82371,285929,0,0,2500,21993,0,0,60,60,70391);
