-- 3s pause after every spoken line; real audio durations for Arator/Lor'themar lines
DELETE FROM broadcast_text_duration WHERE BroadcastTextID IN (290511,285929,285071,285072,285073,290102,298404);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108740,290511,0,2803,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108741,285929,0,5610,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108742,285071,0,4353,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108743,285072,0,5336,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108744,285073,0,5414,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108745,290102,0,7964,70391);
INSERT INTO broadcast_text_duration (ID,BroadcastTextID,Locale,Duration,VerifiedBuild) VALUES (9108746,298404,0,4830,70391);
UPDATE conversation_line SET AdditionalDuration=3000 WHERE ID IN (82094,82371) OR ID BETWEEN 87529 AND 87533 OR ID BETWEEN 89276 AND 89290;
UPDATE conversation_line SET AdditionalDuration=0 WHERE ID IN (87534,89291);
