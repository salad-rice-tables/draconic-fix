-- Undo 20261016_abyss86536.sql.
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86536;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38393 AND `GossipOptionID`=383930;
DELETE FROM `gossip_menu` WHERE `MenuID`=38393;
UPDATE `npc_text` SET `BroadcastTextID0`=177977 WHERE `ID`=38393;
UPDATE `gossip_menu` SET `TextID`=235393 WHERE `MenuID`=912046909;
DELETE FROM `npc_text` WHERE `ID` IN (40322,912046909);
DELETE FROM `gossip_menu` WHERE `MenuID`=40322;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38620 AND `GossipOptionID` IN (386201,386202);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235606,999999999,47936),(235389,912046911,47936);
UPDATE `conditions` SET `ConditionValue2`=2 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45760 AND `ConditionValue1`=86565 AND `ConditionValue2`=66 AND `NegativeCondition`=0;
