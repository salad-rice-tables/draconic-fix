-- Undo 20261016_abyss6509.sql.
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86509%';
DELETE FROM `gossip_menu_option` WHERE `MenuID`=40206 AND `GossipOptionID`=402060;
UPDATE `creature_template_gossip` SET `MenuID`=912046927 WHERE `CreatureID`=235473 AND `MenuID`=40206;
DELETE FROM `gossip_menu` WHERE `MenuID`=40206;
DELETE FROM `npc_text` WHERE `ID`=40206;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235697,39120,66527);
