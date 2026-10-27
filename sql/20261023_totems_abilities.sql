-- 86643 totems fight like retail (video DGoB3uGnnR0 + Wowhead): Grimfire Totem casts Firestorm 417620, Stranglemist Totem casts Poison Nova 1254305 (0.5s cast); stationary, no melee
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866);
UPDATE creature_template SET AIName='SmartAI' WHERE entry IN (251863,251866);
DELETE FROM creature_template_spell WHERE CreatureID IN (251863,251866);
INSERT INTO creature_template_spell (CreatureID,`Index`,Spell,VerifiedBuild) VALUES (251863,0,417620,70391),(251866,0,1254305,70391);
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=251863,id=0,event_type=4,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_flags=0,action_type=20,action_param1=0,action_param2=0,action_param3=0,target_type=1,comment='On aggro: no auto attack (totem)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251863,id=1,event_type=4,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_flags=0,action_type=21,action_param1=0,action_param2=0,action_param3=0,target_type=1,comment='On aggro: no combat movement';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251863,id=2,event_type=0,event_param1=1000,event_param2=2000,event_param3=12000,event_param4=15000,event_flags=0,action_type=11,action_param1=417620,action_param2=2,action_param3=0,target_type=1,comment='IC repeat: cast Firestorm (retail ability)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251866,id=0,event_type=4,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_flags=0,action_type=20,action_param1=0,action_param2=0,action_param3=0,target_type=1,comment='On aggro: no auto attack (totem)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251866,id=1,event_type=4,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_flags=0,action_type=21,action_param1=0,action_param2=0,action_param3=0,target_type=1,comment='On aggro: no combat movement';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251866,id=2,event_type=0,event_param1=1000,event_param2=2000,event_param3=12000,event_param4=15000,event_flags=0,action_type=11,action_param1=1254305,action_param2=2,action_param3=0,target_type=1,comment='IC repeat: cast Poison Nova (retail ability)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
