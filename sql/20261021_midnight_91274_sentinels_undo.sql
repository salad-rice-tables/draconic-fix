UPDATE creature_template t JOIN bak_20261021_ct_246255 b ON b.entry=t.entry SET t.npcflag=b.npcflag, t.AIName=b.AIName;
UPDATE creature c JOIN bak_20261021_cr_246255 b ON b.guid=c.guid SET c.PhaseId=b.PhaseId;
DELETE FROM creature_template_gossip WHERE CreatureID=246255;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (246239,246245,246251,246255) AND id IN (100,101);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=246227 AND id=101;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
SELECT e,0,100,0,64,0,100,0,0,0,0,0,0,33,e,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'On player opened gossip - Gossip player: Give kill credit' FROM (SELECT 246239 e UNION SELECT 246245 UNION SELECT 246251) a;
