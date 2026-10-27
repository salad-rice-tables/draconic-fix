-- 86544 Post-Mortem + 86545 The Light's Brand DB v1 (Wiki verbatim + retail broadcast).
-- 86544: DELETE stale marker 240881 (dup idx, nikdy nesplnitelny); Progress text;
-- 4 gossip menu (tela+buttony) + Listen rebuild + SAI zalohy; scouts unlink.
-- 86545: objective restore (Gather single x15, Find idx1, Reveal 240691, zmazane
-- gather-extra + Find-duplikat); Progress text ($n); Arator healing menu; Reveal
-- open-kredit SAI. Eluna (sceny/dialogy/healing) = dalsie kolo s Wiki v ruke.
-- Undo: 20261016_abyss4455_undo.sql. Restart + .reload eluna.
DELETE FROM `quest_objectives` WHERE `ID`=459677;
UPDATE `quest_template` SET `AreaDescription`='Mother... Hang in there.' WHERE `ID`=86544;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (38545,1,0,0,0,0,0,0,0,912047107,0,0,0,0,0,0,0,0),
 (38544,1,0,0,0,0,0,0,0,912047109,0,0,0,0,0,0,0,0),
 (38552,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
 (38551,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38545,38545,0),(38544,38544,0),(38552,38552,0),(38551,38551,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38545,385450,0,0,'(Quest) <Ask for his report on the wilds.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38544,385440,0,0,'<Ask for her report on the wilds.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38552,385520,0,0,'<Explain yourself.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38551,385510,0,0,'(Quest) <Ask how Lothraxion is doing.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (239724,0,102,0,62,100,385450,0,33,240559,7,'86544 Hieron - report credit (wiki)'),
 (240538,0,102,0,62,100,385440,0,33,236630,7,'86544 Maella - report credit (wiki)'),
 (235653,0,102,0,62,100,385520,0,33,240572,7,'86544 Decimus - check credit (wiki)'),
 (235725,0,102,0,62,100,385510,0,33,240571,7,'86544 Lothraxion - check credit (wiki)');
UPDATE `gossip_menu_option` SET `OptionText`='Stay awhile and Listen.', `OptionBroadcastTextID`=0, `GossipOptionID`=865441 WHERE `MenuID`=912046918 AND `OptionID`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235664,0,101,0,62,100,865441,0,33,235664,7,'86544 Alleria - listen credit (wiki)');
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=240546 AND `MenuID`=999999999;
UPDATE `quest_template` SET `AreaDescription`='I should have realized earlier... Join me. $n, Let us reveal the truth.' WHERE `ID`=86545;
DELETE FROM `quest_objectives` WHERE `ID` IN (459568,459569,459571,461345);
UPDATE `quest_objectives` SET `StorageIndex`=1 WHERE `ID`=459567;
UPDATE `quest_objectives` SET `StorageIndex`=0, `Amount`=15 WHERE `ID`=459541;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (39077,39077,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (39077,390770,0,0,'<Ask Arator for healing.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
