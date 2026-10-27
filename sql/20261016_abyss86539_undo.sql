-- Undo 20261016_abyss86539.sql.
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235721 AND `MenuID`=38438;
DELETE FROM `gossip_menu` WHERE `MenuID`=38438;
DELETE FROM `npc_text` WHERE `ID`=38438;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235650,999999999,47936);
