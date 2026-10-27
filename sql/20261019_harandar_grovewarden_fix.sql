-- ============================================================================
-- 20261019_harandar_grovewarden_fix.sql
-- Fix: Har'mara Grovewarden (entry 248905) pri Dalnirom boli cerveni (hostile).
-- Pricina: world.creature_template.faction = 14 (generic hostile).
-- Retail (tdb1210_world, VerifiedBuild 69497): faction = 2299 (Har'mara, friendly).
-- Tiez obnovene 3 vymazane spawn-y (guid 11000748/49/50) podla TDB.
-- ============================================================================

-- 1) Oprava faction na retail-hodnotu 2299 (zeleni ally, nie cerveni enemy)
UPDATE world.creature_template SET faction = 2299 WHERE entry = 248905;

-- 2) Obnovenie 3 vymazanych spawn-ov pri Dalnirom (phase 26622) podla TDB
--    (guid 11000747 uz vo world existuje - nemenime; 11000748/49/50 vratit)
INSERT INTO world.creature
    (guid, id, map, zoneId, areaId, spawnDifficulties, phaseUseFlags, PhaseId, PhaseGroup,
     terrainSwapMap, modelid, equipment_id, position_x, position_y, position_z, orientation,
     spawntimesecs, wander_distance, currentwaypoint, curHealthPct, MovementType, npcflag,
     unit_flags, unit_flags2, unit_flags3, ScriptName, StringId, VerifiedBuild, size)
VALUES
    (11000748, 248905, 2694, 15355, 15928, 0, 0, 26622, 0, -1, 0, 1,
     1361.91, 912.993, 1346.7, 5.98576, 120, 0.0, 0, NULL, 0,
     0, 0, 0, 0, '', NULL, 66838, -1.0),
    (11000749, 248905, 2694, 15355, 15928, 0, 0, 26622, 0, -1, 0, 1,
     1355.35, 899.134, 1345.65, 3.17947, 120, 0.0, 0, NULL, 0,
     0, 0, 0, 0, '', NULL, 66838, -1.0),
    (11000750, 248905, 2694, 15355, 15928, 0, 0, 26622, 0, -1, 0, 1,
     1366.98, 907.606, 1346.4, 1.46516, 120, 0.0, 0, NULL, 0,
     0, 0, 0, 0, '', NULL, 66838, -1.0);
