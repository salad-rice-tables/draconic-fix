-- Undo 20261016_abyss3837.sql.
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38396 AND `GossipOptionID`=383961;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38434 AND `GossipOptionID` IN (384340,384341,384342);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38435,38436,38437);
DELETE FROM `npc_text` WHERE `ID`=38435;
UPDATE `npc_text` SET `BroadcastTextID0`=178192 WHERE `ID`=38436;
UPDATE `npc_text` SET `BroadcastTextID0`=178174 WHERE `ID`=38437;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID` IN (86538,86537);
