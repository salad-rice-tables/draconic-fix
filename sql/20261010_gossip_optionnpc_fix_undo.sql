-- UNDO: 20261010_gossip_optionnpc_fix.sql.
UPDATE `world`.`gossip_menu_option` SET `OptionNpc` = 3 WHERE `MenuID` IN (40410, 40411) AND `OptionID` = 0;
