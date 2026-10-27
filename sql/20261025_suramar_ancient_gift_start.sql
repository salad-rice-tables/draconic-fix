-- Suramar campaign start for a fresh Nightborne: Thalyssra (phase 41077 at the Nightspire) offers "An Ancient Gift" (Arcane Communion 40324)
-- without the earlier Legion chain (was: An Old Ally rewarded AND Feeding Shal'Aran not done).
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=41077 AND ElseGroup=1;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,41077,7637,0,1,47,0,40012,64,0,'',1,0,0,'','Ancient Gift start: no An Old Ally'),
(26,41077,7637,0,1,47,0,42229,66,0,'',1,0,0,'','Ancient Gift start: no Shal Aran'),
(26,41077,7637,0,1,47,0,41138,66,0,'',1,0,0,'','Ancient Gift start: no Feeding Shal Aran');
