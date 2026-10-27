DELETE FROM quest_objectives WHERE QuestID=92136;
INSERT INTO quest_objectives (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(464269,92136,0,0,0,237602,1,0,0,0,0.0,0,1,'Tell Alonsus you''re ready to depart',66384),
(464270,92136,0,1,4,246427,1,0,28,0,0.0,0,1,'Portal Created',69497),
(464271,92136,0,2,5,250066,1,0,2,0,0.0,0,1,'Take the portal to Silvermoon',69497),
(92136000,92136,0,1,1,250066,1,0,6,0,0.0,0,1,'Take the portal to Silvermoon',0);
