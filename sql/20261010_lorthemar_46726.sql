-- Rising Storm 92061 turn-in fix: Lor'themar 235787 chyba vo faze 46726 (hracom overene: na bode stoji Orweyna 253640).
-- Faza 46726 = Silvermoon City (phase_area 15969), bez mena v phase_name. Retail spawn 3000207578 je len vo faze 45584.
-- Aditivny custom spawn (kopie 3000207578, len guid + PhaseId ine). Retail riadky nemenene.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
INSERT IGNORE INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001104, 235787, 0, 15969, 0, '0', 0, 46726, 0, -1, 0, 1, 8456.51, -4621.58, 48.258, 4.59103, 300, 0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1);
