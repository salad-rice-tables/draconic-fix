-- 91274 Severing the Void: "Activate 5 Quel'Danas Sentinels to destroy the Void Pylons".
-- Sentinel E (246255) was not usable (no npcflag/AI, phase 0 instead of the quest phase 45575 like A-D).
-- Every sentinel also counts toward "Sentinels activated" (246247 x5); the pylon credit (246317) follows from Lua after the 5th.
CREATE TABLE IF NOT EXISTS bak_20261021_ct_246255 LIKE creature_template;
INSERT INTO bak_20261021_ct_246255 SELECT * FROM creature_template WHERE entry=246255 AND entry NOT IN (SELECT entry FROM bak_20261021_ct_246255);
CREATE TABLE IF NOT EXISTS bak_20261021_cr_246255 LIKE creature;
INSERT INTO bak_20261021_cr_246255 SELECT * FROM creature WHERE id=246255 AND guid NOT IN (SELECT guid FROM bak_20261021_cr_246255);
UPDATE creature_template SET npcflag=3, AIName='SmartAI' WHERE entry=246255;
UPDATE creature SET PhaseId=45575 WHERE id=246255 AND map=2858;
DELETE FROM creature_template_gossip WHERE CreatureID=246255;
INSERT INTO creature_template_gossip (CreatureID, MenuID) SELECT 246255, MenuID FROM creature_template_gossip WHERE CreatureID=246227;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (246227,246239,246245,246251,246255) AND id IN (100,101);
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
SELECT e,0,100,0,64,0,100,0,0,0,0,0,0,33,e,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Severing the Void - activate sentinel - own credit' FROM (SELECT 246227 e UNION SELECT 246239 UNION SELECT 246245 UNION SELECT 246251 UNION SELECT 246255) a
UNION ALL
SELECT e,0,101,0,64,0,100,0,0,0,0,0,0,33,246247,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Severing the Void - activate sentinel - Sentinels activated' FROM (SELECT 246227 e UNION SELECT 246239 UNION SELECT 246245 UNION SELECT 246251 UNION SELECT 246255) b;
