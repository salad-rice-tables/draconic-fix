-- =====================================================================
-- Warden campaign mob density: more spawns + 40s respawn (was 120s).
-- 95125 Pineshadow Turncloaks MOVED to Jadefire Run (satyr-sworn belong
-- with satyrs); POI for 95004 follows them. 95002 gains a second cluster
-- in Strigid grounds (POI extended).
-- Idempotent. Needs restart (spawns) + quest POI reload.
-- =====================================================================

-- Faster respawn for all campaign mobs (old + new)
UPDATE `world`.`creature` SET `spawntimesecs` = 40 WHERE `guid` BETWEEN 3001000736 AND 3001000790;

-- --- Extra Dolanaar spawns (offsets of verified ground) ---
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000761 AND 3001000790;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
-- Duskwatch Renegade +4
(3001000761, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10610.0, 640.0, 1329.7, 2.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000762, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10660.0, 690.0, 1329.3, 4.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000763, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10690.0, 855.0, 1322.0, 1.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000764, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10625.0, 940.0, 1320.2, 3.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Shadowfen Betrayer +4
(3001000765, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10540.0, 1070.0, 1321.4, 1.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000766, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10500.0, 1070.0, 1326.1, 2.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000767, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10490.0, 1072.0, 1327.5, 4.2, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000768, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10525.0, 1055.0, 1323.0, 0.4, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Talonbreaker Renegade +4 (Strigid grounds, north Teldrassil)
(3001000769, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9717.7, 1852.6, 1302.0, 1.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000770, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9695.7, 1819.7, 1295.5, 3.1, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000771, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9618.4, 1812.2, 1295.1, 5.3, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000772, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9548.2, 1681.2, 1294.6, 2.6, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Ashenfall Betrayer +4 (den offsets)
(3001000773, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3445.3, -359.0, 134.0, 1.4, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000774, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3433.3, -371.0, 134.0, 3.9, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000775, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3406.7, -456.5, 160.0, 0.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000776, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3402.6, -322.1, 134.0, 5.6, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Felbriar Warden +3 (den offsets)
(3001000777, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3455.0, -362.0, 134.0, 2.1, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000778, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3428.0, -366.0, 134.0, 4.6, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000779, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3448.0, -376.0, 134.0, 1.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Pineshadow Turncloak RELOCATED to Jadefire Run (delete den ones) ---
DELETE FROM `world`.`creature` WHERE `guid` IN (3001000752, 3001000753, 3001000754, 3001000755);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000780, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3746.8, -877.7, 321.0, 1.3, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000781, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3755.1, -838.0, 309.9, 2.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000782, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3796.5, -769.3, 317.6, 0.2, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000783, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3801.8, -784.5, 311.8, 4.1, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000784, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3807.7, -691.1, 344.5, 1.8, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000785, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3846.6, -747.8, 316.0, 3.6, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- POI follows the moves ---
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` = 95002;
INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95002, 0, 0, 9800, 983, 1314, 0),
(95002, 1, 0, 10426.0, 546.9, 1333.5, 0),
(95002, 1, 1, 10432.0, 551.0, 1333.5, 0),
(95002, 1, 2, 10420.0, 542.5, 1333.5, 0),
(95002, 1, 3, 10436.0, 540.0, 1333.5, 0),
(95002, 1, 4, 9717.7, 1852.6, 1302.0, 0),
(95002, 1, 5, 9695.7, 1819.7, 1295.5, 0),
(95002, 1, 6, 9618.4, 1812.2, 1295.1, 0),
(95002, 1, 7, 9548.2, 1681.2, 1294.6, 0);

DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` = 95004;
INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95004, 0, 0, 3800, -780, 320, 0),
(95004, 1, 0, 3746.8, -877.7, 321.0, 0),
(95004, 1, 1, 3755.1, -838.0, 309.9, 0),
(95004, 1, 2, 3796.5, -769.3, 317.6, 0),
(95004, 1, 3, 3801.8, -784.5, 311.8, 0),
(95004, 1, 4, 3807.7, -691.1, 344.5, 0),
(95004, 1, 5, 3846.6, -747.8, 316.0, 0);

-- Quest text nudge: turncloaks now run with the Jadefire satyrs
UPDATE `world`.`quest_template` SET
`LogDescription` = 'Kill 8 Pineshadow Turncloaks running with the Jadefire satyrs in Ashenvale for Warden Velarys.',
`QuestDescription` = 'You saw truly - the betrayers feed our movements to the Jadefire satyrs, and the Pineshadow Turncloaks walk openly among them where loyal blades cannot follow. They believe no blade can reach them unseen.$b$bProve them wrong. Hunt them through Jadefire Run and leave eight corpses. Do it without ever being seen first, and I will teach you to wear shadow as a cloak.'
WHERE `ID` = 95004;
