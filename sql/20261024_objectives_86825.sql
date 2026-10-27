-- quest 86825 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=86825;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(462579,86825,0,0,3,245718,1,0,1,0,0.0,0,1,'',69497),
(462902,86825,1,1,0,246704,1,0,0,1,0.0,0,1,'Relic Fragment recovered',69497);
