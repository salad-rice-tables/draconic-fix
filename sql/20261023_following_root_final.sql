-- 86643 final flow: 'Speak to Arator' credit on Play Movie click; quest completes -> phase 45630 Arator (guid 3000209807) stands at the stage-2 spot, after the scene he runs to the final spot and speaks
UPDATE creature SET position_x=6055.575,position_y=-5046.194,position_z=195.977,orientation=1.79 WHERE guid=3000209807;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=236610 AND id=102;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=236610,id=102,event_type=62,event_param1=912046766,event_param2=0,action_type=33,action_param1=240558,target_type=7,comment='Gossip select (Play Movie): credit Speak to Arator';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
DELETE FROM smart_scripts WHERE source_type=9 AND entryorguid=23661002 AND id IN (3,4);
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE source_type=9 AND entryorguid=23661002 AND id=0;
UPDATE t_ss SET id=3,event_param1=5500,event_param2=5500,action_param1=4,comment='Arator: and they have locked the way forward (player name)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
