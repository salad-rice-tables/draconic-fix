-- 2026-10-25 Suramar: missing quest NPC spawns
-- Ivanel Meadowsong 106095 (Not Their Last Stand, 40949), Wowhead map 29.6/18.4 Suramar.
-- Starving Ettin 104220 (drops Grotesque Ettin Leather 137179 for 41462), Wowhead map 21-23/25-29 Suramar.
-- Z taken from the nearest surface spawns; the low-z cave points of the ettin are skipped.

INSERT INTO creature (guid, id, map, zoneId, areaId, spawnDifficulties, phaseUseFlags, PhaseId, PhaseGroup, terrainSwapMap, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, wander_distance, currentwaypoint, curHealthPct, MovementType, npcflag, unit_flags, unit_flags2, unit_flags3, ScriptName, StringId, VerifiedBuild, size) VALUES
(990000000101165052, 106095, 1220, 7637, 8219, 0, 0, 0, 0, -1, 0, 0, 2764.65, 5014.91, 198.95, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1),
(990000000101165053, 104220, 1220, 7637, 8230, 0, 0, 0, 0, -1, 0, 0, 2446.27, 5481.29, 140.97, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1),
(990000000101165054, 104220, 1220, 7637, 8230, 0, 0, 0, 0, -1, 0, 0, 2431.46, 5459.08, 139.29, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1),
(990000000101165055, 104220, 1220, 7637, 8230, 0, 0, 0, 0, -1, 0, 0, 2505.50, 5425.77, 135.92, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1),
(990000000101165056, 104220, 1220, 7637, 8230, 0, 0, 0, 0, -1, 0, 0, 2431.46, 5359.14, 126.75, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1),
(990000000101165057, 104220, 1220, 7637, 8230, 0, 0, 0, 0, -1, 0, 0, 2416.65, 5359.14, 126.75, 0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 22810, -1);

-- 41462 Trouble Has Huge Feet is started by Grotesque Ettin Leather 137179.
UPDATE quest_template SET StartItem = 137179 WHERE ID = 41462;
