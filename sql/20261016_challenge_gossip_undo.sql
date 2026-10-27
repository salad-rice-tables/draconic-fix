-- UNDO challenge gossip trigger
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=9900133 AND `MenuID`=9900133;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=9900133;
DELETE FROM `gossip_menu` WHERE `MenuID`=9900133;
