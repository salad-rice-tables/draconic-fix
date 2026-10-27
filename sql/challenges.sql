-- =====================================================================
-- Ascension Challenges (lua/challenges.lua): Challenge Master (9900133) in starting
-- areas and capital inns, challenge titles (CharTitles 1400-1406,
-- hotfix push 1900150), table characters.hero_challenge. Undo: challenges_undo.sql
-- =====================================================================
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 33563;
UPDATE `world`.`tmp_ct` SET `entry` = 9900133, `name` = 'Challenge Master', `subname` = 'Hero Challenges', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900133;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
DROP TEMPORARY TABLE `world`.`tmp_ct`;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900133;
INSERT INTO `world`.`creature_template_model` SELECT 9900133, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 33563;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 33563 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900133;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900133;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE `world`.`tmp_cd`;
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002200001 AND 3002200100;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3002200001, 9900133, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -615.69, -4254.78, 39.04, 6.196, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200002, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -8916.16, -138.76, 80.89, 5.130, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200003, 9900133, 2512, 0, 0, '0', 0, 0, 0, -1, 0, 0, 16151.26, 15326.29, 81.70, 5.129, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200004, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -6241.57, 349.99, 383.88, 3.661, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200005, 9900133, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3018.21, -462.15, 45.42, 4.171, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200006, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1688.68, 1677.61, 135.68, 3.491, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200007, 9900133, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 10349.38, -6361.38, 34.11, 5.219, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200008, 9900133, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3958.75, -13927.42, 100.97, 1.396, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200009, 9900133, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1567.24, -4437.01, 16.14, 5.044, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200010, 9900133, 1136, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1576.29, -4462.79, 16.05, 5.116, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200011, 9900133, 2195, 0, 0, '0', 0, 0, 0, -1, 0, 0, 24.56, 40.25, 0.00, 4.718, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200012, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -8861.50, 672.49, 97.99, 2.059, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200013, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4835.11, -860.26, 502.00, 1.728, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200014, 9900133, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1299.54, 44.85, 129.29, 3.700, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200015, 9900133, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1630.11, 219.72, -43.02, 5.986, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200016, 9900133, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 10121.50, 2224.98, 1328.81, 5.358, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200017, 9900133, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 9688.07, -7368.62, 12.01, 1.344, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200018, 9900133, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3750.35, -11701.12, -105.87, 0.004, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200019, 9900133, 1624, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4094.02, -11427.65, -141.66, 2.442, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200020, 9900133, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2187.47, 5405.03, 51.97, 4.381, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200021, 9900133, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5845.64, 641.40, 647.57, 4.189, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200022, 9900133, 1220, 0, 0, '0', 0, 0, 0, -1, 0, 0, -802.03, 4469.61, 735.10, 3.557, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200023, 9900133, 2731, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2284.65, -1462.72, 2033.33, 2.460, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200024, 9900133, 2444, 0, 0, '0', 0, 0, 0, -1, 0, 0, 197.25, -892.25, 843.14, 6.131, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002200025, 9900133, 2552, 0, 0, '0', 0, 0, 0, -1, 0, 0, 909.54, -1918.07, 75.45, 4.683, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900150;
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` BETWEEN 1400 AND 1406;
INSERT INTO `hotfixes`.`char_titles` (`ID`, `Name`, `Name1`, `MaskID`, `Flags`, `VerifiedBuild`) VALUES
(1400, '%s the Deathless', '%s the Deathless', 900, 0, 69933),
(1401, 'Ironman %s', 'Ironman %s', 901, 0, 69933),
(1402, '%s the Exile', '%s the Exile', 902, 0, 69933),
(1403, '%s the Lone Wolf', '%s the Lone Wolf', 903, 0, 69933),
(1404, '%s the Self-Made', '%s the Self-Made', 904, 0, 69933),
(1405, '%s the Steadfast', '%s the Steadfast', 905, 0, 69933),
(1406, '%s, Ascended', '%s, Ascended', 906, 0, 69933);
INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(1900150, 4100015000, 2246024846, 1400, 1, 69933),
(1900150, 4100015001, 2246024846, 1401, 1, 69933),
(1900150, 4100015002, 2246024846, 1402, 1, 69933),
(1900150, 4100015003, 2246024846, 1403, 1, 69933),
(1900150, 4100015004, 2246024846, 1404, 1, 69933),
(1900150, 4100015005, 2246024846, 1405, 1, 69933),
(1900150, 4100015006, 2246024846, 1406, 1, 69933);
CREATE TABLE IF NOT EXISTS `characters`.`hero_challenge` (
  `name` varchar(12) NOT NULL, `mode` varchar(12) NOT NULL, `status` tinyint unsigned NOT NULL DEFAULT 0,
  `reward_level` tinyint unsigned NOT NULL DEFAULT 0, `started` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`, `mode`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
