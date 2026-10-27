-- 86806 Luminous Wings mechanics (retail flow from video E3m8C7fw0H4 + wago 12.1.5 spell data):
--  * vehicle 240226: VehicleId 9019 = Vehicle.db2 single CanControl+CanCast seat with crosshair MissileTargeting 1052 and purple power display 569, matching the retail screenshot.
--  * Distressed civilians in the strait are rescued with Grappling Rope 1227927 (credit 241823 x3), not by gossip.
UPDATE creature_template SET VehicleId = 9019 WHERE entry = 240226; -- retail screenshot: crosshair (MissileTargeting 1052) + 5 purple pips (PowerDisplay 569 = purple energy)
DELETE FROM spell_target_position WHERE ID = 1224709 AND EffectIndex = 0;
INSERT INTO spell_target_position (ID, EffectIndex, OrderIndex, MapID, PositionX, PositionY, PositionZ, Orientation, VerifiedBuild)
VALUES (1224709, 0, 0, 2858, 10745.0, -4252.0, 18.0, 0.0, 0); -- Cancel Vehicle Aura: back to Lor'themar at the Silver Landing (video 2:05)
CREATE TABLE IF NOT EXISTS bak_20261021_ct_civilians LIKE creature_template;
INSERT INTO bak_20261021_ct_civilians SELECT * FROM creature_template WHERE entry IN (241790,241810,241817,241818,241819) AND entry NOT IN (SELECT entry FROM bak_20261021_ct_civilians);
CREATE TABLE IF NOT EXISTS bak_20261021_sai_civilians LIKE smart_scripts;
INSERT INTO bak_20261021_sai_civilians SELECT * FROM smart_scripts WHERE source_type=0 AND entryorguid IN (241790,241810,241817,241818,241819) AND NOT EXISTS (SELECT 1 FROM bak_20261021_sai_civilians b WHERE b.entryorguid=smart_scripts.entryorguid AND b.id=smart_scripts.id AND b.source_type=0);
UPDATE creature_template SET AIName='SmartAI', npcflag=0 WHERE entry IN (241790,241810,241817,241818,241819);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (241790,241810,241817,241818,241819);
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
SELECT e,0,id,0,8,0,100,0,1227927,0,0,0,0,act,p1,0,0,0,0,0,tt,0,0,0,0,0,0,0,0,cm FROM (
  SELECT e, 0 id, 33 act, 241823 p1, 7 tt, 'Luminous Wings - Grappling Rope hit - credit Distressed Civilian rescued' cm FROM (SELECT 241790 e UNION SELECT 241810 UNION SELECT 241817 UNION SELECT 241818 UNION SELECT 241819) x
  UNION ALL SELECT e, 1, 33, e, 7, 'Luminous Wings - Grappling Rope hit - credit own rescue' FROM (SELECT 241790 e UNION SELECT 241810 UNION SELECT 241817 UNION SELECT 241818 UNION SELECT 241819) y
  UNION ALL SELECT e, 2, 41, 1500, 1, 'Luminous Wings - Grappling Rope hit - despawn (pulled out of the water)' FROM (SELECT 241790 e UNION SELECT 241810 UNION SELECT 241817 UNION SELECT 241818 UNION SELECT 241819) z
) s;
