-- 86806 Luminous Wings: the user placed the retail ships (10be_sunstridership.wmo) and rowboats in the Thalassian Strait.
-- Ships must stay visible from far away (otherwise the client drops them and the civilians on them stand in the water).
CREATE TABLE IF NOT EXISTS bak_20261021_go_lw LIKE gameobject;
INSERT INTO bak_20261021_go_lw SELECT * FROM gameobject WHERE guid IN (990000000101201134,990000000101201135,990000000101201136,990000000101201137,990000000101201138,990000000101201139) AND guid NOT IN (SELECT guid FROM bak_20261021_go_lw);
UPDATE gameobject SET visibility = 1000 WHERE guid IN (990000000101201134,990000000101201135,990000000101201136); -- big ships
UPDATE gameobject SET visibility = 500  WHERE guid IN (990000000101201137,990000000101201138,990000000101201139); -- rowboats
-- one Distressed Civilian per rowboat (positions = the user's .gps on each rowboat), sitting
CREATE TABLE IF NOT EXISTS bak_20261021_cr_lw LIKE creature;
INSERT INTO bak_20261021_cr_lw SELECT * FROM creature WHERE guid IN (3000201011,3000201013,3000201017) AND guid NOT IN (SELECT guid FROM bak_20261021_cr_lw);
UPDATE creature SET position_x=10520.363, position_y=-3968.952, position_z=1.30 WHERE guid=3000201011;
UPDATE creature SET position_x=10389.083, position_y=-4061.979, position_z=1.29 WHERE guid=3000201013;
UPDATE creature SET position_x=10393.411, position_y=-4141.513, position_z=1.26 WHERE guid=3000201017;
DELETE FROM creature_addon WHERE guid IN (3000201011,3000201013,3000201017);
INSERT INTO creature_addon (guid, StandState, visibilityDistanceType) VALUES (3000201011,1,3),(3000201013,1,3),(3000201017,1,3);
-- civilians signal for help with Flare 432189 (retail, user-verified; dummy shot above the caster)
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (241810,241817,241819) AND id=3;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
VALUES
(241810,0,3,0,1,0,100,0,2000,8000,12000,20000,0,11,432189,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Luminous Wings - OOC - cast Cosmetic Flare'),
(241817,0,3,0,1,0,100,0,2000,8000,12000,20000,0,11,432189,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Luminous Wings - OOC - cast Cosmetic Flare'),
(241819,0,3,0,1,0,100,0,2000,8000,12000,20000,0,11,432189,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Luminous Wings - OOC - cast Cosmetic Flare');
