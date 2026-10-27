-- UNDO altar gossip
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=9900130 AND `MenuID`=9900130;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=9900130;
DELETE FROM `gossip_menu` WHERE `MenuID`=9900130;
