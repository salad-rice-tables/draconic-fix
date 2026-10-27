-- 86643: 'Play Movie' gossip only after Warding totems are 4/4 (objective 464905), scene script needs ScriptName SmartScene to receive SMART_EVENT_SCENE_COMPLETE
DELETE FROM conditions WHERE SourceTypeOrReferenceId=15 AND SourceGroup=912046766 AND SourceEntry=0;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES (15,912046766,0,0,0,48,0,464905,0,4,0,0,0,'','Arator: Play Movie only after 4/4 Warding totems (86643)');
UPDATE scene_template SET ScriptName='SmartScene' WHERE SceneId=9108603;
