-- 86643: 'Speak to Arator' credit (240558) on gossip select, not on open
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=236610 AND id=102;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=236610,id=102,event_type=62,event_param1=912046766,event_param2=0,action_param1=240558,comment='Gossip select: credit Speak to Arator (86643)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
