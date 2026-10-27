-- quest 42227 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=42227;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(284431,42227,0,0,0,107126,1,0,0,0,0.0,0,1,'Follow Valewalker Farodin',69497),
(284432,42227,0,1,1,107918,1,0,2,0,0.0,0,1,'Enter Falanaar Tunnels',69497);
