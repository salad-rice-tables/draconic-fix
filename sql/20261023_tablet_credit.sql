-- Tablet inspected: SAI gossip replaces the native goober use, so the GO objective is converted to a creature credit (client shows the same text)
DELETE FROM creature_template WHERE entry=9108870;
CREATE TEMPORARY TABLE t_ct SELECT * FROM creature_template WHERE entry=242144;
UPDATE t_ct SET entry=9108870,name='Kill Credit: Amani Riddle inspected';
INSERT INTO creature_template SELECT * FROM t_ct;
DROP TEMPORARY TABLE t_ct;
INSERT IGNORE INTO creature_template_model (CreatureID,Idx,CreatureDisplayID,DisplayScale,Probability,VerifiedBuild) SELECT 9108870,Idx,CreatureDisplayID,DisplayScale,Probability,VerifiedBuild FROM creature_template_model WHERE CreatureID=242144;
UPDATE quest_objectives SET Type=0,ObjectID=9108870 WHERE ID=460719 AND QuestID=86644;
DELETE FROM smart_scripts WHERE source_type=1 AND entryorguid=544004 AND id=1;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE source_type=1 AND entryorguid=544004 AND id=0;
UPDATE t_ss SET id=1,action_type=33,action_param1=9108870,action_param2=0,target_type=7,comment='Tablet inspected credit';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
