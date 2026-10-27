-- Undo 20261016_abyss3038.sql.
INSERT INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (235717,86528,150895);
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (86528000,86528,1,0,0,241000,1,0,0,1,0.0,0,1,NULL,0);
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86530;
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86530%';
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38396 AND `GossipOptionID`=383960;
DELETE FROM `gossip_menu` WHERE `MenuID`=38396;
DELETE FROM `npc_text` WHERE `ID`=38396;
