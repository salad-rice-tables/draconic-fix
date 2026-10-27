-- Undo 20261016_abyss6511.sql.
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86511;
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86511%';
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (238296,912046929,47936);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235633 AND `MenuID`=38440;
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (38390,38440);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38390,38440,38442);
DELETE FROM `npc_text` WHERE `ID` IN (38440,38442);
UPDATE `npc_text` SET `BroadcastTextID0`=177962 WHERE `ID`=38390;
UPDATE `gossip_menu` SET `TextID`=999999999 WHERE `MenuID`=38441;
DELETE FROM `npc_text` WHERE `ID`=38441;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (38441,0,0,0,'Pumped up!',10001387,0,1,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
