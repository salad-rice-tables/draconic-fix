-- Sarkoth (3281): burrow & emerge. Kazdych ~45s: submerge emote 374 -> teleport o 8 yd
-- (-551.2,-4103.2,71.58; overit teren v hre!) -> emerge emote 449 -> poison 11918 na victim.
-- Emote ID overene v core SharedDefines.h (373/374 SUBMERGE, 449 EMERGE).
-- Akcia/teleport/target cisla overene v SmartScriptMgr.h/.cpp (5/62, target SELF=1).
-- UNDO: _undo.sql. Aktivacia po RESTARTE.
DELETE FROM `smart_scripts` WHERE `entryorguid`=3281 AND `source_type`=0 AND `id` IN (10,11,12,13);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param7`,`action_param_string`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3281,0,10,11,'',0,0,100,0,35000,45000,40000,55000,0,'',5,374,0,0,0,0,0,NULL,0,1,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Sarkoth - Burrow submerge emote'),
(3281,0,11,12,'',61,0,100,0,0,0,0,0,0,'',62,1,0,0,0,0,0,NULL,0,1,0,0,0,0,NULL,-551.2,-4103.2,71.58,1.7,'Sarkoth - Burrow teleport aside'),
(3281,0,12,13,'',61,0,100,0,0,0,0,0,0,'',5,449,0,0,0,0,0,NULL,0,1,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Sarkoth - Emerge emote'),
(3281,0,13,0,'',61,0,100,0,0,0,0,0,0,'',11,11918,0,0,0,0,0,NULL,0,2,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Sarkoth - Emerge poison');
