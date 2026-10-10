-- UNDO: 20261011_evil91967_warlock.sql.
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 40158 AND `SourceEntry` = 2;
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` = 40158 AND `OptionID` = 2;
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` = 40159;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` = 40159;
DELETE FROM `world`.`npc_text` WHERE `ID` = 9500129;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900129;
