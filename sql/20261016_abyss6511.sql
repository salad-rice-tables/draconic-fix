-- 86511 Edge of the Abyss v1 (Wiki + retail broadcast 91204712x).
-- Maella menu 38390 (telo + report button + SAI zaloha -> 239349).
-- Decimus menu 38440 (telo + 2 buttony + submenu 38441/38442); 38441 repasovane
-- (sirota 'Pumped up!', nikto ju nepouzival). Starter 238296 unlink (mrtvy link).
-- Progress text (TDB ''). Eluna: accept scena + report scena (temp-summon speakri).
-- Undo: 20261016_abyss6511_undo.sql. Restart + .reload eluna.
DELETE FROM `gossip_menu_option` WHERE `MenuID`=38441;
UPDATE `gossip_menu` SET `TextID`=38441 WHERE `MenuID`=38441;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38441,1,0,0,0,0,0,0,0,912047126,0,0,0,0,0,0,0,0);
UPDATE `npc_text` SET `BroadcastTextID0`=912047121 WHERE `ID`=38390;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (38440,1,0,0,0,0,0,0,0,912047123,0,0,0,0,0,0,0,0),
 (38442,1,0,0,0,0,0,0,0,912047127,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38390,38390,0),(38440,38440,0),(38442,38442,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38390,383900,0,0,'(Quest) <Hear the scouting report.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38440,384400,0,0,'<Ask about Torentia.>',0,0,0,38441,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38440,384401,1,0,'<Ask about Severum.>',0,0,0,38442,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235633,38440,0);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=238296 AND `MenuID`=912046929;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (239349,0,101,0,62,100,383900,0,33,239349,7,'86511 Maella 239349 - report credit (wiki)');
UPDATE `quest_template` SET `AreaDescription`='I have avoided this place until now. The howls and the stench are carried on the wind like a warning.' WHERE `ID`=86511;
