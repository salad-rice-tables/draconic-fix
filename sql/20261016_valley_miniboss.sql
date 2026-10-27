-- Yarrog Baneshadow (3183, Elite): CoW opener + Bolt 686 + Immo 348 + Felstalker summon.
-- (Sarkoth 3281 uz ma retail kit: Poison 11918 + Weak Poison 6751 + Harden 79840 - netreba nic.)
-- Ziadne existujuce SAI pre Yarrog combat (okrem 9613/StopMoving) - INSERTy bez kolizii. UNDO: _undo.sql.
-- Aktivacia az po RESTARTE (SmartAI load pri boote).
DELETE FROM `smart_scripts` WHERE `entryorguid`=3183 AND `source_type`=0 AND `id` IN (0,1,2,3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param7`,`action_param_string`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3183,0,0,0,'',4,0,100,0,0,0,0,0,0,'',11,702,0,0,0,0,0,NULL,0,2,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Yarrog Baneshadow - On Aggro - Curse of Weakness'),
(3183,0,1,0,'',0,0,100,0,2000,3000,5000,7000,0,'',11,686,0,0,0,0,0,NULL,0,2,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Yarrog Baneshadow - In combat - Shadow Bolt'),
(3183,0,2,0,'',0,0,100,0,8000,12000,15000,20000,0,'',11,348,0,0,0,0,0,NULL,0,2,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Yarrog Baneshadow - In combat - Immolate'),
(3183,0,3,0,'',4,0,100,0,0,0,0,0,0,'',12,3102,1,60000,0,0,0,NULL,0,8,0,0,0,0,NULL,0.0,0.0,0.0,0.0,'Yarrog Baneshadow - On Aggro - Summon Felstalker');
