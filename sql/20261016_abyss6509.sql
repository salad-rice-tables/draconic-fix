-- 86509 Friend or Fiend v1 (Wiki Friend_or_Fiend + retail broadcast).
-- Decimus 235697 unlink (prazdne menu). Lothraxion 235473 menu 40206 (blank + Listen
-- button + SAI zaloha -> 243760). Travel proximity (714,-424) -> kredit 241126 +
-- Decimus say (dabing). Accept scena + Listen dialog (Wiki literaly, 9 says).
-- Turn-in nativny (45775 OK). Undo: 20261016_abyss6509_undo.sql. Restart + .reload eluna.
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235697 AND `MenuID`=39120;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (40206,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40206,40206,0);
UPDATE `creature_template_gossip` SET `MenuID`=40206 WHERE `CreatureID`=235473 AND `MenuID`=912046927;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (40206,402060,0,0,'Stay awhile and Listen.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235473,0,101,0,62,100,402060,0,33,243760,7,'86509 Lothraxion 235473 - listen credit (wiki)');
