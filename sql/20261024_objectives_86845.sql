-- quest 86845 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=86845;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(459602,86845,0,4,0,238072,1,0,28,0,0.0,0,1,'Show Trash in Hammerfall',69497),
(459783,86845,0,0,1,237511,1,0,0,0,0.0,0,1,'Tell Alonsus you''re ready to depart',69497),
(461949,86845,0,3,3,245207,1,0,28,0,0.0,0,1,'Leave Area Trigger',69497),
(462444,86845,0,1,4,264111,1,0,28,0,0.0,0,1,'Portal Created',69497),
(463201,86845,0,2,5,248052,1,0,2,0,0.0,0,1,'Take the portal to Hammerfall',69497);
