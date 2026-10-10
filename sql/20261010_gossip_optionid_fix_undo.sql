-- UNDO: 20261010_gossip_optionid_fix.sql.
UPDATE `world`.`gossip_menu_option` SET `GossipOptionID` = 0 WHERE `MenuID` IN (40410, 40411);
