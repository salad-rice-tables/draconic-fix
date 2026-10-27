-- Undo 20261016_abyss86565.sql.
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86565%';
UPDATE `gossip_menu_option` SET `GossipOptionID`=0 WHERE `MenuID`=912046906 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `GossipOptionID`=1 WHERE `MenuID`=912046906 AND `OptionID`=1;
UPDATE `gossip_menu` SET `TextID`=235609 WHERE `MenuID`=912046906;
DELETE FROM `npc_text` WHERE `ID`=912046906;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38620 AND `GossipOptionID`=386200;
UPDATE `npc_text` SET `BroadcastTextID0`=39120 WHERE `ID`=38620;
DELETE FROM `gameobject` WHERE `guid`=990000000101201018;
