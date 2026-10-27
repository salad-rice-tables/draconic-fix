-- 86643 totems: not attackable (spellclick 'Destroying' needs interaction, hostile+attackable makes the client attack instead), still hostile faction and still cast at nearby players
UPDATE creature_template SET unit_flags=unit_flags|2, npcflag=npcflag|16777216, faction=14 WHERE entry IN (251863,251866);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866);
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=251863,id=0,event_type=10,event_param1=0,event_param2=40,event_param3=9000,event_param4=12000,event_param5=1,event_flags=0,action_type=11,action_param1=417620,action_param2=0,action_param3=0,target_type=1,comment='Player in sight: Firestorm (retail ability)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=251866,id=0,action_param1=1254305,comment='Player in sight: Poison Nova (retail ability)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
