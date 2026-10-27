-- 86510 Domus Penumbra v1 (Wiki Domus_Penumbra + retail broadcast).
-- Malloril: objektivy mierili na nespawnovane 235703 (duplicitny index!) -> 242628
-- (spawnuty pri Venatusovi) + SAI open-kredit. Bones GO-use nativne.
-- Anomander menu 42172 (research button + say; vendor button bez inventara SKIP).
-- Progress text (TDB ''). Accept scena s dabingom. Eluna: bones-Umbric says.
-- Follow-up: meat-lure, InnConv, elf-trigger, S02, vendor inventar.
-- Undo: 20261016_abyss6510_undo.sql. Restart + .reload eluna.
UPDATE `quest_objectives` SET `StorageIndex`=2, `ObjectID`=242628 WHERE `ID`=457838;
UPDATE `quest_objectives` SET `ObjectID`=242628 WHERE `ID`=457839;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (242628,0,101,0,64,100,0,0,33,242628,7,'86510 Malloril 242628 - talk credit (wiki)');
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (42172,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (42172,42172,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (42172,421720,0,0,'(Quest) <Inquire about Anomander''s research.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
UPDATE `quest_template` SET `AreaDescription`='Have you met my pets? I assure you, they are harmless. Unless, of course, they are hungry.' WHERE `ID`=86510;
