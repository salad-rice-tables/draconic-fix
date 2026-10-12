-- UNDO: 20261011_escort86769.sql.
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 912046715 WHERE `CreatureID` = 236693 AND `MenuID` = 40418;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` = 40418;
DELETE FROM `world`.`npc_text` WHERE `ID` = 9500135;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900135;
