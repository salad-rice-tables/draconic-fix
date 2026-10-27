-- Undo 20261016_abyss655758.sql.
UPDATE `creature_template_gossip` SET `MenuID`=912046900 WHERE `CreatureID`=235523 AND `MenuID`=40204;
UPDATE `creature_template_gossip` SET `MenuID`=912046898 WHERE `CreatureID`=235608 AND `MenuID`=40204;
DELETE FROM `gossip_menu` WHERE `MenuID`=40204;
DELETE FROM `npc_text` WHERE `ID`=40204;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID`=9900152;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86557;
