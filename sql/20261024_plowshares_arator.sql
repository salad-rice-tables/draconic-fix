-- 89338 Gathering Plowshares: Arator must be present next to Dezco while the quest is in progress (talk lines)
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60020,9734,0,2,47,0,89338,74,0,'',0,0,0,'','Hammerfall 60020: Gathering Plowshares');
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,PhaseId,PhaseGroup,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,unit_flags) VALUES
(3100920008,241428,0,0,0,'0',60020,0,0,0,-940.5,-3537.0,70.5,3.1,300,0,0,100,0,32768);
