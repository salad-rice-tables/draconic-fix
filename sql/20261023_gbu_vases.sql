-- 86644 vases (GO 542849): use with Bonecarapace Fangs (244143) -> 'Vase 1 filled' (244859); Bloodvein Clot (244144) -> 'Vase 2 filled' (244860);
-- both filled -> 'Amani Riddle solved' (242144) + Arator says 'The mist ward is gone!'. State comes from quest objective progress conditions (stateless).
UPDATE gameobject_template SET AIName='SmartGameObjectAI' WHERE entry=542849;
DELETE FROM smart_scripts WHERE source_type=1 AND entryorguid=542849;
DELETE FROM conditions WHERE SourceTypeOrReferenceId=22 AND SourceEntry=542849 AND SourceId=1;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=542849,source_type=1,id=0,event_type=64,action_type=33,action_param1=244859,target_type=7,comment='Vase used with Bonecarapace Fangs: Vase 1 filled';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=1,action_type=57,action_param1=244143,action_param2=1,comment='Remove Bonecarapace Fangs';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=2,action_type=33,action_param1=244860,action_param2=0,comment='Vase used with Bloodvein Clot: Vase 2 filled';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=3,action_type=57,action_param1=244144,action_param2=1,comment='Remove Bloodvein Clot';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=4,action_type=33,action_param1=242144,action_param2=0,comment='Both vases filled: Amani Riddle solved';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=5,action_type=80,action_param1=23661010,target_type=9,target_param1=236610,target_param2=0,target_param3=60,comment='Arator: mist ward is gone';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
-- conditions (SourceGroup = event id + 1)
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(22,1,542849,1,0,2,0,244143,1,0,0,0,0,'','vase: has Bonecarapace Fangs'),
(22,1,542849,1,0,48,0,461815,0,0,0,0,0,'','vase 1 not yet filled'),
(22,2,542849,1,0,2,0,244143,1,0,0,0,0,'','vase: has Fangs (remove)'),
(22,2,542849,1,0,48,0,461815,0,1,0,0,0,'','vase 1 filled'),
(22,3,542849,1,0,2,0,244144,1,0,0,0,0,'','vase: has Bloodvein Clot'),
(22,3,542849,1,0,48,0,461819,0,0,0,0,0,'','vase 2 not yet filled'),
(22,4,542849,1,0,2,0,244144,1,0,0,0,0,'','vase: has Clot (remove)'),
(22,4,542849,1,0,48,0,461819,0,1,0,0,0,'','vase 2 filled'),
(22,5,542849,1,0,48,0,461815,0,1,0,0,0,'','both filled: v1'),
(22,5,542849,1,0,48,0,461819,0,1,0,0,0,'','both filled: v2'),
(22,5,542849,1,0,48,0,461814,0,0,0,0,0,'','riddle not yet solved'),
(22,6,542849,1,0,48,0,461815,0,1,0,0,0,'','both filled: v1 (arator)'),
(22,6,542849,1,0,48,0,461819,0,1,0,0,0,'','both filled: v2 (arator)'),
(22,6,542849,1,0,48,0,461814,0,1,0,0,0,'','riddle solved just now');
