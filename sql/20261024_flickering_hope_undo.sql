DELETE FROM quest_objectives WHERE QuestID=86840;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(459421,86840,15,0,-1,0,1,0,0,0,0.0,0,1,'Light''s Hope defended',69497),
(459422,86840,15,1,0,0,1,0,0,0,0.0,0,1,'Light''s Hope defended',66384),
(459423,86840,0,2,1,237731,12,0,92,0,9.0,0,1,NULL,66384),
(462370,86840,21,3,2,5210,5,0,24,0,0.0,0,1,'Arator Comment 1',69497),
(462371,86840,21,4,4,5210,12,0,24,0,0.0,0,1,'Arator Comment 2',69497),
(462372,86840,21,5,5,5210,23,0,24,0,0.0,0,1,'Arator Comment 3',69497);
