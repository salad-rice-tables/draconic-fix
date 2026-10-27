-- 86536 Reliable Enemies v1 (Wiki Reliable_Enemies + retail broadcast).
-- 45760 camp: 86565/2 -> 86565/66 (tabor inak zmizne hned po turn-ine 86565 a 86536
-- by nemala startera!). 235606 starter + 235389 ender unlink (default quest UI).
-- Decimus 235607 (menu 38620): +2 interrogation buttony (Wiki) -> Eluna simulacia
-- (Decimus faction 35 = neutocte, damage mechanika bez sniffu nespravime) + kredit 242210.
-- Overlook: Lothraxion menu 40322 (telo 912047086), Arator 912046909 (telo 912047087),
-- Decimus 235392 telo 912047088 (npc 38393) + movie button (video follow-up).
-- Talk kredit native (SAI 235392->260236). Meet 9100609 proximity (Eluna).
-- Progress text (TDB ''). Undo: 20261016_abyss86536_undo.sql. Restart + .reload eluna.
UPDATE `conditions` SET `ConditionValue2`=66 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45760 AND `ConditionValue1`=86565 AND `ConditionValue2`=2 AND `NegativeCondition`=0;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235606 AND `MenuID`=999999999;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235389 AND `MenuID`=912046911;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38620,386201,1,0,'(Quest) <Apply force.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38620,386202,2,0,'(Quest) I don''t have time for this. Tell us what you know.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (40322,1,0,0,0,0,0,0,0,912047086,0,0,0,0,0,0,0,0),
 (912046909,1,0,0,0,0,0,0,0,912047087,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40322,40322,0);
UPDATE `gossip_menu` SET `TextID`=912046909 WHERE `MenuID`=912046909;
UPDATE `npc_text` SET `BroadcastTextID0`=912047088 WHERE `ID`=38393;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38393,38393,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (38393,383930,0,0,'(Play Movie) How did Xal''atath take control of the ethereals?',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
UPDATE `quest_template` SET `AreaDescription`='Lothraxion has a plan. I trust him.' WHERE `ID`=86536;
