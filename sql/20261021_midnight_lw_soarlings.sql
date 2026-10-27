-- 86806 Luminous Wings (retail per user): all Voidborn Soarlings 240263 are hostile (red) but never attack, and all hover in the air.
CREATE TABLE IF NOT EXISTS bak_20261021_soarling_ct LIKE creature_template;
INSERT INTO bak_20261021_soarling_ct SELECT * FROM creature_template WHERE entry=240263 AND entry NOT IN (SELECT entry FROM bak_20261021_soarling_ct);
CREATE TABLE IF NOT EXISTS bak_20261021_soarling_ctd LIKE creature_template_difficulty;
INSERT INTO bak_20261021_soarling_ctd SELECT * FROM creature_template_difficulty WHERE Entry=240263 AND Entry NOT IN (SELECT Entry FROM bak_20261021_soarling_ctd);
CREATE TABLE IF NOT EXISTS bak_20261021_soarling_cr LIKE creature;
INSERT INTO bak_20261021_soarling_cr SELECT * FROM creature WHERE id=240263 AND guid NOT IN (SELECT guid FROM bak_20261021_soarling_cr);
UPDATE creature_template_difficulty SET StaticFlags1 = StaticFlags1 | 0x20000000 WHERE Entry = 240263;   -- FLOATING: disable gravity
UPDATE creature SET position_z = 30 + (guid % 25) WHERE id = 240263 AND position_z < 25;               -- no swimmers: lift into the air
UPDATE creature_template SET AIName='SmartAI' WHERE entry=240263;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=240263;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
VALUES (240263,0,0,0,25,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidborn Soarling - on reset - react passive (never attacks, only gets shot)');
-- civilians fire Cosmetic Flare constantly (every 2-3 s, per retail)
UPDATE smart_scripts SET event_param1=1000, event_param2=2000, event_param3=2000, event_param4=3000 WHERE source_type=0 AND entryorguid IN (241810,241817,241819) AND id=3;
