-- =====================================================================
-- Living World: Sen'jin Village ozije + trasa 1 predlzena Razor Hill -> Sen'jin
-- (kotviace body = braziers pozdlz cesty 62..-695). Faza 9600.
-- Spawny 3001000981-991: 9 trolov (9900121), 2 robotnici (9900122).
-- Undo: lw_senjin_undo.sql (vrati trasu 1 po Razor Hill: spusti lw_routes_durotar.sql)
-- =====================================================================
DELETE FROM `world`.`lw_route_node` WHERE `route` = 1;
INSERT INTO `world`.`lw_route_node` (`route`, `idx`, `map`, `x`, `y`, `z`, `stop`, `wait_s`) VALUES
(1, 1, 1, 1375.00, -4445.00, 33.00, 'Orgrimmar', 60),
(1, 2, 1, 1339.70, -4456.35, 29.20, NULL, 0),
(1, 3, 1, 1304.40, -4467.70, 25.40, NULL, 0),
(1, 4, 1, 1260.00, -4483.45, 23.80, NULL, 0),
(1, 5, 1, 1215.60, -4499.20, 22.20, NULL, 0),
(1, 6, 1, 1178.44, -4504.68, 20.64, NULL, 0),
(1, 7, 1, 1141.27, -4510.16, 19.07, NULL, 0),
(1, 8, 1, 1104.11, -4515.65, 17.51, NULL, 0),
(1, 9, 1, 1066.95, -4521.13, 15.95, NULL, 0),
(1, 10, 1, 1029.78, -4526.61, 14.38, NULL, 0),
(1, 11, 1, 992.62, -4532.09, 12.82, NULL, 0),
(1, 12, 1, 955.45, -4537.57, 11.25, NULL, 0),
(1, 13, 1, 918.29, -4543.05, 9.69, NULL, 0),
(1, 14, 1, 881.13, -4548.54, 8.13, NULL, 0),
(1, 15, 1, 843.96, -4554.02, 6.56, NULL, 0),
(1, 16, 1, 806.80, -4559.50, 5.00, NULL, 0),
(1, 17, 1, 784.08, -4587.55, 2.47, NULL, 0),
(1, 18, 1, 761.37, -4615.60, -0.07, NULL, 0),
(1, 19, 1, 738.65, -4643.65, -2.60, NULL, 0),
(1, 20, 1, 715.93, -4671.70, -5.13, NULL, 0),
(1, 21, 1, 693.22, -4699.75, -7.67, NULL, 0),
(1, 22, 1, 670.50, -4727.80, -10.20, NULL, 0),
(1, 23, 1, 630.10, -4726.27, -7.35, NULL, 0),
(1, 24, 1, 589.70, -4724.75, -4.50, NULL, 0),
(1, 25, 1, 549.30, -4723.23, -1.65, NULL, 0),
(1, 26, 1, 508.90, -4721.70, 1.20, NULL, 0),
(1, 27, 1, 473.12, -4720.96, 3.36, NULL, 0),
(1, 28, 1, 437.34, -4720.22, 5.52, NULL, 0),
(1, 29, 1, 401.56, -4719.48, 7.68, NULL, 0),
(1, 30, 1, 365.78, -4718.74, 9.84, NULL, 0),
(1, 31, 1, 330.00, -4718.00, 12.00, 'Razor Hill', 60),
(1, 32, 1, 316.00, -4769.00, 11.00, NULL, 0),
(1, 33, 1, 279.71, -4766.57, 12.57, NULL, 0),
(1, 34, 1, 243.43, -4764.14, 14.14, NULL, 0),
(1, 35, 1, 207.14, -4761.71, 15.71, NULL, 0),
(1, 36, 1, 170.86, -4759.29, 17.29, NULL, 0),
(1, 37, 1, 134.57, -4756.86, 18.86, NULL, 0),
(1, 38, 1, 98.29, -4754.43, 20.43, NULL, 0),
(1, 39, 1, 62.00, -4752.00, 22.00, NULL, 0),
(1, 40, 1, 24.75, -4753.00, 21.75, NULL, 0),
(1, 41, 1, -12.50, -4754.00, 21.50, NULL, 0),
(1, 42, 1, -49.75, -4755.00, 21.25, NULL, 0),
(1, 43, 1, -87.00, -4756.00, 21.00, NULL, 0),
(1, 44, 1, -124.00, -4760.25, 22.50, NULL, 0),
(1, 45, 1, -161.00, -4764.50, 24.00, NULL, 0),
(1, 46, 1, -198.00, -4768.75, 25.50, NULL, 0),
(1, 47, 1, -235.00, -4773.00, 27.00, NULL, 0),
(1, 48, 1, -274.75, -4783.50, 29.50, NULL, 0),
(1, 49, 1, -314.50, -4794.00, 32.00, NULL, 0),
(1, 50, 1, -354.25, -4804.50, 34.50, NULL, 0),
(1, 51, 1, -394.00, -4815.00, 37.00, NULL, 0),
(1, 52, 1, -427.00, -4796.00, 36.50, NULL, 0),
(1, 53, 1, -460.00, -4777.00, 36.00, NULL, 0),
(1, 54, 1, -493.00, -4758.00, 35.50, NULL, 0),
(1, 55, 1, -526.00, -4739.00, 35.00, NULL, 0),
(1, 56, 1, -570.00, -4728.50, 35.00, NULL, 0),
(1, 57, 1, -614.00, -4718.00, 35.00, NULL, 0),
(1, 58, 1, -654.50, -4742.50, 34.50, NULL, 0),
(1, 59, 1, -695.00, -4767.00, 34.00, NULL, 0),
(1, 60, 1, -721.25, -4799.00, 30.50, NULL, 0),
(1, 61, 1, -747.50, -4831.00, 27.00, NULL, 0),
(1, 62, 1, -773.75, -4863.00, 23.50, NULL, 0),
(1, 63, 1, -800.00, -4895.00, 20.00, 'Sen''jin Village', 60);

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_spot`;
CREATE TEMPORARY TABLE `world`.`tmp_spot` (`n` int, `x` float, `y` float, `z` float, `o` float)
SELECT ROW_NUMBER() OVER (ORDER BY c.guid) AS n, c.position_x + 2.5 AS x, c.position_y + 2 AS y, c.position_z AS z, c.orientation AS o
  FROM `world`.`creature` c JOIN `world`.`creature_template` t ON t.entry = c.id
 WHERE c.map = 1 AND c.areaId = 367 AND t.type = 7 AND c.id <> 3297 AND c.position_z < 30
   AND c.PhaseId IN (0, 169) AND c.PhaseGroup = 0
 ORDER BY c.guid LIMIT 11;

DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000981 AND 3001000991;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`)
SELECT 3001000980 + s.n, CASE WHEN s.n <= 9 THEN 9900121 ELSE 9900122 END,
       1, 14, 367, '0', 0, 9600, 0, -1, 0, 0, s.x, s.y, s.z, s.o, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1
  FROM `world`.`tmp_spot` s;
DROP TEMPORARY TABLE `world`.`tmp_spot`;
SELECT route, COUNT(*) nodes, SUM(stop IS NOT NULL) stops FROM `world`.`lw_route_node` WHERE route = 1;
SELECT id, COUNT(*) FROM `world`.`creature` WHERE guid BETWEEN 3001000981 AND 3001000991 GROUP BY id;
