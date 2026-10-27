-- Undo 20261016_abyss4455.sql.
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86545%';
DELETE FROM `gossip_menu_option` WHERE `MenuID`=39077 AND `GossipOptionID`=390770;
DELETE FROM `gossip_menu` WHERE `MenuID`=39077;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86545;
UPDATE `quest_objectives` SET `StorageIndex`=0 WHERE `ID`=459567;
UPDATE `quest_objectives` SET `StorageIndex`=1, `Amount`=1 WHERE `ID`=459541;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
 (459568,86545,0,4,2,240626,1,0,28,0,0.0,0,1,'',69497),
 (459569,86545,0,6,3,240626,11,0,28,0,0.0,0,1,'',69497),
 (459571,86545,0,5,4,240626,6,0,28,0,0.0,0,1,'',69497),
 (461345,86545,0,0,6,239571,1,0,28,0,0.0,0,1,'',69497);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (240546,999999999,47936);
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86544%';
UPDATE `gossip_menu_option` SET `OptionText`='Watch the movie!', `OptionBroadcastTextID`=912047106, `GossipOptionID`=0 WHERE `MenuID`=912046918 AND `OptionID`=0;
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (38545,38544,38552,38551);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38545,38544,38552,38551);
DELETE FROM `npc_text` WHERE `ID` IN (38545,38544,38552,38551);
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86544;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (459677,86544,0,0,4,240881,1,0,4,0,0.0,0,1,'Stay awhile and listen to Alleria',69497);
