-- 86565 No Prayer for the Wicked v1 (Wiki No_Prayer_for_the_Wicked + retail broadcast).
-- Spawn Grafting Metal 532503 (POI 2167,2127 + vortex Z, faza 45759 = quest-progress).
-- Decimus menu 38620 (telo 912047078 + button 912047079); Alleria menu 912046906
-- (telo 912047082 + Listen 912047083 + certain 912047084); SAI zaloha Listen.
-- Says cez Eluna (dubbing kits 300687-300692) + temp-summony (speakri mimo faze).
-- 235535 starter unlink (zly kontext 38425). Cutscene "Decimus" + beam = follow-up.
-- Undo: 20261016_abyss86565_undo.sql. Aktivacia: restart + .reload eluna.
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`,`size`,`visibility`) VALUES (990000000101201018,532503,2771,0,0,'0',0,45759,0,-1,2167.0,2127.0,-55.17,0,0,0,0,0,0,255,1,'',NULL,0,-1,256.0);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235535 AND `MenuID`=38425;
UPDATE `npc_text` SET `BroadcastTextID0`=912047078 WHERE `ID`=38620;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (38620,386200,0,0,'<Ask for more information about the domanaar.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (912046906,1,0,0,0,0,0,0,0,912047082,0,0,0,0,0,0,0,0);
UPDATE `gossip_menu` SET `TextID`=912046906 WHERE `MenuID`=912046906;
UPDATE `gossip_menu_option` SET `GossipOptionID`=865650 WHERE `MenuID`=912046906 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `GossipOptionID`=865651 WHERE `MenuID`=912046906 AND `OptionID`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235609,0,101,0,62,100,865650,0,33,244305,7,'86565 Alleria 235609 - listen credit (wiki)');
