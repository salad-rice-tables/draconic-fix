-- Undo 20261016_abyss91854.sql (91854 Deepening Shadows). Obnovuje povodny stav.
DELETE FROM `gossip_menu_option` WHERE `MenuID`=40189 AND `OptionID`=1 AND `GossipOptionID`=401891;
UPDATE `gossip_menu_option` SET `OptionNpc`=3, `GossipOptionID`=0, `OptionText`='(Demand the prisoner be released.)' WHERE `MenuID`=40189 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `OptionNpc`=3, `GossipOptionID`=0, `OptionText`='(Ask about the dispute.)' WHERE `MenuID`=40134 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `OptionNpc`=3, `GossipOptionID`=0, `OptionText`='Hail the victories of the Vanguard and sin???dorei you have seen so far.' WHERE `MenuID`=40105 AND `OptionID`=0;
UPDATE `gossip_menu_option` SET `OptionNpc`=3, `GossipOptionID`=0, `OptionText`='Say nothing.' WHERE `MenuID`=40105 AND `OptionID`=1;
UPDATE `gossip_menu_option` SET `OptionNpc`=3, `GossipOptionID`=0, `OptionText`='Discourage the spread of panic.' WHERE `MenuID`=40105 AND `OptionID`=2;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (249174,248630,248826) AND `id`>=101 AND `comment` LIKE '91854%';
DELETE FROM `npc_text` WHERE `ID` IN (40105,40134,40189,40201);
UPDATE `npc_text` SET `BroadcastTextID0`=193960 WHERE `ID`=40190;
DELETE FROM `gossip_menu` WHERE `MenuID` IN (40190,40201);
UPDATE `gossip_menu` SET `TextID`=9500101 WHERE `MenuID`=40105;
UPDATE `gossip_menu` SET `TextID`=9500102 WHERE `MenuID`=40134;
UPDATE `gossip_menu` SET `TextID`=9500103 WHERE `MenuID`=40189;
UPDATE `creature_template_gossip` SET `MenuID`=912046986 WHERE `CreatureID`=249175 AND `MenuID`=40201;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (248631,999999999,47936);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES (248631,0,100,0,64,0,100,0,0,0,0,0,0,'',33,248631,0,0,0,0,'',7,0,0,0,0,0,0,0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=91854;
UPDATE `quest_template` SET `AreaDescription`='Tensions are high.' WHERE `ID`=92061;
