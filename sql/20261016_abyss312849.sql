-- 89249 Overwhelmed + 86531 Work Disruption v1 (Wiki verbatim).
-- 89249: starter unlink; Arator menu 38642 (telo 912047104 + 2 buttony + submenu 38643);
-- accept scena (Decimus + Lothraxion, speakri v 45770 pri starterovi); turn-in nativny.
-- 86531: Progress text (TDB ''); accept scena (Alleria + Arator, overlook 45762);
-- Alleria ender menu 38434 (telo 912047090). OBJEKTIVY 86531 SAHNUTE: 13 rucnych riadkov
-- (build 0) vs TDB bar - neviem rozhodnut bez herneho testu (hypotezy vo Fixes).
-- Follow-up: captive rescue dialog, Siphoner says, pipe/GO bar-overenie v hre.
-- Undo: 20261016_abyss312849_undo.sql. Restart + .reload eluna.
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=241109 AND `MenuID`=999999999;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38642,1,0,0,0,0,0,0,0,912047104,0,0,0,0,0,0,0,0);
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38643;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38643,1,0,0,0,0,0,0,0,285959,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38642,38642,0),(38643,38643,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38642,386420,0,0,'What about you?',0,0,0,38643,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38642,386421,1,0,'I want to talk about something else.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
UPDATE `quest_template` SET `AreaDescription`='What does she have planned...' WHERE `ID`=86531;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38434,1,0,0,0,0,0,0,0,912047090,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38434,38434,0);
