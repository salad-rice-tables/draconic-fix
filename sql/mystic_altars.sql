-- =====================================================================
-- Mystic Altary a Hero Traineri: Mystic Enchanter (9900130) + oltar (9709999) a Hero Trainer
-- (9900131) v hostincoch hlavnych miest a 4 Mystic Altare z Descend v otvorenom svete.
-- Sluzby robi Lua (worldforge.lua / wildcard.lua). Undo: mystic_altars_undo.sql
-- =====================================================================
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_map`;
CREATE TEMPORARY TABLE `world`.`tmp_map` (`src` int unsigned, `dst` int unsigned, `nm` varchar(64), `sub` varchar(64), `fac` int unsigned, `flag` bigint unsigned);
INSERT INTO `world`.`tmp_map` VALUES
(33624, 9900130, 'Mystic Enchanter', 'Mystic Altar', 35, 1),
(9900100, 9900131, 'Hero Trainer', 'Classless & Wildcard', 35, 1),
(190399, 9900132, 'Bounty Master', 'Daily Bounties', 35, 1);
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT t.* FROM `world`.`creature_template` t JOIN `world`.`tmp_map` m ON m.src = t.entry;
UPDATE `world`.`tmp_ct` t JOIN `world`.`tmp_map` m ON m.src = t.entry
   SET t.entry = m.dst, t.name = m.nm, t.subname = m.sub, t.faction = m.fac, t.npcflag = m.flag, t.ScriptName = '', t.AIName = '', t.VerifiedBuild = 0;
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900130, 9900131, 9900132);
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900130, 9900131, 9900132);
INSERT INTO `world`.`creature_template_model`
SELECT m.dst, x.Idx, x.CreatureDisplayID, x.DisplayScale, x.Probability, 0
  FROM `world`.`creature_template_model` x JOIN `world`.`tmp_map` m ON m.src = x.CreatureID;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT d.* FROM `world`.`creature_template_difficulty` d JOIN `world`.`tmp_map` m ON m.src = d.Entry WHERE d.DifficultyID = 0;
UPDATE `world`.`tmp_cd` d JOIN `world`.`tmp_map` m ON m.src = d.Entry SET d.Entry = m.dst;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900130, 9900131, 9900132);
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 9709999;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9709999, 5, 227, 'Mystic Altar', '', '', '', 1.2, 0);
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002100001 AND 3002100100;
DELETE FROM `world`.`gameobject` WHERE `guid` BETWEEN 3100100001 AND 3100100100;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3002100001, 9900130, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1569.60, -4436.19, 16.14, 5.044, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100002, 9900131, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1574.33, -4434.56, 16.14, 5.044, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100003, 9900132, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1576.70, -4433.75, 16.14, 5.044, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100004, 9900130, 1136, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1578.59, -4461.81, 16.05, 5.116, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100005, 9900131, 1136, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1583.19, -4459.85, 16.05, 5.116, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100006, 9900132, 1136, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1585.49, -4458.87, 16.05, 5.116, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100007, 9900130, 2195, 0, 0, '0', 0, 0, 0, -1, 0, 0, 27.06, 40.26, 0.00, 4.718, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100008, 9900131, 2195, 0, 0, '0', 0, 0, 0, -1, 0, 0, 32.06, 40.29, 0.00, 4.718, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100009, 9900132, 2195, 0, 0, '0', 0, 0, 0, -1, 0, 0, 34.56, 40.30, 0.00, 4.718, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100010, 9900130, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -8863.70, 671.31, 97.99, 2.059, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100011, 9900131, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -8868.12, 668.97, 97.99, 2.059, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100012, 9900132, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -8870.33, 667.79, 97.99, 2.059, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100013, 9900130, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4837.58, -860.65, 502.00, 1.728, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100014, 9900131, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4842.51, -861.44, 502.00, 1.728, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100015, 9900132, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4844.98, -861.83, 502.00, 1.728, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100016, 9900130, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1298.21, 42.73, 129.29, 3.700, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100017, 9900131, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1295.56, 38.49, 129.29, 3.700, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100018, 9900132, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1294.24, 36.37, 129.29, 3.700, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100019, 9900130, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1630.84, 222.11, -43.02, 5.986, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100020, 9900131, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1632.31, 226.89, -43.02, 5.986, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100021, 9900132, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1633.04, 229.28, -43.02, 5.986, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100022, 9900130, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 10123.50, 2226.48, 1328.81, 5.358, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100023, 9900131, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 10127.49, 2229.49, 1328.81, 5.358, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100024, 9900132, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 10129.49, 2230.99, 1328.81, 5.358, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100025, 9900130, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 9685.64, -7368.06, 12.01, 1.344, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100026, 9900131, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 9680.76, -7366.94, 12.01, 1.344, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100027, 9900132, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 9678.33, -7366.37, 12.01, 1.344, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100028, 9900130, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3750.36, -11698.62, -105.87, 0.004, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100029, 9900131, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3750.38, -11693.62, -105.87, 0.004, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100030, 9900132, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3750.39, -11691.12, -105.87, 0.004, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100031, 9900130, 1624, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4095.63, -11429.56, -141.66, 2.442, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100032, 9900131, 1624, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4098.85, -11433.39, -141.66, 2.442, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100033, 9900132, 1624, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4100.46, -11435.30, -141.66, 2.442, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100034, 9900130, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2185.10, 5404.22, 51.97, 4.381, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100035, 9900131, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2180.37, 5402.59, 51.97, 4.381, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100036, 9900132, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2178.01, 5401.77, 51.97, 4.381, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100037, 9900130, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5847.80, 640.15, 647.57, 4.189, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100038, 9900131, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5852.14, 637.65, 647.57, 4.189, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100039, 9900132, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5854.30, 636.40, 647.57, 4.189, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100040, 9900130, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -801.02, 4467.32, 735.10, 3.557, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100041, 9900131, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -799.00, 4462.75, 735.10, 3.557, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100042, 9900132, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -797.99, 4460.46, 735.10, 3.557, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100043, 9900130, 2731, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2283.07, -1464.66, 2033.33, 2.460, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100044, 9900131, 2731, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2279.92, -1468.54, 2033.33, 2.460, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100045, 9900132, 2731, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2278.35, -1470.48, 2033.33, 2.460, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100046, 9900130, 2444, 0, 0, '0', 0, 0, 0, -1, 0, 0, 197.62, -889.78, 843.14, 6.131, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100047, 9900131, 2444, 0, 0, '0', 0, 0, 0, -1, 0, 0, 198.38, -884.83, 843.14, 6.131, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100048, 9900132, 2444, 0, 0, '0', 0, 0, 0, -1, 0, 0, 198.76, -882.36, 843.14, 6.131, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100049, 9900130, 2552, 0, 0, '0', 0, 0, 0, -1, 0, 0, 912.04, -1918.15, 75.45, 4.683, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100050, 9900131, 2552, 0, 0, '0', 0, 0, 0, -1, 0, 0, 917.04, -1918.30, 75.45, 4.683, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100051, 9900132, 2552, 0, 0, '0', 0, 0, 0, -1, 0, 0, 919.54, -1918.37, 75.45, 4.683, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100052, 9900130, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 4009.24, -4755.07, 304.87, 3.142, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100053, 9900130, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -6366.05, 1161.61, 5.39, 3.142, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002100054, 9900130, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 79.44, 343.44, 42.26, 3.142, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);
INSERT INTO `world`.`gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `VerifiedBuild`) VALUES
(3100100001, 9709999, 1, 0, 0, '0', 0, 0, 0, -1, 1567.90, -4436.78, 16.14, 1.902, 0, 0, 0.81412, 0.58070, 300, 255, 1, 0),
(3100100002, 9709999, 1136, 0, 0, '0', 0, 0, 0, -1, 1576.93, -4462.52, 16.05, 1.974, 0, 0, 0.83446, 0.55107, 300, 255, 1, 0),
(3100100003, 9709999, 2195, 0, 0, '0', 0, 0, 0, -1, 25.26, 40.25, 0.00, 1.576, 0, 0, 0.70894, 0.70527, 300, 255, 1, 0),
(3100100004, 9709999, 0, 0, 0, '0', 0, 0, 0, -1, -8862.12, 672.16, 97.99, 5.201, 0, 0, 0.51504, -0.85717, 300, 255, 1, 0),
(3100100005, 9709999, 0, 0, 0, '0', 0, 0, 0, -1, -4835.80, -860.37, 502.00, 4.869, 0, 0, 0.64945, -0.76041, 300, 255, 1, 0),
(3100100006, 9709999, 1, 0, 0, '0', 0, 0, 0, -1, -1299.17, 44.25, 129.29, 0.559, 0, 0, 0.27564, 0.96126, 300, 255, 1, 0),
(3100100007, 9709999, 0, 0, 0, '0', 0, 0, 0, -1, 1630.32, 220.39, -43.02, 2.845, 0, 0, 0.98902, 0.14781, 300, 255, 1, 0),
(3100100008, 9709999, 1, 0, 0, '0', 0, 0, 0, -1, 10122.06, 2225.40, 1328.81, 2.217, 0, 0, 0.89493, 0.44620, 300, 255, 1, 0),
(3100100009, 9709999, 530, 0, 0, '0', 0, 0, 0, -1, 9687.39, -7368.46, 12.01, 4.486, 0, 0, 0.78261, -0.62252, 300, 255, 1, 0),
(3100100010, 9709999, 530, 0, 0, '0', 0, 0, 0, -1, -3750.35, -11700.42, -105.87, 3.146, 0, 0, 1.00000, -0.00209, 300, 255, 1, 0),
(3100100011, 9709999, 1624, 0, 0, '0', 0, 0, 0, -1, -4094.47, -11428.18, -141.66, 5.584, 0, 0, 0.34255, -0.93950, 300, 255, 1, 0),
(3100100012, 9709999, 530, 0, 0, '0', 0, 0, 0, -1, -2186.80, 5404.80, 51.97, 1.239, 0, 0, 0.58070, 0.81412, 300, 255, 1, 0),
(3100100013, 9709999, 571, 0, 0, '0', 0, 0, 0, -1, 5846.25, 641.05, 647.57, 1.047, 0, 0, 0.50000, 0.86602, 300, 255, 1, 0),
(3100100014, 9709999, 1220, 0, 0, '0', 0, 0, 0, -1, -801.74, 4468.97, 735.10, 0.416, 0, 0, 0.20634, 0.97848, 300, 255, 1, 0),
(3100100015, 9709999, 2731, 0, 0, '0', 0, 0, 0, -1, 2284.21, -1463.26, 2033.33, 5.602, 0, 0, 0.33414, -0.94252, 300, 255, 1, 0),
(3100100016, 9709999, 2444, 0, 0, '0', 0, 0, 0, -1, 197.35, -891.56, 843.14, 2.989, 0, 0, 0.99711, 0.07600, 300, 255, 1, 0),
(3100100017, 9709999, 2552, 0, 0, '0', 0, 0, 0, -1, 910.24, -1918.10, 75.45, 1.541, 0, 0, 0.69661, 0.71745, 300, 255, 1, 0),
(3100100018, 9709999, 1, 0, 0, '0', 0, 0, 0, -1, 4009.24, -4753.27, 304.87, 0.000, 0, 0, 0.00000, 1.00000, 300, 255, 1, 0),
(3100100019, 9709999, 1, 0, 0, '0', 0, 0, 0, -1, -6366.05, 1163.41, 5.39, 0.000, 0, 0, 0.00000, 1.00000, 300, 255, 1, 0),
(3100100020, 9709999, 0, 0, 0, '0', 0, 0, 0, -1, 79.44, 345.24, 42.26, 0.000, 0, 0, 0.00000, 1.00000, 300, 255, 1, 0);
CREATE TABLE IF NOT EXISTS `characters`.`mystic_runes` (
  `name` varchar(12) NOT NULL, `runes` int unsigned NOT NULL DEFAULT 0, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `characters`.`mystic_rune_claim` (
  `name` varchar(12) NOT NULL, `spawn` varchar(24) NOT NULL, PRIMARY KEY (`name`, `spawn`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
