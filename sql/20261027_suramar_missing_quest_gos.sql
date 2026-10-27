-- 2026-10-27 Suramar: missing quest gameobject spawns (batch 1, one per entry)
-- Positions from world.quest_poi_points (quest objective polygons/points), converted
-- to world X/Y. Z from the nearest real surface spawn; area/zone from AreaTable.csv.
-- All are phase 0; nearby quest phases (41088/41125/41151/45227-45229) are cosmetic.
-- Batch 1 = one object per missing entry (12). Batch 2 (after in-game check) will
-- expand Q42082 (13 shards per type) and Q44867 (17 orders), if needed.
-- Q42082 Shattered Locus 8158, Q42230 Temple of Fal'adora 8163, Q44002 Azuregale Bay 7917,
-- Q44811 Evermoon Commons 7970, Q44812 Twilight Vineyards 8149, Q44867 Felborne Outpost 8503.

INSERT INTO `gameobject`
(`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,
 `terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,
 `rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,
 `VerifiedBuild`,`size`,`visibility`) VALUES
(990000000102000001, 249405, 1220, 7637, 8158, '0', 0, 0, 0, -1, 2189.33, 5491.67, 1.60, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000002, 249413, 1220, 7637, 8158, '0', 0, 0, 0, -1, 2206.75, 5500.25, 1.65, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000003, 249414, 1220, 7637, 8158, '0', 0, 0, 0, -1, 2187.50, 5463.25, 1.60, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000004, 251047, 1220, 7637, 8163, '0', 0, 0, 0, -1, 2370.00, 5443.00, 41.00, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000005, 253085, 1220, 7637, 7917, '0', 0, 0, 0, -1, 1373.00, 2294.00, -85.50, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000006, 253086, 1220, 7637, 7917, '0', 0, 0, 0, -1, 1109.00, 2242.00, -139.00, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000007, 253087, 1220, 7637, 7917, '0', 0, 0, 0, -1, 1348.00, 2525.00, -101.80, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000008, 253088, 1220, 7637, 7917, '0', 0, 0, 0, -1, 835.00, 2197.00, -85.40, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000009, 266285, 1220, 7637, 7970, '0', 0, 0, 0, -1, 603.62, 4016.00, 39.55, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000010, 266298, 1220, 7637, 8149, '0', 0, 0, 0, -1, 1388.00, 3386.17, 135.38, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000011, 266301, 1220, 7637, 8149, '0', 0, 0, 0, -1, 1283.83, 3174.67, 137.91, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256),
(990000000102000012, 266996, 1220, 7637, 8503, '0', 0, 0, 0, -1, 1400.00, 2950.00, 112.05, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0, -1, 256);
