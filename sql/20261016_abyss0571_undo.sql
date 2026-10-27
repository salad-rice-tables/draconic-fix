-- Undo 20261016_abyss0571.sql.
UPDATE `quest_template` SET `RewardItem1`=260858, `RewardChoiceItemID1`=0, `RewardChoiceItemID2`=0 WHERE `ID`=90571;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=90571;
DELETE FROM `smart_scripts` WHERE `comment` LIKE '90571%';
DELETE FROM `gossip_menu_option` WHERE `MenuID`=912046930 AND `GossipOptionID`=905711;
UPDATE `gossip_menu` SET `TextID`=235469 WHERE `MenuID`=912046930;
DELETE FROM `npc_text` WHERE `ID`=912046930;
UPDATE `quest_objectives` SET `Type`=0, `StorageIndex`=0, `ObjectID`=0, `Amount`=0, `Description`='' WHERE `ID`=461130;
UPDATE `quest_objectives` SET `StorageIndex`=1 WHERE `ID`=461131;
UPDATE `quest_objectives` SET `StorageIndex`=2 WHERE `ID`=461132;
UPDATE `quest_objectives` SET `StorageIndex`=3 WHERE `ID`=461133;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (461134,90571,0,4,4,240725,1,0,6,0,0.0,0,1,NULL,66384);
