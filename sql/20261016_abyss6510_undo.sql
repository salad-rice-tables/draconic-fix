-- Undo 20261016_abyss6510.sql.
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86510;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=42172 AND `GossipOptionID`=421720;
DELETE FROM `gossip_menu` WHERE `MenuID`=42172;
DELETE FROM `npc_text` WHERE `ID`=42172;
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86510%';
UPDATE `quest_objectives` SET `StorageIndex`=3, `ObjectID`=235703 WHERE `ID`=457838;
UPDATE `quest_objectives` SET `ObjectID`=235703 WHERE `ID`=457839;
