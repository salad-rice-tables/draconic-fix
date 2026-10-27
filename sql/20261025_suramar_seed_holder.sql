-- Ancient Seed Holder (GO 265435, phase 41089) must be visible to a Nightborne who never did 40012.
-- Idempotent: DELETE then INSERT (the first version stopped on a duplicate phase_area row and never ran the UPDATE).
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=41089 AND SourceEntry=7637;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment)
VALUES (26,41089,7637,0,1,47,0,42230,10,0,0,0,0,'','Seed Holder visible while Valewalkers Burden is active');

-- cosmetic phase 41089 (hotfix Flags 20) makes the GO non-interactable -> own non-cosmetic phase 60010 in Suramar for the holder
DELETE FROM phase_area WHERE AreaId=7637 AND PhaseId=60010;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (7637,60010,'Seed Holder (non-cosmetic phase)');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60010 AND SourceEntry=7637;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment)
VALUES (26,60010,7637,0,0,47,0,42230,10,0,0,0,0,'','Seed Holder visible while Valewalkers Burden is active');

UPDATE gameobject SET PhaseId=60010 WHERE guid=400000000011151394;
