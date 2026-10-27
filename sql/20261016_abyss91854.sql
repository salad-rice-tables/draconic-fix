-- 91854 Deepening Shadows: mŕtve menu/buttony ako 91967 (Wiki Deepening_Shadows_(quest) verbatim,
-- broadcast hotfixes 91204719x/29485x/2953xx). Recept: unikatne GossipOptionID (=MenuID),
-- OptionNpc 3->0, kredity Eluna (primarne) + SmartAI zaloha, VO cez Eluna SoundKit.
-- Retry: Koruth unlink (menu 999999999 patri 7331 NPC - NEMAZAT menu, len link!),
-- Oathstone auto-kredit prec (nie je objektiv), Progress text spat na 91854 (bol omylom na 92061).
-- Undo: 20261016_abyss91854_undo.sql. Aktivacia: restart (gossip boot load) + .reload eluna.

-- 1. Koruth 248631: prec link na prazdne menu + Oathstone auto-kredit (event 64/action 33, ciel 248631 nie je objektiv)
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=248631 AND `MenuID`=999999999;
DELETE FROM `smart_scripts` WHERE `entryorguid`=248631 AND `id`=100 AND `event_type`=64 AND `action_type`=33;

-- 2. Aeroknight 249175: mrtvy link 912046986 -> nove menu 40201 (Wiki gossip, bez buttonu - retail nema)
UPDATE `creature_template_gossip` SET `MenuID`=40201 WHERE `CreatureID`=249175 AND `MenuID`=912046986;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40201,40201,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (40201,1,0,0,0,0,0,0,0,912047205,0,0,0,0,0,0,0,0);

-- 3. npc_text tela oken (retail broadcast hotfixes)
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (40105,1,0,0,0,0,0,0,0,912047194,0,0,0,0,0,0,0,0),
 (40134,1,0,0,0,0,0,0,0,912047201,0,0,0,0,0,0,0,0),
 (40189,1,0,0,0,0,0,0,0,912047190,0,0,0,0,0,0,0,0);
UPDATE `npc_text` SET `BroadcastTextID0`=912047204 WHERE `ID`=40190;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40190,40190,0);
UPDATE `gossip_menu` SET `TextID`=40105 WHERE `MenuID`=40105;
UPDATE `gossip_menu` SET `TextID`=40134 WHERE `MenuID`=40134;
UPDATE `gossip_menu` SET `TextID`=40189 WHERE `MenuID`=40189;

-- 4. buttony: OptionNpc 3->0, unikatne GossipOptionID, retail texty verbatim
UPDATE `gossip_menu_option` SET `OptionNpc`=0, `GossipOptionID`=401340, `OptionText`='(Quest) <Explain the events of the Sunwell.>' WHERE `MenuID`=40134 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `OptionNpc`=0, `GossipOptionID`=401890, `OptionText`='(Quest) Why are you seizing people?' WHERE `MenuID`=40189 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (40189,401891,1,0,'(Quest) Arresting citizens is not why the Vanguard are here.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
UPDATE `gossip_menu_option` SET `OptionNpc`=0, `GossipOptionID`=401050, `OptionText`='(Quest) <Discourage the spread of panic.>' WHERE `MenuID`=40105 AND `OptionID`=2;
UPDATE `gossip_menu_option` SET `OptionNpc`=0, `GossipOptionID`=401051, `OptionText`='(Quest) <Hail the victories of the Vanguard and sin''dorei you have seen so far.>' WHERE `MenuID`=40105 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `OptionNpc`=0, `GossipOptionID`=401052, `OptionText`='(Quest) <Say nothing.>' WHERE `MenuID`=40105 AND `OptionID`=1;

-- 5. SmartAI zaloha kreditov (Eluna je primarna): event 62 select, param1=GossipOptionID, param2=OptionID
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (249174,0,101,0,62,100,401340,0,33,249174,7,'91854 Vendor 249174 - dispute credit (wiki)'),
 (248630,0,101,0,62,100,401890,0,33,248630,7,'91854 Venel 248630 - prisoner credit btn0 (wiki)'),
 (248630,0,102,0,62,100,401891,1,33,248630,7,'91854 Venel 248630 - prisoner credit btn1 (wiki)'),
 (248826,0,101,0,62,100,401050,2,33,248826,7,'91854 Doomsayer 248826 - rebuff credit opt2 (wiki)'),
 (248826,0,102,0,62,100,401051,0,33,248826,7,'91854 Doomsayer 248826 - rebuff credit opt0 (wiki)'),
 (248826,0,103,0,62,100,401052,1,33,248826,7,'91854 Doomsayer 248826 - rebuff credit opt1 (wiki)');

-- 6. Progress text spat na 91854 (Wiki Progress "Tensions are high."); z 92061 prec (TDB parita '')
UPDATE `quest_template` SET `AreaDescription`='Tensions are high.' WHERE `ID`=91854;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=92061;
