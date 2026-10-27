-- Undo 20261016_abyss312849.sql.
DELETE FROM `gossip_menu` WHERE `MenuID`=38434;
DELETE FROM `npc_text` WHERE `ID`=38434;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86531;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38642 AND `GossipOptionID` IN (386420,386421);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38642,38643);
DELETE FROM `npc_text` WHERE `ID` IN (38642,38643);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (38643,0,0,21,'Free the prisoners!',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (241109,999999999,47936);
