-- quest 91000 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=91000;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(461996,91000,15,0,-1,0,1,0,0,0,0.0,0,1,'Aid Hammerfall',69497),
(461997,91000,2,1,9,525458,25,0,92,0,4.0,0,1,'Trash Cleaned Up',69497),
(461998,91000,2,2,10,525459,17,0,92,0,6.0,0,1,'Rubble Eliminated',69497),
(461999,91000,0,3,11,240579,25,0,92,0,4.0,0,1,'',69497),
(462000,91000,0,4,12,240581,34,0,92,0,3.0,0,1,'',69497),
(462452,91000,0,5,0,245257,5,0,92,0,20.0,0,1,'Peon Healed',69497),
(464204,91000,3,6,1,238101,1,0,4,0,0.0,0,1,'Speak with Sunwalker Malu',69497),
(464205,91000,3,7,2,238081,1,0,4,0,0.0,0,1,'Speak with Sunwalker Nadura',69497);
