-- 86643 Following the Root: Zul'jan conversation (retail ConversationLine 89276-89291, BroadcastText 304174-304189), played on Arator gossip select
DELETE FROM conversation_actors WHERE ConversationId=9108601;
DELETE FROM conversation_line_template WHERE Id BETWEEN 89276 AND 89291;
DELETE FROM conversation_template WHERE Id=9108601;
INSERT INTO conversation_template (Id,FirstLineId,TextureKitId,Flags,ScriptName,VerifiedBuild) VALUES (9108601,89276,0,0,'',70391);
INSERT INTO conversation_line_template (Id,UiCameraID,ActorIdx,Flags,ChatType,VerifiedBuild) VALUES (89276,0,0,0,0,70391),(89277,0,0,0,0,70391),(89278,0,0,0,0,70391),(89279,0,0,0,0,70391),(89280,0,0,0,0,70391),(89281,0,0,0,0,70391),(89282,0,0,0,0,70391),(89283,0,0,0,0,70391),(89284,0,0,0,0,70391),(89285,0,0,0,0,70391),(89286,0,0,0,0,70391),(89287,0,0,0,0,70391),(89288,0,0,0,0,70391),(89289,0,0,0,0,70391),(89290,0,0,0,0,70391),(89291,0,0,0,0,70391);
INSERT INTO conversation_actors (ConversationId,ConversationActorId,ConversationActorGuid,Idx,CreatureId,CreatureDisplayInfoId,NoActorObject,ActivePlayerObject,VerifiedBuild) VALUES (9108601,9108601,0,0,235901,125150,0,0,70391);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=236610 AND id=103;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=244042 AND source_type=0 AND id=101;
UPDATE t_ss SET entryorguid=236610,id=103,event_type=62,event_param1=912046766,event_param2=0,action_type=143,action_param1=9108601,comment='Gossip select: start Zul''jan conversation (86643)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
