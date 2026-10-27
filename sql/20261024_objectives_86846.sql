-- quest 86846 objectives restored to retail (TDB)
DELETE FROM quest_objectives WHERE QuestID=86846;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(461976,86846,0,1,3,245254,1,0,28,0,0.0,0,1,'Arator and Dezco Food Trigger',69497),
(461977,86846,0,2,6,232031,1,0,0,0,0.0,0,1,'Butcher supplies for Slagg',69497),
(461978,86846,0,0,7,232033,1,0,0,0,0.0,0,1,'Tailoring supplies for Jun''ha',69497),
(461979,86846,0,3,8,232036,1,0,0,0,0.0,0,1,'Leatherworking supplies for Tunkk',69497),
(462008,86846,0,6,0,232037,1,0,0,0,0.0,0,1,'Bowyer supplies for Mu''uta',69497),
(462009,86846,0,4,1,245305,1,0,28,0,0.0,0,1,'Dezco Arator Supplies Trigger',69497),
(464898,86846,0,8,4,251859,1,0,28,0,0.0,0,1,'Eitrigg Departs',69497),
(470214,86846,0,7,2,232035,1,0,0,0,0.0,0,1,'Trade goods for Keena',69497),
(470329,86846,0,5,5,240747,1,0,28,0,0.0,0,1,'Faol Walks Off',69497);
