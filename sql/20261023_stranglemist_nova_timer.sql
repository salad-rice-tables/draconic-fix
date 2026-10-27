-- Stranglemist: Poison Nova every ~9-12s (OOC timer; LOS event never fired on a non-attackable totem). Grimfire keeps its Firestorm aura (398541), SAI cast removed.
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866);
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=251866,id=0,event_type=1,event_param1=3000,event_param2=5000,event_param3=9000,event_param4=12000,event_param5=0,event_flags=0,action_type=11,action_param1=1254305,action_param2=0,action_param3=0,target_type=1,comment='OOC timer: Poison Nova (retail ability, only this)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
