-- 86710 The Line Must be Drawn Here: clean dedicated phase 60010 (normal, non-cosmetic) active while the quest is in progress.
-- Everything of the in-progress scene lives here; 45638/45640 revert to their original roles.
DELETE FROM phase_area WHERE PhaseId=60010;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (15968,60010,'86710 The Line Must be Drawn Here (in progress) clean phase');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60010;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60010,15968,0,0,47,0,86710,8,0,0,0,0,'','86710 in progress');
-- Zul'jan back to the original entry 249211 (clone 9108871 was a test)
UPDATE creature SET id=249211 WHERE id=9108871;
-- copy scene creatures (Blood Knights, Amani, Zul'jarra, Zul'jan, Liadrin) from 45638/45640 into 60010
DROP TEMPORARY TABLE IF EXISTS t_c;
CREATE TEMPORARY TABLE t_c SELECT * FROM creature WHERE PhaseId IN (45638,45640) AND id IN (236505,240902,236461,249211,236436);
SET @g=3100910000;
UPDATE t_c SET guid=(@g:=@g+1), PhaseId=60010;
INSERT INTO creature SELECT * FROM t_c;
-- original phases: 45640 only before 86710 is started (as retail), 45638 goes unused for these NPCs
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=45640 AND ConditionTypeOrReference=47 AND ConditionValue1=86710;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,45640,15968,0,0,47,0,86710,8,0,1,0,0,'','not while 86710 in progress (scene is in 60010)');
