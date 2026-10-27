-- 86806 Luminous Wings: vehicle Empowered Dragonhawk 240226 (summoned by 1224696 -> 1224705, SummonProperties 6285 Control=4 vehicle).
-- Bar spells verified by the user on retail: 1224774 Spiraling Light, 1227927 Grappling Rope, 1227878 Speed of Light.
-- VehicleId: NOT in any retail source we have; chosen from Vehicle.db2 12.1.5 (single CanControl seat, flight pitch limits, no power bar). Revisit if a sniff appears.
CREATE TABLE IF NOT EXISTS bak_20261021_ct_240226 LIKE creature_template;
INSERT INTO bak_20261021_ct_240226 SELECT * FROM creature_template WHERE entry=240226 AND NOT EXISTS (SELECT 1 FROM bak_20261021_ct_240226 b WHERE b.entry=240226);
UPDATE creature_template SET VehicleId = 8921 WHERE entry = 240226;
DELETE FROM creature_template_spell WHERE CreatureID = 240226;
INSERT INTO creature_template_spell (CreatureID, `Index`, Spell, VerifiedBuild) VALUES
 (240226, 0, 1224774, 0), (240226, 1, 1227927, 0), (240226, 2, 1227878, 0);
-- 1224705 effect 0 uses TARGET_DEST_DB: vehicle appears where the static Empowered Dragonhawk 237221 lands (Silver Landing, video 0:12-0:20).
DELETE FROM spell_target_position WHERE ID = 1224705 AND EffectIndex = 0;
INSERT INTO spell_target_position (ID, EffectIndex, OrderIndex, MapID, PositionX, PositionY, PositionZ, Orientation, VerifiedBuild)
VALUES (1224705, 0, 0, 2858, 10725.2, -4248.93, 17.69, 3.21, 0);
-- Creature.db2 StartAnimState = 3 (fly) for the Empowered Dragonhawks: without it the vehicle stands in its upright ground pose
-- and the client camera sits at the top of the model (user screenshots 10:08). AnimTier 3 = Fly.
DELETE FROM creature_template_addon WHERE entry = 240226;
INSERT INTO creature_template_addon (entry, AnimTier) VALUES (240226, 3);
