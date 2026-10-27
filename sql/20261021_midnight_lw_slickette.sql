-- 86806: Umbral Slickette 241807 (3 in the strait, seen in the retail video around the sunk boats) killed the player.
-- Nothing in this quest attacks the rider: keep it hostile/attackable but passive, and only in the quest phase 45573 like the Soarlings.
CREATE TABLE IF NOT EXISTS bak_20261021_slickette_ct LIKE creature_template;
INSERT INTO bak_20261021_slickette_ct SELECT * FROM creature_template WHERE entry=241807 AND entry NOT IN (SELECT entry FROM bak_20261021_slickette_ct);
CREATE TABLE IF NOT EXISTS bak_20261021_slickette_cr LIKE creature;
INSERT INTO bak_20261021_slickette_cr SELECT * FROM creature WHERE id=241807 AND guid NOT IN (SELECT guid FROM bak_20261021_slickette_cr);
UPDATE creature SET PhaseId = 45573 WHERE id = 241807 AND map = 2858;
UPDATE creature_template SET AIName='SmartAI' WHERE entry=241807;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=241807;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
VALUES (241807,0,0,0,25,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Umbral Slickette - on reset - react passive');
