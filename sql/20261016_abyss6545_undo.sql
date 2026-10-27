-- Undo 20261016_abyss6545.sql.
UPDATE `creature_template_gossip` SET `MenuID`=999999999 WHERE `CreatureID`=235726 AND `MenuID`=38439;
DELETE FROM `gossip_menu` WHERE `MenuID`=38439;
DELETE FROM `npc_text` WHERE `ID`=38439;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID`=9900153;
