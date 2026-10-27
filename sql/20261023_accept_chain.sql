-- world: conversation 9108604 (actors: Arator 241205 guid 3000202510, Lor'themar guid 3000203527, Halduron guid 3000203134)
DELETE FROM conversation_actors WHERE ConversationId=9108604;
DELETE FROM conversation_line_template WHERE Id IN (82094,82371);
DELETE FROM conversation_template WHERE Id=9108604;
INSERT INTO conversation_template (Id,FirstLineId,TextureKitId,Flags,ScriptName,VerifiedBuild) VALUES (9108604,82094,0,0,'',70391);
INSERT INTO conversation_line_template (Id,UiCameraID,ActorIdx,Flags,ChatType,VerifiedBuild) VALUES (82094,0,0,0,0,70391),(82371,0,1,0,0,70391);
UPDATE conversation_line_template SET ActorIdx=2 WHERE Id BETWEEN 87529 AND 87534;
INSERT INTO conversation_actors (ConversationId,ConversationActorId,ConversationActorGuid,Idx,CreatureId,CreatureDisplayInfoId,NoActorObject,ActivePlayerObject,VerifiedBuild) VALUES (9108604,9108611,3000202510,0,241205,0,0,0,70391),(9108604,9108612,3000203527,1,241206,0,0,0,70391),(9108604,9108613,3000203134,2,241176,0,0,0,70391);
-- accept SAI on Arator: start the new chain, drop separate Arator say + old Halduron conversation
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=241205 AND id IN (111,112,113);
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=241205,id=112,event_type=19,event_param1=86643,action_type=143,action_param1=9108604,target_type=7,comment='On quest accept 86643: Arator + Lor''themar + Halduron conversation';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
