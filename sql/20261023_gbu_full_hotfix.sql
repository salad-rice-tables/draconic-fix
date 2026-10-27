DELETE FROM phase WHERE ID IN (9108901,9108902);
INSERT INTO phase (ID,Flags,VerifiedBuild) VALUES (9108901,40,70391),(9108902,40,70391);
DELETE FROM broadcast_text WHERE ID=9108800;
INSERT INTO broadcast_text (Text,Text1,ID,LanguageID,ConditionID,EmotesID,Flags,ChatBubbleDurationMs,VoiceOverPriorityID,SoundKitID1,SoundKitID2,EmoteID1,EmoteID2,EmoteID3,EmoteDelay1,EmoteDelay2,EmoteDelay3,VerifiedBuild) VALUES ('Cursed Gurubashi bind us|nFang of Shadra pry the bars|nBlood of Hir''eek mark the way|nBy their corpses we be freed',NULL,9108800,0,0,0,0,0,0,0,0,0,0,0,0,0,0,70391);
