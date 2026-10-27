-- 86643: after the Zul'jan scene ends: Arator says 'That weapon...', runs to (6051.29,-5016.28,194.55), says final line (with player name), then 'Speak to Arator' credit (retail, user-described)
DELETE FROM smart_scripts WHERE source_type=10 AND entryorguid=9108603;
DELETE FROM smart_scripts WHERE source_type=9 AND entryorguid=23661002;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=9108603,source_type=10,id=0,event_type=81,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=80,action_param1=23661002,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=9,target_param1=236610,target_param2=0,target_param3=100,target_x=0,target_y=0,target_z=0,target_o=0,comment='Scene complete: Arator after-scene script';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661002,source_type=9,id=0,event_type=0,event_param1=0,event_param2=0,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=1,action_param1=3,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=7,target_param1=0,target_param2=0,target_param3=0,target_x=0,target_y=0,target_z=0,target_o=0,comment='Arator: That weapon... the lightwood';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661002,source_type=9,id=1,event_type=0,event_param1=200,event_param2=200,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=59,action_param1=1,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=1,target_param1=0,target_param2=0,target_param3=0,target_x=0,target_y=0,target_z=0,target_o=0,comment='Arator: run';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661002,source_type=9,id=2,event_type=0,event_param1=400,event_param2=400,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=69,action_param1=1,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=8,target_param1=0,target_param2=0,target_param3=0,target_x=6051.2876,target_y=-5016.282,target_z=194.54639,target_o=1.79,comment='Arator: run to 6051.29,-5016.28';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661002,source_type=9,id=3,event_type=0,event_param1=5500,event_param2=5500,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=1,action_param1=4,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=7,target_param1=0,target_param2=0,target_param3=0,target_x=0,target_y=0,target_z=0,target_o=0,comment='Arator: and they have locked the way forward (player name)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661002,source_type=9,id=4,event_type=0,event_param1=100,event_param2=100,event_param3=0,event_param4=0,event_param5=0,event_flags=0,action_type=33,action_param1=240558,action_param2=0,action_param3=0,action_param4=0,action_param5=0,action_param6=0,target_type=7,target_param1=0,target_param2=0,target_param3=0,target_x=0,target_y=0,target_z=0,target_o=0,comment='Credit Speak to Arator';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
