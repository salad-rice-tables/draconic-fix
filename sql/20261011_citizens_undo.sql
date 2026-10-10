-- UNDO: 20261011_citizens.sql.
DELETE FROM `world`.`creature_template_gossip` WHERE `CreatureID` IN (252569, 252844) AND `MenuID` = 40414;
DELETE FROM `world`.`creature_template_gossip` WHERE `CreatureID` = 250980 AND `MenuID` = 40415;
UPDATE `world`.`creature_template` SET `npcflag` = 0 WHERE `entry` IN (250980, 252569, 252844) AND `npcflag` = 1;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` IN (40414, 40415);
DELETE FROM `world`.`npc_text` WHERE `ID` IN (9500130, 9500131);
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` IN (9900130, 9900131);
