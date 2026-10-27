-- 86840 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=86840;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(459421,86840,15,0,-1,0,1,0,0,0,0.0,0,1,'Light''s Hope defended',69497),
(459422,86840,0,1,0,237731,20,0,92,0,5.0,0,1,'',69497),
(459423,86840,0,2,1,237739,34,0,92,0,3.0,0,1,'',69497),
(462370,86840,21,3,2,5210,5,0,24,0,0.0,0,1,'Arator Comment 1',69497),
(462371,86840,21,4,4,5210,12,0,24,0,0.0,0,1,'Arator Comment 2',69497),
(462372,86840,21,5,5,5210,23,0,24,0,0.0,0,1,'Arator Comment 3',69497);
