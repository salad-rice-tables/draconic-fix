-- =====================================================================
-- Living world v4 roads: 33 caravan routes (lw_route_node route 100-132) between
-- villages on Eastern Kingdoms, Kalimdor, Outland and Northrend, each with a neutral
-- Steamwheedle caravan (9900300+) and a road patrol (9900400+). Kodo 9900299.
-- Spawns creature guid 3002400001-3002400066. Undo: living_roads_undo.sql
-- =====================================================================
DELETE FROM `world`.`lw_route_node` WHERE `route` BETWEEN 100 AND 599;
DELETE FROM `world`.`lw_caravan` WHERE `route` BETWEEN 100 AND 599;
DELETE FROM `world`.`lw_patrol` WHERE `id` BETWEEN 100 AND 599;
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002400001 AND 3002401000;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_map`;
CREATE TEMPORARY TABLE `world`.`tmp_map` (`src` int unsigned, `dst` int unsigned, `nm` varchar(64), `sub` varchar(64), `fac` int unsigned);
INSERT INTO `world`.`tmp_map` VALUES (9900111, 9900299, 'Caravan Kodo', NULL, 35),
(93158, 9900300, 'Steamwheedle Caravaneer', 'The Salty Sailor Tavern - Fort Livingston', 35),
(93158, 9900400, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900301, 'Steamwheedle Caravaneer', 'Nethergarde Keep - Dreadmaul Hold', 35),
(93158, 9900401, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900302, 'Steamwheedle Caravaneer', 'Iron Summit - Fuselight-by-the-Sea', 35),
(93158, 9900402, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900303, 'Steamwheedle Caravaneer', 'The Farstrider Lodge - Thundermar', 35),
(1423, 9900403, 'Road Sergeant', 'Road Patrol', 0),
(93158, 9900304, 'Steamwheedle Caravaneer', 'Highbank - The Krazzworks', 35),
(93158, 9900404, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900305, 'Steamwheedle Caravaneer', 'Deepwater Tavern - Greenwarden''s Grove', 35),
(1423, 9900405, 'Road Sergeant', 'Road Patrol', 0),
(93158, 9900306, 'Steamwheedle Caravaneer', 'Revantusk Village - Chillwind Camp', 35),
(93158, 9900406, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900307, 'Steamwheedle Caravaneer', 'The Sepulcher - Forsaken Rear Guard', 35),
(9900115, 9900407, 'Road Warden', 'Road Patrol', 0),
(93158, 9900308, 'Steamwheedle Caravaneer', 'Andorhal - Brill', 35),
(93158, 9900408, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900309, 'Steamwheedle Caravaneer', 'The Road Warrior - Speedbarge Bar', 35),
(93158, 9900409, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900310, 'Steamwheedle Caravaneer', 'Freewind Post - Desolation Hold', 35),
(9900115, 9900410, 'Road Warden', 'Road Patrol', 0),
(93158, 9900311, 'Steamwheedle Caravaneer', 'Stonemaul Hold - Camp Ataya', 35),
(93158, 9900411, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900312, 'Steamwheedle Caravaneer', 'Northwatch Hold - Splintertree Post', 35),
(93158, 9900412, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900313, 'Steamwheedle Caravaneer', 'Camp Una''fe - Krom''gar Fortress', 35),
(93158, 9900413, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900314, 'Steamwheedle Caravaneer', 'Karnum''s Glade - Thal''darah Overlook', 35),
(9900115, 9900414, 'Road Warden', 'Road Patrol', 0),
(93158, 9900315, 'Steamwheedle Caravaneer', 'Silverwind Refuge - Hellscream''s Watch', 35),
(9900115, 9900415, 'Road Warden', 'Road Patrol', 0),
(93158, 9900316, 'Steamwheedle Caravaneer', 'Wildheart Point - Talonbranch Glade ', 35),
(93158, 9900416, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900317, 'Steamwheedle Caravaneer', 'Dragonmaw Base Camp - Allerian Stronghold', 35),
(93158, 9900417, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900318, 'Steamwheedle Caravaneer', 'Honor Hold - Thrallmar', 35),
(93158, 9900418, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900319, 'Steamwheedle Caravaneer', 'Falcon Watch - Orebor Harborage', 35),
(93158, 9900419, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900320, 'Steamwheedle Caravaneer', 'Toshley''s Station - Rusty Rocket Tavern', 35),
(93158, 9900420, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900321, 'Steamwheedle Caravaneer', 'Hatchet Hills - Falconwing Inn', 35),
(9900115, 9900421, 'Road Warden', 'Road Patrol', 0),
(93158, 9900322, 'Steamwheedle Caravaneer', 'New Agamand - Valgarde', 35),
(93158, 9900422, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900323, 'Steamwheedle Caravaneer', 'Kamagua - Westguard Inn', 35),
(93158, 9900423, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900324, 'Steamwheedle Caravaneer', 'Vengeance Landing Inn - Westfall Brigade Encampment', 35),
(93158, 9900424, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900325, 'Steamwheedle Caravaneer', 'Valiant Rest - Warsong Hold', 35),
(93158, 9900425, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900326, 'Steamwheedle Caravaneer', 'Moa''ki Harbor - Venomspite', 35),
(93158, 9900426, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900327, 'Steamwheedle Caravaneer', 'Unu''pe - Nesingwary Base Camp', 35),
(93158, 9900427, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900328, 'Steamwheedle Caravaneer', 'Conquest Hold - Amberpine Lodge', 35),
(93158, 9900428, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900329, 'Steamwheedle Caravaneer', 'Stars'' Rest - Agmar''s Hammer', 35),
(93158, 9900429, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900330, 'Steamwheedle Caravaneer', 'The Argent Stand - Zim''Torga', 35),
(93158, 9900430, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900331, 'Steamwheedle Caravaneer', 'K3 - Bouldercrag''s Refuge', 35),
(93158, 9900431, 'Bruiser Captain', 'Road Patrol', 0),
(93158, 9900332, 'Steamwheedle Caravaneer', 'Brunnhildar Village - Camp Tunka''lo', 35),
(93158, 9900432, 'Bruiser Captain', 'Road Patrol', 0);
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT t.*, m.dst AS new_entry FROM `world`.`creature_template` t JOIN `world`.`tmp_map` m ON m.src = t.entry;

DELETE FROM `world`.`creature_template` WHERE `entry` IN (SELECT `dst` FROM `world`.`tmp_map`);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (SELECT `dst` FROM `world`.`tmp_map`);
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (SELECT `dst` FROM `world`.`tmp_map`);
DROP TEMPORARY TABLE `world`.`tmp_ct`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900111;
UPDATE `world`.`tmp_ct` SET `entry` = 9900299, `name` = 'Caravan Kodo', `subname` = NULL, `faction` = 35, `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900299, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900111;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900111 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900299;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900300, `name` = 'Steamwheedle Caravaneer', `subname` = 'The Salty Sailor Tavern - Fort Livingston', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900300, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900300;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900400, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900400, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900400;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900301, `name` = 'Steamwheedle Caravaneer', `subname` = 'Nethergarde Keep - Dreadmaul Hold', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900301, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900301;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900401, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900401, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900401;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900302, `name` = 'Steamwheedle Caravaneer', `subname` = 'Iron Summit - Fuselight-by-the-Sea', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900302, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900302;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900402, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900402, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900402;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900303, `name` = 'Steamwheedle Caravaneer', `subname` = 'The Farstrider Lodge - Thundermar', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900303, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900303;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 1423;
UPDATE `world`.`tmp_ct` SET `entry` = 9900403, `name` = 'Road Sergeant', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900403, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 1423;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 1423 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900403;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900304, `name` = 'Steamwheedle Caravaneer', `subname` = 'Highbank - The Krazzworks', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900304, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900304;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900404, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900404, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900404;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900305, `name` = 'Steamwheedle Caravaneer', `subname` = 'Deepwater Tavern - Greenwarden''s Grove', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900305, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900305;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 1423;
UPDATE `world`.`tmp_ct` SET `entry` = 9900405, `name` = 'Road Sergeant', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900405, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 1423;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 1423 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900405;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900306, `name` = 'Steamwheedle Caravaneer', `subname` = 'Revantusk Village - Chillwind Camp', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900306, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900306;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900406, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900406, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900406;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900307, `name` = 'Steamwheedle Caravaneer', `subname` = 'The Sepulcher - Forsaken Rear Guard', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900307, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900307;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900115;
UPDATE `world`.`tmp_ct` SET `entry` = 9900407, `name` = 'Road Warden', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900407, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900115;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900115 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900407;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900308, `name` = 'Steamwheedle Caravaneer', `subname` = 'Andorhal - Brill', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900308, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900308;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900408, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900408, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900408;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900309, `name` = 'Steamwheedle Caravaneer', `subname` = 'The Road Warrior - Speedbarge Bar', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900309, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900309;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900409, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900409, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900409;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900310, `name` = 'Steamwheedle Caravaneer', `subname` = 'Freewind Post - Desolation Hold', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900310, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900310;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900115;
UPDATE `world`.`tmp_ct` SET `entry` = 9900410, `name` = 'Road Warden', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900410, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900115;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900115 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900410;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900311, `name` = 'Steamwheedle Caravaneer', `subname` = 'Stonemaul Hold - Camp Ataya', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900311, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900311;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900411, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900411, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900411;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900312, `name` = 'Steamwheedle Caravaneer', `subname` = 'Northwatch Hold - Splintertree Post', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900312, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900312;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900412, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900412, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900412;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900313, `name` = 'Steamwheedle Caravaneer', `subname` = 'Camp Una''fe - Krom''gar Fortress', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900313, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900313;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900413, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900413, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900413;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900314, `name` = 'Steamwheedle Caravaneer', `subname` = 'Karnum''s Glade - Thal''darah Overlook', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900314, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900314;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900115;
UPDATE `world`.`tmp_ct` SET `entry` = 9900414, `name` = 'Road Warden', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900414, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900115;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900115 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900414;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900315, `name` = 'Steamwheedle Caravaneer', `subname` = 'Silverwind Refuge - Hellscream''s Watch', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900315, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900315;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900115;
UPDATE `world`.`tmp_ct` SET `entry` = 9900415, `name` = 'Road Warden', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900415, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900115;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900115 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900415;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900316, `name` = 'Steamwheedle Caravaneer', `subname` = 'Wildheart Point - Talonbranch Glade ', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900316, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900316;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900416, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900416, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900416;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900317, `name` = 'Steamwheedle Caravaneer', `subname` = 'Dragonmaw Base Camp - Allerian Stronghold', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900317, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900317;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900417, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900417, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900417;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900318, `name` = 'Steamwheedle Caravaneer', `subname` = 'Honor Hold - Thrallmar', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900318, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900318;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900418, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900418, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900418;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900319, `name` = 'Steamwheedle Caravaneer', `subname` = 'Falcon Watch - Orebor Harborage', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900319, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900319;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900419, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900419, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900419;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900320, `name` = 'Steamwheedle Caravaneer', `subname` = 'Toshley''s Station - Rusty Rocket Tavern', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900320, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900320;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900420, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900420, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900420;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900321, `name` = 'Steamwheedle Caravaneer', `subname` = 'Hatchet Hills - Falconwing Inn', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900321, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900321;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 9900115;
UPDATE `world`.`tmp_ct` SET `entry` = 9900421, `name` = 'Road Warden', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900421, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 9900115;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 9900115 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900421;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900322, `name` = 'Steamwheedle Caravaneer', `subname` = 'New Agamand - Valgarde', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900322, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900322;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900422, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900422, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900422;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900323, `name` = 'Steamwheedle Caravaneer', `subname` = 'Kamagua - Westguard Inn', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900323, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900323;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900423, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900423, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900423;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900324, `name` = 'Steamwheedle Caravaneer', `subname` = 'Vengeance Landing Inn - Westfall Brigade Encampment', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900324, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900324;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900424, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900424, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900424;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900325, `name` = 'Steamwheedle Caravaneer', `subname` = 'Valiant Rest - Warsong Hold', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900325, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900325;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900425, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900425, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900425;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900326, `name` = 'Steamwheedle Caravaneer', `subname` = 'Moa''ki Harbor - Venomspite', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900326, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900326;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900426, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900426, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900426;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900327, `name` = 'Steamwheedle Caravaneer', `subname` = 'Unu''pe - Nesingwary Base Camp', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900327, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900327;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900427, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900427, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900427;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900328, `name` = 'Steamwheedle Caravaneer', `subname` = 'Conquest Hold - Amberpine Lodge', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900328, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900328;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900428, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900428, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900428;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900329, `name` = 'Steamwheedle Caravaneer', `subname` = 'Stars'' Rest - Agmar''s Hammer', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900329, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900329;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900429, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900429, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900429;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900330, `name` = 'Steamwheedle Caravaneer', `subname` = 'The Argent Stand - Zim''Torga', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900330, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900330;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900430, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900430, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900430;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900331, `name` = 'Steamwheedle Caravaneer', `subname` = 'K3 - Bouldercrag''s Refuge', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900331, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900331;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900431, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900431, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900431;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900332, `name` = 'Steamwheedle Caravaneer', `subname` = 'Brunnhildar Village - Camp Tunka''lo', `faction` = 35, `npcflag` = 1, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900332, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900332;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_ct`;
CREATE TEMPORARY TABLE `world`.`tmp_ct` SELECT * FROM `world`.`creature_template` WHERE `entry` = 93158;
UPDATE `world`.`tmp_ct` SET `entry` = 9900432, `name` = 'Bruiser Captain', `subname` = 'Road Patrol', `npcflag` = 0, `ScriptName` = '', `AIName` = '', `VerifiedBuild` = 0;
INSERT INTO `world`.`creature_template` SELECT * FROM `world`.`tmp_ct`;
INSERT INTO `world`.`creature_template_model` SELECT 9900432, Idx, CreatureDisplayID, DisplayScale, Probability, 0 FROM `world`.`creature_template_model` WHERE CreatureID = 93158;
DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_cd`;
CREATE TEMPORARY TABLE `world`.`tmp_cd` SELECT * FROM `world`.`creature_template_difficulty` WHERE Entry = 93158 AND DifficultyID = 0;
UPDATE `world`.`tmp_cd` SET Entry = 9900432;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `world`.`tmp_cd`;
INSERT INTO `world`.`lw_route_node` (`route`, `idx`, `map`, `x`, `y`, `z`, `stop`, `wait_s`) VALUES
(100, 1, 0, -14457.70, 495.35, 15.21, 'The Salty Sailor Tavern', 40),
(100, 2, 0, -14346.29, 516.16, 14.14, NULL, 0),
(100, 3, 0, -14234.88, 536.97, 13.07, NULL, 0),
(100, 4, 0, -14123.47, 557.78, 12.00, NULL, 0),
(100, 5, 0, -14012.06, 578.58, 10.93, NULL, 0),
(100, 6, 0, -13900.65, 599.39, 9.86, NULL, 0),
(100, 7, 0, -13789.25, 620.20, 8.79, NULL, 0),
(100, 8, 0, -13677.84, 641.01, 7.72, NULL, 0),
(100, 9, 0, -13566.43, 661.82, 6.65, NULL, 0),
(100, 10, 0, -13455.02, 682.63, 5.58, NULL, 0),
(100, 11, 0, -13343.61, 703.44, 4.51, NULL, 0),
(100, 12, 0, -13232.20, 724.25, 3.44, 'Hardwrench Hideaway', 40),
(100, 13, 0, -13132.48, 660.16, 3.32, NULL, 0),
(100, 14, 0, -13032.75, 596.08, 3.19, NULL, 0),
(100, 15, 0, -12933.03, 531.99, 3.07, NULL, 0),
(100, 16, 0, -12833.30, 467.90, 2.94, NULL, 0),
(100, 17, 0, -12733.58, 403.82, 2.82, NULL, 0),
(100, 18, 0, -12633.85, 339.73, 2.70, NULL, 0),
(100, 19, 0, -12534.13, 275.65, 2.57, NULL, 0),
(100, 20, 0, -12434.40, 211.56, 2.45, 'Grom''gol Base Camp', 40),
(100, 21, 0, -12493.21, 118.77, 3.96, NULL, 0),
(100, 22, 0, -12552.03, 25.97, 5.48, NULL, 0),
(100, 23, 0, -12610.84, -66.82, 6.99, NULL, 0),
(100, 24, 0, -12669.66, -159.61, 8.51, NULL, 0),
(100, 25, 0, -12728.47, -252.40, 10.02, NULL, 0),
(100, 26, 0, -12787.29, -345.20, 11.54, NULL, 0),
(100, 27, 0, -12846.10, -437.99, 13.05, 'Fort Livingston', 40),
(101, 1, 0, -10925.30, -3417.68, 66.58, 'Nethergarde Keep', 40),
(101, 2, 0, -10815.80, -3377.97, 55.24, NULL, 0),
(101, 3, 0, -10706.30, -3338.26, 43.90, NULL, 0),
(101, 4, 0, -10596.80, -3298.54, 32.56, NULL, 0),
(101, 5, 0, -10487.30, -3258.83, 21.22, 'Stonard', 40),
(101, 6, 0, -10418.92, -3183.89, 21.72, NULL, 0),
(101, 7, 0, -10350.53, -3108.94, 22.22, NULL, 0),
(101, 8, 0, -10282.15, -3034.00, 22.71, NULL, 0),
(101, 9, 0, -10213.77, -2959.06, 23.21, NULL, 0),
(101, 10, 0, -10145.38, -2884.11, 23.71, NULL, 0),
(101, 11, 0, -10077.00, -2809.17, 24.21, 'The Harborage', 40),
(101, 12, 0, -10188.81, -2789.90, 22.16, NULL, 0),
(101, 13, 0, -10300.63, -2770.63, 20.12, NULL, 0),
(101, 14, 0, -10412.44, -2751.36, 18.07, NULL, 0),
(101, 15, 0, -10524.26, -2732.08, 16.03, NULL, 0),
(101, 16, 0, -10636.07, -2712.81, 13.98, NULL, 0),
(101, 17, 0, -10747.89, -2693.54, 11.94, NULL, 0),
(101, 18, 0, -10859.70, -2674.27, 9.89, 'Dreadmaul Hold', 40),
(102, 1, 0, -7085.53, -1202.19, 323.99, 'Iron Summit', 40),
(102, 2, 0, -7052.91, -1316.95, 319.50, NULL, 0),
(102, 3, 0, -7020.28, -1431.71, 315.02, NULL, 0),
(102, 4, 0, -6987.66, -1546.47, 310.53, NULL, 0),
(102, 5, 0, -6955.04, -1661.23, 306.05, NULL, 0),
(102, 6, 0, -6922.42, -1775.99, 301.57, NULL, 0),
(102, 7, 0, -6889.79, -1890.74, 297.08, NULL, 0),
(102, 8, 0, -6857.17, -2005.50, 292.60, NULL, 0),
(102, 9, 0, -6824.55, -2120.26, 288.11, NULL, 0),
(102, 10, 0, -6791.93, -2235.02, 283.63, NULL, 0),
(102, 11, 0, -6759.30, -2349.78, 279.15, NULL, 0),
(102, 12, 0, -6726.68, -2464.54, 274.66, 'New Kargath', 40),
(102, 13, 0, -6819.99, -2488.76, 263.71, NULL, 0),
(102, 14, 0, -6913.31, -2512.98, 252.75, NULL, 0),
(102, 15, 0, -7006.62, -2537.20, 241.80, 'Dragon''s Mouth', 40),
(102, 16, 0, -6974.15, -2643.81, 252.40, NULL, 0),
(102, 17, 0, -6941.68, -2750.42, 263.00, NULL, 0),
(102, 18, 0, -6909.21, -2857.03, 273.60, NULL, 0),
(102, 19, 0, -6876.74, -2963.64, 284.20, NULL, 0),
(102, 20, 0, -6844.27, -3070.25, 294.81, NULL, 0),
(102, 21, 0, -6811.80, -3176.86, 305.41, NULL, 0),
(102, 22, 0, -6779.33, -3283.47, 316.01, NULL, 0),
(102, 23, 0, -6746.86, -3390.08, 326.61, NULL, 0),
(102, 24, 0, -6714.39, -3496.69, 337.22, NULL, 0),
(102, 25, 0, -6681.92, -3603.30, 347.82, NULL, 0),
(102, 26, 0, -6649.45, -3709.91, 358.42, NULL, 0),
(102, 27, 0, -6616.98, -3816.52, 369.02, NULL, 0),
(102, 28, 0, -6584.51, -3923.13, 379.62, 'Fuselight', 40),
(102, 29, 0, -6589.82, -4029.47, 326.71, NULL, 0),
(102, 30, 0, -6595.12, -4135.81, 273.79, NULL, 0),
(102, 31, 0, -6600.43, -4242.15, 220.87, NULL, 0),
(102, 32, 0, -6605.73, -4348.49, 167.95, NULL, 0),
(102, 33, 0, -6611.04, -4454.83, 115.03, NULL, 0),
(102, 34, 0, -6616.34, -4561.17, 62.11, NULL, 0),
(102, 35, 0, -6621.65, -4667.51, 9.19, 'Fuselight-by-the-Sea', 40),
(103, 1, 0, -5676.20, -4253.09, 407.09, 'The Farstrider Lodge', 40),
(103, 2, 0, -5584.80, -4315.29, 383.71, NULL, 0),
(103, 3, 0, -5493.40, -4377.50, 360.33, NULL, 0),
(103, 4, 0, -5402.00, -4439.70, 336.95, NULL, 0),
(103, 5, 0, -5310.60, -4501.91, 313.57, NULL, 0),
(103, 6, 0, -5219.20, -4564.11, 290.18, NULL, 0),
(103, 7, 0, -5127.80, -4626.32, 266.80, NULL, 0),
(103, 8, 0, -5036.40, -4688.52, 243.42, NULL, 0),
(103, 9, 0, -4945.00, -4750.73, 220.04, NULL, 0),
(103, 10, 0, -4853.60, -4812.93, 196.66, 'Crushblow', 40),
(103, 11, 0, -4739.23, -4800.26, 185.03, NULL, 0),
(103, 12, 0, -4624.86, -4787.59, 173.40, NULL, 0),
(103, 13, 0, -4510.50, -4774.92, 161.77, NULL, 0),
(103, 14, 0, -4396.13, -4762.24, 150.14, NULL, 0),
(103, 15, 0, -4281.76, -4749.57, 138.51, NULL, 0),
(103, 16, 0, -4167.39, -4736.90, 126.88, 'Victor''s Point', 40),
(103, 17, 0, -4083.37, -4821.90, 112.77, NULL, 0),
(103, 18, 0, -3999.34, -4906.89, 98.66, NULL, 0),
(103, 19, 0, -3915.32, -4991.89, 84.55, NULL, 0),
(103, 20, 0, -3831.29, -5076.89, 70.44, NULL, 0),
(103, 21, 0, -3747.27, -5161.88, 56.33, NULL, 0),
(103, 22, 0, -3663.24, -5246.88, 42.22, 'Bloodgulch', 40),
(103, 23, 0, -3554.01, -5197.39, 61.84, NULL, 0),
(103, 24, 0, -3444.78, -5147.91, 81.47, NULL, 0),
(103, 25, 0, -3335.55, -5098.42, 101.09, NULL, 0),
(103, 26, 0, -3226.32, -5048.93, 120.71, 'Thundermar', 40),
(104, 1, 0, -4903.77, -6610.56, 10.92, 'Highbank', 40),
(104, 2, 0, -4792.03, -6589.23, 14.73, NULL, 0),
(104, 3, 0, -4680.29, -6567.89, 18.54, NULL, 0),
(104, 4, 0, -4568.55, -6546.56, 22.36, NULL, 0),
(104, 5, 0, -4456.82, -6525.23, 26.17, NULL, 0),
(104, 6, 0, -4345.08, -6503.90, 29.98, NULL, 0),
(104, 7, 0, -4233.34, -6482.56, 33.80, NULL, 0),
(104, 8, 0, -4121.61, -6461.23, 37.61, NULL, 0),
(104, 9, 0, -4009.87, -6439.90, 41.42, 'Dragonmaw Port', 40),
(104, 10, 0, -4033.58, -6337.54, 39.20, NULL, 0),
(104, 11, 0, -4057.28, -6235.18, 36.97, NULL, 0),
(104, 12, 0, -4080.98, -6132.82, 34.74, NULL, 0),
(104, 13, 0, -4104.69, -6030.46, 32.51, NULL, 0),
(104, 14, 0, -4128.39, -5928.11, 30.28, NULL, 0),
(104, 15, 0, -4152.10, -5825.75, 28.05, NULL, 0),
(104, 16, 0, -4175.80, -5723.39, 25.82, NULL, 0),
(104, 17, 0, -4199.51, -5621.03, 23.59, 'Firebeard''s Patrol', 40),
(104, 18, 0, -4091.00, -5597.57, 35.16, NULL, 0),
(104, 19, 0, -3982.50, -5574.10, 46.72, NULL, 0),
(104, 20, 0, -3873.99, -5550.64, 58.29, NULL, 0),
(104, 21, 0, -3765.49, -5527.18, 69.85, NULL, 0),
(104, 22, 0, -3656.98, -5503.71, 81.42, NULL, 0),
(104, 23, 0, -3548.47, -5480.25, 92.98, NULL, 0),
(104, 24, 0, -3439.97, -5456.79, 104.55, NULL, 0),
(104, 25, 0, -3331.46, -5433.33, 116.11, NULL, 0),
(104, 26, 0, -3222.95, -5409.86, 127.68, NULL, 0),
(104, 27, 0, -3114.45, -5386.40, 139.24, NULL, 0),
(104, 28, 0, -3005.94, -5362.94, 150.81, NULL, 0),
(104, 29, 0, -2897.44, -5339.47, 162.37, NULL, 0),
(104, 30, 0, -2788.93, -5316.01, 173.94, 'Kirthaven', 40),
(104, 31, 0, -2783.70, -5425.38, 180.76, NULL, 0),
(104, 32, 0, -2778.48, -5534.75, 187.59, NULL, 0),
(104, 33, 0, -2773.25, -5644.13, 194.41, NULL, 0),
(104, 34, 0, -2768.03, -5753.50, 201.24, NULL, 0),
(104, 35, 0, -2762.80, -5862.87, 208.06, NULL, 0),
(104, 36, 0, -2757.58, -5972.24, 214.88, NULL, 0),
(104, 37, 0, -2752.35, -6081.61, 221.71, NULL, 0),
(104, 38, 0, -2747.13, -6190.99, 228.53, NULL, 0),
(104, 39, 0, -2741.90, -6300.36, 235.36, NULL, 0),
(104, 40, 0, -2736.68, -6409.73, 242.18, 'The Krazzworks', 40),
(105, 1, 0, -3825.19, -833.29, 0.73, 'Deepwater Tavern', 40),
(105, 2, 0, -3729.30, -895.10, 1.49, NULL, 0),
(105, 3, 0, -3633.40, -956.91, 2.26, NULL, 0),
(105, 4, 0, -3537.51, -1018.72, 3.02, NULL, 0),
(105, 5, 0, -3441.61, -1080.53, 3.78, NULL, 0),
(105, 6, 0, -3345.72, -1142.35, 4.54, NULL, 0),
(105, 7, 0, -3249.83, -1204.16, 5.31, NULL, 0),
(105, 8, 0, -3153.93, -1265.97, 6.07, NULL, 0),
(105, 9, 0, -3058.04, -1327.78, 6.83, NULL, 0),
(105, 10, 0, -2962.14, -1389.59, 7.59, NULL, 0),
(105, 11, 0, -2866.25, -1451.40, 8.36, 'Sundown Marsh', 40),
(105, 12, 0, -2896.26, -1563.45, 9.43, NULL, 0),
(105, 13, 0, -2926.26, -1675.50, 10.50, NULL, 0),
(105, 14, 0, -2956.27, -1787.55, 11.57, NULL, 0),
(105, 15, 0, -2986.27, -1899.59, 12.64, NULL, 0),
(105, 16, 0, -3016.28, -2011.64, 13.71, NULL, 0),
(105, 17, 0, -3046.28, -2123.69, 14.78, NULL, 0),
(105, 18, 0, -3076.29, -2235.74, 15.85, NULL, 0),
(105, 19, 0, -3106.29, -2347.79, 16.93, NULL, 0),
(105, 20, 0, -3136.30, -2459.83, 18.00, NULL, 0),
(105, 21, 0, -3166.30, -2571.88, 19.07, NULL, 0),
(105, 22, 0, -3196.31, -2683.93, 20.14, NULL, 0),
(105, 23, 0, -3226.31, -2795.98, 21.21, 'Greenwarden''s Grove', 40),
(106, 1, 0, -622.03, -4583.40, 11.77, 'Revantusk Village', 40),
(106, 2, 0, -516.45, -4532.21, 23.49, NULL, 0),
(106, 3, 0, -410.86, -4481.01, 35.22, NULL, 0),
(106, 4, 0, -305.28, -4429.82, 46.94, NULL, 0),
(106, 5, 0, -199.70, -4378.62, 58.67, NULL, 0),
(106, 6, 0, -94.11, -4327.43, 70.39, NULL, 0),
(106, 7, 0, 11.47, -4276.23, 82.11, NULL, 0),
(106, 8, 0, 117.06, -4225.04, 93.84, NULL, 0),
(106, 9, 0, 222.64, -4173.84, 105.56, NULL, 0),
(106, 10, 0, 328.23, -4122.65, 117.28, 'Stormfeather Outpost', 40),
(106, 11, 0, 299.07, -4012.38, 117.66, NULL, 0),
(106, 12, 0, 269.91, -3902.11, 118.04, NULL, 0),
(106, 13, 0, 240.75, -3791.84, 118.42, NULL, 0),
(106, 14, 0, 211.59, -3681.57, 118.79, NULL, 0),
(106, 15, 0, 182.44, -3571.30, 119.17, NULL, 0),
(106, 16, 0, 153.28, -3461.03, 119.55, NULL, 0),
(106, 17, 0, 124.12, -3350.77, 119.93, NULL, 0),
(106, 18, 0, 94.96, -3240.50, 120.30, NULL, 0),
(106, 19, 0, 65.80, -3130.23, 120.68, NULL, 0),
(106, 20, 0, 36.64, -3019.96, 121.06, NULL, 0),
(106, 21, 0, 7.49, -2909.69, 121.44, NULL, 0),
(106, 22, 0, -21.67, -2799.42, 121.81, 'Hiri''watha Research Station', 40),
(106, 23, 0, 27.15, -2702.25, 121.83, NULL, 0),
(106, 24, 0, 75.97, -2605.08, 121.84, NULL, 0),
(106, 25, 0, 124.78, -2507.91, 121.86, NULL, 0),
(106, 26, 0, 173.60, -2410.73, 121.88, NULL, 0),
(106, 27, 0, 222.42, -2313.56, 121.89, NULL, 0),
(106, 28, 0, 271.24, -2216.39, 121.91, NULL, 0),
(106, 29, 0, 320.06, -2119.22, 121.92, 'Wildhammer Keep', 40),
(106, 30, 0, 397.82, -2035.08, 114.62, NULL, 0),
(106, 31, 0, 475.57, -1950.94, 107.31, NULL, 0),
(106, 32, 0, 553.33, -1866.80, 100.01, NULL, 0),
(106, 33, 0, 631.08, -1782.65, 92.70, NULL, 0),
(106, 34, 0, 708.84, -1698.51, 85.40, NULL, 0),
(106, 35, 0, 786.60, -1614.37, 78.09, NULL, 0),
(106, 36, 0, 864.35, -1530.23, 70.79, NULL, 0),
(106, 37, 0, 942.11, -1446.09, 63.48, 'Chillwind Camp', 40),
(107, 1, 0, 471.14, 1500.55, 135.60, 'The Sepulcher', 40),
(107, 2, 0, 575.54, 1515.01, 117.77, NULL, 0),
(107, 3, 0, 679.95, 1529.46, 99.94, NULL, 0),
(107, 4, 0, 784.35, 1543.92, 82.11, NULL, 0),
(107, 5, 0, 888.76, 1558.38, 64.28, NULL, 0),
(107, 6, 0, 993.16, 1572.83, 46.45, NULL, 0),
(107, 7, 0, 1097.57, 1587.29, 28.61, 'Forsaken Rear Guard', 40),
(108, 1, 0, 1537.40, -1661.51, 67.99, 'Andorhal', 40),
(108, 2, 0, 1553.77, -1543.95, 66.86, NULL, 0),
(108, 3, 0, 1570.14, -1426.38, 65.74, NULL, 0),
(108, 4, 0, 1586.50, -1308.82, 64.62, NULL, 0),
(108, 5, 0, 1602.87, -1191.25, 63.49, NULL, 0),
(108, 6, 0, 1619.24, -1073.69, 62.37, NULL, 0),
(108, 7, 0, 1635.60, -956.12, 61.25, NULL, 0),
(108, 8, 0, 1651.97, -838.56, 60.12, NULL, 0),
(108, 9, 0, 1668.34, -720.99, 59.00, 'The Bulwark', 40),
(108, 10, 0, 1730.08, -620.67, 56.45, NULL, 0),
(108, 11, 0, 1791.83, -520.34, 53.90, NULL, 0),
(108, 12, 0, 1853.57, -420.01, 51.35, NULL, 0),
(108, 13, 0, 1915.32, -319.69, 48.80, NULL, 0),
(108, 14, 0, 1977.06, -219.36, 46.25, NULL, 0),
(108, 15, 0, 2038.80, -119.03, 43.69, NULL, 0),
(108, 16, 0, 2100.55, -18.71, 41.14, NULL, 0),
(108, 17, 0, 2162.29, 81.62, 38.59, NULL, 0),
(108, 18, 0, 2224.04, 181.95, 36.04, NULL, 0),
(108, 19, 0, 2285.78, 282.27, 33.49, 'Brill', 40),
(109, 1, 1, -7069.17, -3854.53, 9.93, 'The Road Warrior', 40),
(109, 2, 1, -6955.62, -3847.44, 9.47, NULL, 0),
(109, 3, 1, -6842.07, -3840.35, 9.02, NULL, 0),
(109, 4, 1, -6728.52, -3833.26, 8.56, NULL, 0),
(109, 5, 1, -6614.97, -3826.18, 8.10, NULL, 0),
(109, 6, 1, -6501.42, -3819.09, 7.64, NULL, 0),
(109, 7, 1, -6387.87, -3812.00, 7.18, NULL, 0),
(109, 8, 1, -6274.32, -3804.91, 6.72, NULL, 0),
(109, 9, 1, -6160.77, -3797.82, 6.26, 'Speedbarge Bar', 40),
(110, 1, 1, -5472.94, -2457.68, 89.37, 'Freewind Post', 40),
(110, 2, 1, -5388.64, -2529.52, 84.55, NULL, 0),
(110, 3, 1, -5304.34, -2601.37, 79.74, NULL, 0),
(110, 4, 1, -5220.04, -2673.21, 74.92, NULL, 0),
(110, 5, 1, -5135.74, -2745.06, 70.11, NULL, 0),
(110, 6, 1, -5051.44, -2816.90, 65.30, NULL, 0),
(110, 7, 1, -4967.14, -2888.74, 60.48, NULL, 0),
(110, 8, 1, -4882.84, -2960.59, 55.67, NULL, 0),
(110, 9, 1, -4798.54, -3032.43, 50.85, NULL, 0),
(110, 10, 1, -4714.24, -3104.28, 46.04, NULL, 0),
(110, 11, 1, -4629.94, -3176.12, 41.22, 'Mudsprocket', 40),
(110, 12, 1, -4517.30, -3155.78, 40.76, NULL, 0),
(110, 13, 1, -4404.66, -3135.45, 40.29, NULL, 0),
(110, 14, 1, -4292.02, -3115.11, 39.82, NULL, 0),
(110, 15, 1, -4179.38, -3094.78, 39.35, NULL, 0),
(110, 16, 1, -4066.74, -3074.44, 38.88, NULL, 0),
(110, 17, 1, -3954.10, -3054.11, 38.42, NULL, 0),
(110, 18, 1, -3841.45, -3033.77, 37.95, NULL, 0),
(110, 19, 1, -3728.81, -3013.44, 37.48, NULL, 0),
(110, 20, 1, -3616.17, -2993.10, 37.01, NULL, 0),
(110, 21, 1, -3503.53, -2972.77, 36.54, NULL, 0),
(110, 22, 1, -3390.89, -2952.43, 36.08, NULL, 0),
(110, 23, 1, -3278.25, -2932.10, 35.61, NULL, 0),
(110, 24, 1, -3165.61, -2911.76, 35.14, 'Brackenwall Village', 40),
(110, 25, 1, -3168.56, -2806.32, 44.84, NULL, 0),
(110, 26, 1, -3171.50, -2700.88, 54.55, NULL, 0),
(110, 27, 1, -3174.45, -2595.44, 64.25, NULL, 0),
(110, 28, 1, -3177.40, -2489.99, 73.96, NULL, 0),
(110, 29, 1, -3180.34, -2384.55, 83.66, NULL, 0),
(110, 30, 1, -3183.29, -2279.11, 93.36, 'Fort Triumph', 40),
(110, 31, 1, -3189.52, -2176.57, 94.47, NULL, 0),
(110, 32, 1, -3195.76, -2074.03, 95.57, NULL, 0),
(110, 33, 1, -3201.99, -1971.49, 96.68, NULL, 0),
(110, 34, 1, -3208.22, -1868.94, 97.78, NULL, 0),
(110, 35, 1, -3214.46, -1766.40, 98.89, NULL, 0),
(110, 36, 1, -3220.69, -1663.86, 99.99, 'Desolation Hold', 40),
(111, 1, 1, -4564.63, 1835.27, 87.52, 'Stonemaul Hold', 40),
(111, 2, 1, -4540.24, 1935.74, 72.56, NULL, 0),
(111, 3, 1, -4515.84, 2036.21, 57.60, NULL, 0),
(111, 4, 1, -4491.45, 2136.69, 42.64, NULL, 0),
(111, 5, 1, -4467.06, 2237.16, 27.67, 'Feathermoon Stronghold', 40),
(111, 6, 1, -4351.67, 2205.89, 29.65, NULL, 0),
(111, 7, 1, -4236.29, 2174.63, 31.63, NULL, 0),
(111, 8, 1, -4120.90, 2143.36, 33.60, NULL, 0),
(111, 9, 1, -4005.51, 2112.09, 35.58, NULL, 0),
(111, 10, 1, -3890.12, 2080.83, 37.56, NULL, 0),
(111, 11, 1, -3774.74, 2049.56, 39.53, NULL, 0),
(111, 12, 1, -3659.35, 2018.30, 41.51, NULL, 0),
(111, 13, 1, -3543.96, 1987.03, 43.49, NULL, 0),
(111, 14, 1, -3428.57, 1955.76, 45.46, NULL, 0),
(111, 15, 1, -3313.19, 1924.50, 47.44, NULL, 0),
(111, 16, 1, -3197.80, 1893.23, 49.42, 'Dreamer''s Rest', 40),
(111, 17, 1, -3181.02, 2004.89, 49.56, NULL, 0),
(111, 18, 1, -3164.23, 2116.55, 49.70, NULL, 0),
(111, 19, 1, -3147.45, 2228.20, 49.84, NULL, 0),
(111, 20, 1, -3130.66, 2339.86, 49.98, NULL, 0),
(111, 21, 1, -3113.88, 2451.52, 50.12, NULL, 0),
(111, 22, 1, -3097.09, 2563.18, 50.26, 'Camp Ataya', 40),
(112, 1, 1, -2096.83, -3504.85, 95.08, 'Northwatch Hold', 40),
(112, 2, 1, -1980.52, -3522.62, 87.18, NULL, 0),
(112, 3, 1, -1864.21, -3540.39, 79.28, NULL, 0),
(112, 4, 1, -1747.90, -3558.17, 71.37, NULL, 0),
(112, 5, 1, -1631.59, -3575.94, 63.47, NULL, 0),
(112, 6, 1, -1515.28, -3593.71, 55.57, NULL, 0),
(112, 7, 1, -1398.97, -3611.48, 47.67, NULL, 0),
(112, 8, 1, -1282.66, -3629.26, 39.77, NULL, 0),
(112, 9, 1, -1166.35, -3647.03, 31.87, NULL, 0),
(112, 10, 1, -1050.04, -3664.80, 23.97, 'Broken Keel Tavern', 40),
(112, 11, 1, -947.82, -3615.94, 29.62, NULL, 0),
(112, 12, 1, -845.61, -3567.08, 35.28, NULL, 0),
(112, 13, 1, -743.39, -3518.21, 40.93, NULL, 0),
(112, 14, 1, -641.18, -3469.35, 46.59, NULL, 0),
(112, 15, 1, -538.96, -3420.49, 52.24, NULL, 0),
(112, 16, 1, -436.74, -3371.63, 57.90, NULL, 0),
(112, 17, 1, -334.53, -3322.76, 63.55, NULL, 0),
(112, 18, 1, -232.31, -3273.90, 69.20, NULL, 0),
(112, 19, 1, -130.09, -3225.04, 74.86, NULL, 0),
(112, 20, 1, -27.88, -3176.18, 80.51, NULL, 0),
(112, 21, 1, 74.34, -3127.31, 86.17, NULL, 0),
(112, 22, 1, 176.55, -3078.45, 91.82, NULL, 0),
(112, 23, 1, 278.77, -3029.59, 97.48, 'Grol''dom Farm', 40),
(112, 24, 1, 378.36, -3069.72, 96.87, NULL, 0),
(112, 25, 1, 477.95, -3109.86, 96.26, NULL, 0),
(112, 26, 1, 577.54, -3149.99, 95.65, NULL, 0),
(112, 27, 1, 677.13, -3190.12, 95.04, NULL, 0),
(112, 28, 1, 776.73, -3230.26, 94.43, NULL, 0),
(112, 29, 1, 876.32, -3270.39, 93.82, NULL, 0),
(112, 30, 1, 975.91, -3310.52, 93.21, NULL, 0),
(112, 31, 1, 1075.50, -3350.66, 92.60, NULL, 0),
(112, 32, 1, 1175.09, -3390.79, 91.99, 'Nozzlepot''s Outpost', 40),
(112, 33, 1, 1272.32, -3322.14, 92.92, NULL, 0),
(112, 34, 1, 1369.55, -3253.49, 93.85, NULL, 0),
(112, 35, 1, 1466.78, -3184.84, 94.79, NULL, 0),
(112, 36, 1, 1564.01, -3116.19, 95.72, NULL, 0),
(112, 37, 1, 1661.24, -3047.54, 96.65, NULL, 0),
(112, 38, 1, 1758.48, -2978.89, 97.58, NULL, 0),
(112, 39, 1, 1855.71, -2910.24, 98.52, NULL, 0),
(112, 40, 1, 1952.94, -2841.59, 99.45, NULL, 0),
(112, 41, 1, 2050.17, -2772.94, 100.38, NULL, 0),
(112, 42, 1, 2147.40, -2704.29, 101.31, NULL, 0),
(112, 43, 1, 2244.63, -2635.64, 102.24, NULL, 0),
(112, 44, 1, 2341.86, -2566.99, 103.18, 'Splintertree Post', 40),
(113, 1, 1, -1472.14, -1911.76, 95.26, 'Camp Una''fe', 40),
(113, 2, 1, -1374.02, -1860.43, 101.72, NULL, 0),
(113, 3, 1, -1275.90, -1809.10, 108.18, NULL, 0),
(113, 4, 1, -1177.78, -1757.77, 114.64, NULL, 0),
(113, 5, 1, -1079.65, -1706.45, 121.10, NULL, 0),
(113, 6, 1, -981.53, -1655.12, 127.57, NULL, 0),
(113, 7, 1, -883.41, -1603.79, 134.03, NULL, 0),
(113, 8, 1, -785.29, -1552.46, 140.49, 'Hunter''s Hill', 40),
(113, 9, 1, -674.46, -1549.08, 127.20, NULL, 0),
(113, 10, 1, -563.62, -1545.70, 113.91, NULL, 0),
(113, 11, 1, -452.79, -1542.31, 100.61, NULL, 0),
(113, 12, 1, -341.96, -1538.93, 87.32, 'Honor''s Stand', 40),
(113, 13, 1, -288.96, -1434.87, 87.72, NULL, 0),
(113, 14, 1, -235.97, -1330.82, 88.13, NULL, 0),
(113, 15, 1, -182.98, -1226.76, 88.53, NULL, 0),
(113, 16, 1, -129.98, -1122.71, 88.93, NULL, 0),
(113, 17, 1, -76.99, -1018.65, 89.34, NULL, 0),
(113, 18, 1, -23.99, -914.60, 89.74, NULL, 0),
(113, 19, 1, 29.00, -810.54, 90.14, NULL, 0),
(113, 20, 1, 82.00, -706.48, 90.55, NULL, 0),
(113, 21, 1, 134.99, -602.43, 90.95, NULL, 0),
(113, 22, 1, 187.99, -498.37, 91.35, NULL, 0),
(113, 23, 1, 240.98, -394.32, 91.76, NULL, 0),
(113, 24, 1, 293.97, -290.26, 92.16, 'Northwatch Expedition Base Camp Inn', 40),
(113, 25, 1, 391.19, -245.27, 92.26, NULL, 0),
(113, 26, 1, 488.41, -200.28, 92.36, NULL, 0),
(113, 27, 1, 585.63, -155.28, 92.46, NULL, 0),
(113, 28, 1, 682.85, -110.29, 92.56, NULL, 0),
(113, 29, 1, 780.07, -65.30, 92.66, NULL, 0),
(113, 30, 1, 877.29, -20.31, 92.76, 'Krom''gar Fortress', 40),
(114, 1, 1, -1047.23, 1683.57, 60.22, 'Karnum''s Glade', 40),
(114, 2, 1, -938.66, 1647.75, 71.22, NULL, 0),
(114, 3, 1, -830.09, 1611.93, 82.22, NULL, 0),
(114, 4, 1, -721.52, 1576.12, 93.22, NULL, 0),
(114, 5, 1, -612.95, 1540.30, 104.22, NULL, 0),
(114, 6, 1, -504.38, 1504.48, 115.22, NULL, 0),
(114, 7, 1, -395.81, 1468.66, 126.22, NULL, 0),
(114, 8, 1, -287.24, 1432.85, 137.22, NULL, 0),
(114, 9, 1, -178.67, 1397.03, 148.22, NULL, 0),
(114, 10, 1, -70.10, 1361.21, 159.22, NULL, 0),
(114, 11, 1, 38.47, 1325.39, 170.22, NULL, 0),
(114, 12, 1, 147.04, 1289.58, 181.22, NULL, 0),
(114, 13, 1, 255.62, 1253.76, 192.22, 'Nijel''s Point', 40),
(114, 14, 1, 361.95, 1199.46, 177.91, NULL, 0),
(114, 15, 1, 468.29, 1145.16, 163.60, NULL, 0),
(114, 16, 1, 574.63, 1090.85, 149.29, NULL, 0),
(114, 17, 1, 680.97, 1036.55, 134.98, NULL, 0),
(114, 18, 1, 787.31, 982.25, 120.67, NULL, 0),
(114, 19, 1, 893.65, 927.95, 106.36, 'Sun Rock Retreat', 40),
(114, 20, 1, 952.37, 826.85, 100.95, NULL, 0),
(114, 21, 1, 1011.09, 725.75, 95.54, NULL, 0),
(114, 22, 1, 1069.80, 624.66, 90.13, NULL, 0),
(114, 23, 1, 1128.52, 523.56, 84.72, NULL, 0),
(114, 24, 1, 1187.24, 422.46, 79.31, 'Fallowmere Inn', 40),
(114, 25, 1, 1258.46, 511.16, 99.63, NULL, 0),
(114, 26, 1, 1329.68, 599.85, 119.95, NULL, 0),
(114, 27, 1, 1400.91, 688.55, 140.27, NULL, 0),
(114, 28, 1, 1472.13, 777.24, 160.59, NULL, 0),
(114, 29, 1, 1543.35, 865.94, 180.90, NULL, 0),
(114, 30, 1, 1614.57, 954.63, 201.22, NULL, 0),
(114, 31, 1, 1685.80, 1043.32, 221.54, NULL, 0),
(114, 32, 1, 1757.02, 1132.02, 241.86, NULL, 0),
(114, 33, 1, 1828.24, 1220.71, 262.17, NULL, 0),
(114, 34, 1, 1899.46, 1309.41, 282.49, NULL, 0),
(114, 35, 1, 1970.69, 1398.10, 302.81, NULL, 0),
(114, 36, 1, 2041.91, 1486.80, 323.13, NULL, 0),
(114, 37, 1, 2113.13, 1575.49, 343.44, 'Thal''darah Overlook', 40),
(115, 1, 1, 2091.67, -1208.05, 101.88, 'Silverwind Refuge', 40),
(115, 2, 1, 2168.28, -1121.93, 103.52, NULL, 0),
(115, 3, 1, 2244.89, -1035.82, 105.16, NULL, 0),
(115, 4, 1, 2321.50, -949.70, 106.81, NULL, 0),
(115, 5, 1, 2398.11, -863.58, 108.45, NULL, 0),
(115, 6, 1, 2474.72, -777.47, 110.09, NULL, 0),
(115, 7, 1, 2551.33, -691.35, 111.73, NULL, 0),
(115, 8, 1, 2627.94, -605.23, 113.38, NULL, 0),
(115, 9, 1, 2704.55, -519.11, 115.02, NULL, 0),
(115, 10, 1, 2781.16, -433.00, 116.66, 'Astranaar', 40),
(115, 11, 1, 2871.18, -464.03, 146.35, NULL, 0),
(115, 12, 1, 2961.21, -495.06, 176.04, NULL, 0),
(115, 13, 1, 3051.23, -526.09, 205.72, 'Hellscream''s Watch', 40),
(116, 1, 1, 4735.21, -866.35, 343.55, 'Wildheart Point', 40),
(116, 2, 1, 4854.90, -872.31, 350.02, NULL, 0),
(116, 3, 1, 4974.59, -878.27, 356.50, NULL, 0),
(116, 4, 1, 5094.27, -884.23, 362.97, NULL, 0),
(116, 5, 1, 5213.96, -890.19, 369.45, NULL, 0),
(116, 6, 1, 5333.65, -896.14, 375.92, NULL, 0),
(116, 7, 1, 5453.34, -902.10, 382.40, NULL, 0),
(116, 8, 1, 5573.03, -908.06, 388.87, NULL, 0),
(116, 9, 1, 5692.72, -914.02, 395.35, NULL, 0),
(116, 10, 1, 5812.40, -919.98, 401.82, NULL, 0),
(116, 11, 1, 5932.09, -925.94, 408.30, NULL, 0),
(116, 12, 1, 6051.78, -931.90, 414.77, 'Whisperwind Grove', 40),
(116, 13, 1, 6063.31, -1045.12, 431.81, NULL, 0),
(116, 14, 1, 6074.84, -1158.33, 448.85, NULL, 0),
(116, 15, 1, 6086.37, -1271.55, 465.89, NULL, 0),
(116, 16, 1, 6097.90, -1384.77, 482.93, NULL, 0),
(116, 17, 1, 6109.43, -1497.98, 499.97, NULL, 0),
(116, 18, 1, 6120.96, -1611.20, 517.01, NULL, 0),
(116, 19, 1, 6132.49, -1724.42, 534.05, NULL, 0),
(116, 20, 1, 6144.02, -1837.63, 551.09, NULL, 0),
(116, 21, 1, 6155.55, -1950.85, 568.13, 'Talonbranch Glade ', 40),
(117, 1, 530, -5142.57, 581.33, 84.14, 'Dragonmaw Base Camp', 40),
(117, 2, 530, -5042.50, 635.92, 80.18, NULL, 0),
(117, 3, 530, -4942.44, 690.51, 76.23, NULL, 0),
(117, 4, 530, -4842.37, 745.11, 72.28, NULL, 0),
(117, 5, 530, -4742.30, 799.70, 68.33, NULL, 0),
(117, 6, 530, -4642.23, 854.29, 64.38, NULL, 0),
(117, 7, 530, -4542.17, 908.89, 60.42, NULL, 0),
(117, 8, 530, -4442.10, 963.48, 56.47, NULL, 0),
(117, 9, 530, -4342.03, 1018.07, 52.52, NULL, 0),
(117, 10, 530, -4241.97, 1072.67, 48.57, NULL, 0),
(117, 11, 530, -4141.90, 1127.26, 44.61, 'Sanctum of the Stars', 40),
(117, 12, 530, -4135.50, 1245.01, 51.61, NULL, 0),
(117, 13, 530, -4129.10, 1362.75, 58.61, NULL, 0),
(117, 14, 530, -4122.71, 1480.50, 65.60, NULL, 0),
(117, 15, 530, -4116.31, 1598.24, 72.60, NULL, 0),
(117, 16, 530, -4109.91, 1715.99, 79.60, NULL, 0),
(117, 17, 530, -4103.51, 1833.73, 86.59, NULL, 0),
(117, 18, 530, -4097.12, 1951.48, 93.59, NULL, 0),
(117, 19, 530, -4090.72, 2069.22, 100.59, NULL, 0),
(117, 20, 530, -4084.32, 2186.97, 107.58, 'Wildhammer Stronghold', 40),
(117, 21, 530, -3972.39, 2224.47, 104.69, NULL, 0),
(117, 22, 530, -3860.46, 2261.98, 101.79, NULL, 0),
(117, 23, 530, -3748.52, 2299.48, 98.89, NULL, 0),
(117, 24, 530, -3636.59, 2336.98, 95.99, NULL, 0),
(117, 25, 530, -3524.66, 2374.48, 93.09, NULL, 0),
(117, 26, 530, -3412.73, 2411.99, 90.19, NULL, 0),
(117, 27, 530, -3300.80, 2449.49, 87.30, NULL, 0),
(117, 28, 530, -3188.86, 2486.99, 84.40, NULL, 0),
(117, 29, 530, -3076.93, 2524.50, 81.50, NULL, 0),
(117, 30, 530, -2965.00, 2562.00, 78.60, 'Shadowmoon Village', 40),
(117, 31, 530, -2961.38, 2674.27, 72.59, NULL, 0),
(117, 32, 530, -2957.75, 2786.54, 66.59, NULL, 0),
(117, 33, 530, -2954.13, 2898.80, 60.58, NULL, 0),
(117, 34, 530, -2950.50, 3011.07, 54.57, NULL, 0),
(117, 35, 530, -2946.88, 3123.34, 48.57, NULL, 0),
(117, 36, 530, -2943.25, 3235.61, 42.56, NULL, 0),
(117, 37, 530, -2939.63, 3347.87, 36.55, NULL, 0),
(117, 38, 530, -2936.00, 3460.14, 30.55, NULL, 0),
(117, 39, 530, -2932.38, 3572.41, 24.54, NULL, 0),
(117, 40, 530, -2928.75, 3684.68, 18.53, NULL, 0),
(117, 41, 530, -2925.13, 3796.94, 12.52, NULL, 0),
(117, 42, 530, -2921.50, 3909.21, 6.52, NULL, 0),
(117, 43, 530, -2917.88, 4021.48, 0.51, 'Allerian Stronghold', 40),
(118, 1, 530, -708.87, 2739.13, 94.82, 'Honor Hold', 40),
(118, 2, 530, -596.40, 2723.10, 93.89, NULL, 0),
(118, 3, 530, -483.93, 2707.08, 92.95, NULL, 0),
(118, 4, 530, -371.47, 2691.05, 92.02, NULL, 0),
(118, 5, 530, -259.00, 2675.03, 91.09, NULL, 0),
(118, 6, 530, -146.53, 2659.00, 90.16, NULL, 0),
(118, 7, 530, -34.06, 2642.98, 89.23, NULL, 0),
(118, 8, 530, 78.41, 2626.95, 88.30, NULL, 0),
(118, 9, 530, 190.88, 2610.93, 87.37, 'Thrallmar', 40),
(119, 1, 530, -568.98, 4151.49, 68.22, 'Falcon Watch', 40),
(119, 2, 530, -454.96, 4177.52, 75.48, NULL, 0),
(119, 3, 530, -340.95, 4203.56, 82.75, NULL, 0),
(119, 4, 530, -226.94, 4229.59, 90.02, NULL, 0),
(119, 5, 530, -112.92, 4255.63, 97.28, NULL, 0),
(119, 6, 530, 1.09, 4281.66, 104.55, NULL, 0),
(119, 7, 530, 115.10, 4307.70, 111.82, NULL, 0),
(119, 8, 530, 229.12, 4333.73, 119.08, 'Temple of Telhamat', 40),
(119, 9, 530, 192.43, 4442.41, 110.94, NULL, 0),
(119, 10, 530, 155.74, 4551.09, 102.79, NULL, 0),
(119, 11, 530, 119.05, 4659.77, 94.65, NULL, 0),
(119, 12, 530, 82.36, 4768.45, 86.50, NULL, 0),
(119, 13, 530, 45.67, 4877.13, 78.36, NULL, 0),
(119, 14, 530, 8.97, 4985.81, 70.21, NULL, 0),
(119, 15, 530, -27.72, 5094.49, 62.07, NULL, 0),
(119, 16, 530, -64.41, 5203.17, 53.93, NULL, 0),
(119, 17, 530, -101.10, 5311.85, 45.78, NULL, 0),
(119, 18, 530, -137.79, 5420.53, 37.64, NULL, 0),
(119, 19, 530, -174.48, 5529.21, 29.49, 'Firefly Tavern', 40),
(119, 20, 530, -109.23, 5610.49, 44.22, NULL, 0),
(119, 21, 530, -43.98, 5691.77, 58.94, NULL, 0),
(119, 22, 530, 21.27, 5773.05, 73.67, NULL, 0),
(119, 23, 530, 86.52, 5854.33, 88.39, NULL, 0),
(119, 24, 530, 151.77, 5935.61, 103.12, NULL, 0),
(119, 25, 530, 217.02, 6016.89, 117.85, NULL, 0),
(119, 26, 530, 282.27, 6098.17, 132.57, 'Telredor', 40),
(119, 27, 530, 341.81, 6196.08, 125.42, NULL, 0),
(119, 28, 530, 401.36, 6293.99, 118.28, NULL, 0),
(119, 29, 530, 460.91, 6391.90, 111.13, NULL, 0),
(119, 30, 530, 520.45, 6489.81, 103.99, NULL, 0),
(119, 31, 530, 580.00, 6587.72, 96.84, NULL, 0),
(119, 32, 530, 639.55, 6685.63, 89.69, NULL, 0),
(119, 33, 530, 699.10, 6783.53, 82.55, NULL, 0),
(119, 34, 530, 758.64, 6881.44, 75.40, NULL, 0),
(119, 35, 530, 818.19, 6979.35, 68.25, NULL, 0),
(119, 36, 530, 877.74, 7077.26, 61.11, NULL, 0),
(119, 37, 530, 937.29, 7175.17, 53.96, NULL, 0),
(119, 38, 530, 996.83, 7273.08, 46.81, NULL, 0),
(119, 39, 530, 1056.38, 7370.99, 39.67, 'Orebor Harborage', 40),
(120, 1, 530, 1944.85, 5537.87, 266.73, 'Toshley''s Station', 40),
(120, 2, 530, 2021.40, 5606.69, 247.64, NULL, 0),
(120, 3, 530, 2097.94, 5675.50, 228.55, NULL, 0),
(120, 4, 530, 2174.49, 5744.31, 209.46, NULL, 0),
(120, 5, 530, 2251.04, 5813.13, 190.37, NULL, 0),
(120, 6, 530, 2327.58, 5881.94, 171.28, NULL, 0),
(120, 7, 530, 2404.13, 5950.76, 152.19, 'Thunderlord Stronghold', 40),
(120, 8, 530, 2492.62, 5877.11, 151.40, NULL, 0),
(120, 9, 530, 2581.11, 5803.45, 150.60, NULL, 0),
(120, 10, 530, 2669.60, 5729.80, 149.80, NULL, 0),
(120, 11, 530, 2758.09, 5656.14, 149.01, NULL, 0),
(120, 12, 530, 2846.58, 5582.49, 148.21, NULL, 0),
(120, 13, 530, 2935.07, 5508.83, 147.41, NULL, 0),
(120, 14, 530, 3023.56, 5435.18, 146.62, 'Evergrove', 40),
(120, 15, 530, 2935.07, 5355.48, 148.33, NULL, 0),
(120, 16, 530, 2846.58, 5275.79, 150.05, NULL, 0),
(120, 17, 530, 2758.08, 5196.09, 151.77, NULL, 0),
(120, 18, 530, 2669.59, 5116.39, 153.49, NULL, 0),
(120, 19, 530, 2581.10, 5036.70, 155.20, NULL, 0),
(120, 20, 530, 2492.61, 4957.00, 156.92, NULL, 0),
(120, 21, 530, 2404.11, 4877.30, 158.64, NULL, 0),
(120, 22, 530, 2315.62, 4797.61, 160.36, NULL, 0),
(120, 23, 530, 2227.13, 4717.91, 162.07, 'Mok''Nathal Village', 40),
(120, 24, 530, 2303.04, 4625.54, 160.30, NULL, 0),
(120, 25, 530, 2378.95, 4533.17, 158.53, NULL, 0),
(120, 26, 530, 2454.86, 4440.79, 156.75, NULL, 0),
(120, 27, 530, 2530.77, 4348.42, 154.98, NULL, 0),
(120, 28, 530, 2606.68, 4256.05, 153.21, NULL, 0),
(120, 29, 530, 2682.60, 4163.68, 151.43, NULL, 0),
(120, 30, 530, 2758.51, 4071.31, 149.66, NULL, 0),
(120, 31, 530, 2834.42, 3978.94, 147.88, NULL, 0),
(120, 32, 530, 2910.33, 3886.56, 146.11, NULL, 0),
(120, 33, 530, 2986.24, 3794.19, 144.34, NULL, 0),
(120, 34, 530, 3062.15, 3701.82, 142.56, 'Rusty Rocket Tavern', 40),
(121, 1, 530, 6788.71, -7538.12, 126.11, 'Hatchet Hills', 40),
(121, 2, 530, 6873.67, -7466.92, 122.78, NULL, 0),
(121, 3, 530, 6958.63, -7395.73, 119.44, NULL, 0),
(121, 4, 530, 7043.60, -7324.53, 116.11, NULL, 0),
(121, 5, 530, 7128.56, -7253.33, 112.78, NULL, 0),
(121, 6, 530, 7213.52, -7182.14, 109.44, NULL, 0),
(121, 7, 530, 7298.48, -7110.94, 106.11, NULL, 0),
(121, 8, 530, 7383.45, -7039.74, 102.78, NULL, 0),
(121, 9, 530, 7468.41, -6968.55, 99.44, NULL, 0),
(121, 10, 530, 7553.37, -6897.35, 96.11, 'Tranquillien', 40),
(121, 11, 530, 7668.07, -6871.45, 93.78, NULL, 0),
(121, 12, 530, 7782.77, -6845.55, 91.45, NULL, 0),
(121, 13, 530, 7897.47, -6819.65, 89.13, NULL, 0),
(121, 14, 530, 8012.17, -6793.75, 86.80, NULL, 0),
(121, 15, 530, 8126.88, -6767.85, 84.47, NULL, 0),
(121, 16, 530, 8241.58, -6741.96, 82.14, NULL, 0),
(121, 17, 530, 8356.28, -6716.06, 79.81, NULL, 0),
(121, 18, 530, 8470.98, -6690.16, 77.48, NULL, 0),
(121, 19, 530, 8585.68, -6664.26, 75.16, NULL, 0),
(121, 20, 530, 8700.38, -6638.36, 72.83, 'Fairbreeze Village', 40),
(121, 21, 530, 8811.31, -6669.91, 64.91, NULL, 0),
(121, 22, 530, 8922.25, -6701.46, 57.00, NULL, 0),
(121, 23, 530, 9033.18, -6733.01, 49.08, NULL, 0),
(121, 24, 530, 9144.11, -6764.56, 41.17, NULL, 0),
(121, 25, 530, 9255.04, -6796.11, 33.25, NULL, 0),
(121, 26, 530, 9365.98, -6827.66, 25.34, NULL, 0),
(121, 27, 530, 9476.91, -6859.21, 17.42, 'Falconwing Inn', 40),
(122, 1, 571, 439.53, -4550.71, 245.71, 'New Agamand', 40),
(122, 2, 571, 479.41, -4645.08, 189.05, NULL, 0),
(122, 3, 571, 519.29, -4739.45, 132.40, NULL, 0),
(122, 4, 571, 559.16, -4833.81, 75.74, NULL, 0),
(122, 5, 571, 599.04, -4928.18, 19.09, 'Valgarde', 40),
(123, 1, 571, 704.03, -2932.88, -2.99, 'Kamagua', 40),
(123, 2, 571, 809.98, -2980.11, 21.35, NULL, 0),
(123, 3, 571, 915.94, -3027.34, 45.69, NULL, 0),
(123, 4, 571, 1021.90, -3074.57, 70.03, NULL, 0),
(123, 5, 571, 1127.85, -3121.79, 94.37, NULL, 0),
(123, 6, 571, 1233.81, -3169.02, 118.71, NULL, 0),
(123, 7, 571, 1339.76, -3216.25, 143.05, NULL, 0),
(123, 8, 571, 1445.72, -3263.48, 167.39, 'Westguard Inn', 40),
(124, 1, 571, 1873.32, -6218.15, 13.18, 'Vengeance Landing Inn', 40),
(124, 2, 571, 1928.24, -6112.36, 37.85, NULL, 0),
(124, 3, 571, 1983.15, -6006.58, 62.51, NULL, 0),
(124, 4, 571, 2038.07, -5900.79, 87.17, NULL, 0),
(124, 5, 571, 2092.98, -5795.00, 111.83, NULL, 0),
(124, 6, 571, 2147.90, -5689.21, 136.50, NULL, 0),
(124, 7, 571, 2202.81, -5583.43, 161.16, NULL, 0),
(124, 8, 571, 2257.73, -5477.64, 185.82, NULL, 0),
(124, 9, 571, 2312.64, -5371.85, 210.48, NULL, 0),
(124, 10, 571, 2367.56, -5266.06, 235.15, NULL, 0),
(124, 11, 571, 2422.47, -5160.28, 259.81, NULL, 0),
(124, 12, 571, 2477.39, -5054.49, 284.47, 'Fort Wildervar', 40),
(124, 13, 571, 2511.48, -4943.91, 284.48, NULL, 0),
(124, 14, 571, 2545.57, -4833.32, 284.49, NULL, 0),
(124, 15, 571, 2579.66, -4722.74, 284.51, NULL, 0),
(124, 16, 571, 2613.76, -4612.15, 284.52, NULL, 0),
(124, 17, 571, 2647.85, -4501.57, 284.53, NULL, 0),
(124, 18, 571, 2681.94, -4390.98, 284.54, 'Camp Winterhoof', 40),
(124, 19, 571, 2790.44, -4404.98, 277.71, NULL, 0),
(124, 20, 571, 2898.94, -4418.98, 270.88, NULL, 0),
(124, 21, 571, 3007.45, -4432.98, 264.05, NULL, 0),
(124, 22, 571, 3115.95, -4446.98, 257.22, NULL, 0),
(124, 23, 571, 3224.45, -4460.98, 250.39, NULL, 0),
(124, 24, 571, 3332.95, -4474.99, 243.56, NULL, 0),
(124, 25, 571, 3441.45, -4488.99, 236.73, NULL, 0),
(124, 26, 571, 3549.95, -4502.99, 229.90, NULL, 0),
(124, 27, 571, 3658.46, -4516.99, 223.07, NULL, 0),
(124, 28, 571, 3766.96, -4530.99, 216.24, NULL, 0),
(124, 29, 571, 3875.46, -4544.99, 209.41, 'Camp Oneqwah', 40),
(124, 30, 571, 3978.41, -4501.03, 205.02, NULL, 0),
(124, 31, 571, 4081.37, -4457.07, 200.64, NULL, 0),
(124, 32, 571, 4184.32, -4413.11, 196.26, NULL, 0),
(124, 33, 571, 4287.28, -4369.16, 191.88, NULL, 0),
(124, 34, 571, 4390.23, -4325.20, 187.50, NULL, 0),
(124, 35, 571, 4493.19, -4281.24, 183.12, NULL, 0),
(124, 36, 571, 4596.14, -4237.28, 178.74, 'Westfall Brigade Encampment', 40),
(125, 1, 571, 2282.29, 5210.83, 12.58, 'Valiant Rest', 40),
(125, 2, 571, 2340.22, 5315.68, 20.65, NULL, 0),
(125, 3, 571, 2398.16, 5420.53, 28.73, NULL, 0),
(125, 4, 571, 2456.09, 5525.39, 36.80, NULL, 0),
(125, 5, 571, 2514.03, 5630.24, 44.87, NULL, 0),
(125, 6, 571, 2571.96, 5735.09, 52.95, NULL, 0),
(125, 7, 571, 2629.90, 5839.94, 61.02, NULL, 0),
(125, 8, 571, 2687.83, 5944.80, 69.10, NULL, 0),
(125, 9, 571, 2745.77, 6049.65, 77.17, NULL, 0),
(125, 10, 571, 2803.70, 6154.50, 85.25, 'Warsong Hold', 40),
(126, 1, 571, 2779.23, 927.02, 22.61, 'Moa''ki Harbor', 40),
(126, 2, 571, 2864.51, 854.36, 25.17, NULL, 0),
(126, 3, 571, 2949.79, 781.70, 27.73, NULL, 0),
(126, 4, 571, 3035.07, 709.03, 30.29, NULL, 0),
(126, 5, 571, 3120.35, 636.37, 32.86, NULL, 0),
(126, 6, 571, 3205.62, 563.71, 35.42, NULL, 0),
(126, 7, 571, 3290.90, 491.05, 37.98, NULL, 0),
(126, 8, 571, 3376.18, 418.39, 40.54, NULL, 0),
(126, 9, 571, 3461.46, 345.72, 43.10, NULL, 0),
(126, 10, 571, 3546.74, 273.06, 45.66, 'Wyrmrest Temple', 40),
(126, 11, 571, 3557.99, 163.03, 64.48, NULL, 0),
(126, 12, 571, 3569.23, 53.00, 83.30, NULL, 0),
(126, 13, 571, 3580.48, -57.02, 102.12, NULL, 0),
(126, 14, 571, 3591.72, -167.05, 120.94, NULL, 0),
(126, 15, 571, 3602.97, -277.08, 139.76, NULL, 0),
(126, 16, 571, 3614.21, -387.11, 158.58, NULL, 0),
(126, 17, 571, 3625.46, -497.14, 177.40, NULL, 0),
(126, 18, 571, 3636.70, -607.17, 196.22, NULL, 0),
(126, 19, 571, 3647.95, -717.20, 215.03, 'Wintergarde Keep', 40),
(126, 20, 571, 3539.50, -708.92, 203.18, NULL, 0),
(126, 21, 571, 3431.06, -700.64, 191.33, NULL, 0),
(126, 22, 571, 3322.61, -692.36, 179.47, NULL, 0),
(126, 23, 571, 3214.17, -684.08, 167.62, 'Venomspite', 40),
(127, 1, 571, 3003.71, 4052.13, 26.45, 'Unu''pe', 40),
(127, 2, 571, 3096.70, 4076.71, 24.62, NULL, 0),
(127, 3, 571, 3189.68, 4101.29, 22.78, NULL, 0),
(127, 4, 571, 3282.67, 4125.88, 20.95, NULL, 0),
(127, 5, 571, 3375.65, 4150.46, 19.11, NULL, 0),
(127, 6, 571, 3468.64, 4175.04, 17.28, 'Taunka''le Village', 40),
(127, 7, 571, 3533.17, 4275.33, 18.14, NULL, 0),
(127, 8, 571, 3597.70, 4375.62, 19.00, NULL, 0),
(127, 9, 571, 3662.23, 4475.91, 19.87, NULL, 0),
(127, 10, 571, 3726.76, 4576.20, 20.73, NULL, 0),
(127, 11, 571, 3791.29, 4676.49, 21.59, NULL, 0),
(127, 12, 571, 3855.82, 4776.77, 22.46, NULL, 0),
(127, 13, 571, 3920.35, 4877.06, 23.32, NULL, 0),
(127, 14, 571, 3984.88, 4977.35, 24.19, NULL, 0),
(127, 15, 571, 4049.41, 5077.64, 25.05, NULL, 0),
(127, 16, 571, 4113.94, 5177.93, 25.91, NULL, 0),
(127, 17, 571, 4178.47, 5278.22, 26.78, 'Fizzcrank Airstrip', 40),
(127, 18, 571, 4244.05, 5364.04, 37.74, NULL, 0),
(127, 19, 571, 4309.63, 5449.86, 48.71, NULL, 0),
(127, 20, 571, 4375.20, 5535.68, 59.67, NULL, 0),
(127, 21, 571, 4440.78, 5621.50, 70.64, NULL, 0),
(127, 22, 571, 4506.36, 5707.32, 81.60, 'Bor''gorok Outpost', 40),
(127, 23, 571, 4624.13, 5713.59, 64.19, NULL, 0),
(127, 24, 571, 4741.89, 5719.85, 46.77, NULL, 0),
(127, 25, 571, 4859.66, 5726.12, 29.36, NULL, 0),
(127, 26, 571, 4977.42, 5732.38, 11.94, NULL, 0),
(127, 27, 571, 5095.19, 5738.65, -5.48, NULL, 0),
(127, 28, 571, 5212.95, 5744.91, -22.89, NULL, 0),
(127, 29, 571, 5330.72, 5751.18, -40.31, NULL, 0),
(127, 30, 571, 5448.48, 5757.44, -57.73, NULL, 0),
(127, 31, 571, 5566.25, 5763.71, -75.14, 'Nesingwary Base Camp', 40),
(128, 1, 571, 3256.43, -2202.08, 117.11, 'Conquest Hold', 40),
(128, 2, 571, 3281.52, -2299.84, 131.19, NULL, 0),
(128, 3, 571, 3306.61, -2397.60, 145.28, NULL, 0),
(128, 4, 571, 3331.69, -2495.35, 159.36, NULL, 0),
(128, 5, 571, 3356.78, -2593.11, 173.44, NULL, 0),
(128, 6, 571, 3381.87, -2690.87, 187.52, NULL, 0),
(128, 7, 571, 3406.96, -2788.63, 201.60, 'Amberpine Lodge', 40),
(129, 1, 571, 3477.54, 2006.68, 64.95, 'Stars'' Rest', 40),
(129, 2, 571, 3536.35, 1919.82, 69.46, NULL, 0),
(129, 3, 571, 3595.15, 1832.95, 73.98, NULL, 0),
(129, 4, 571, 3653.96, 1746.09, 78.50, NULL, 0),
(129, 5, 571, 3712.76, 1659.22, 83.02, NULL, 0),
(129, 6, 571, 3771.57, 1572.36, 87.54, NULL, 0),
(129, 7, 571, 3830.37, 1485.49, 92.06, 'Agmar''s Hammer', 40),
(130, 1, 571, 5462.97, -2639.05, 306.63, 'The Argent Stand', 40),
(130, 2, 571, 5496.10, -2741.69, 315.58, NULL, 0),
(130, 3, 571, 5529.22, -2844.33, 324.52, NULL, 0),
(130, 4, 571, 5562.35, -2946.96, 333.47, NULL, 0),
(130, 5, 571, 5595.48, -3049.60, 342.41, NULL, 0),
(130, 6, 571, 5628.60, -3152.24, 351.36, NULL, 0),
(130, 7, 571, 5661.73, -3254.88, 360.30, NULL, 0),
(130, 8, 571, 5694.86, -3357.51, 369.24, NULL, 0),
(130, 9, 571, 5727.98, -3460.15, 378.19, NULL, 0),
(130, 10, 571, 5761.11, -3562.79, 387.13, 'Zim''Torga', 40),
(131, 1, 571, 6124.42, -1080.96, 402.62, 'K3', 40),
(131, 2, 571, 6185.17, -983.12, 463.56, NULL, 0),
(131, 3, 571, 6245.92, -885.27, 524.50, NULL, 0),
(131, 4, 571, 6306.67, -787.43, 585.44, NULL, 0),
(131, 5, 571, 6367.42, -689.58, 646.38, NULL, 0),
(131, 6, 571, 6428.16, -591.74, 707.32, NULL, 0),
(131, 7, 571, 6488.91, -493.89, 768.25, NULL, 0),
(131, 8, 571, 6549.66, -396.05, 829.19, NULL, 0),
(131, 9, 571, 6610.41, -298.20, 890.13, NULL, 0),
(131, 10, 571, 6671.16, -200.36, 951.07, 'Frosthold', 40),
(131, 11, 571, 6769.38, -250.23, 970.54, NULL, 0),
(131, 12, 571, 6867.61, -300.11, 990.00, NULL, 0),
(131, 13, 571, 6965.83, -349.98, 1009.47, NULL, 0),
(131, 14, 571, 7064.05, -399.86, 1028.94, NULL, 0),
(131, 15, 571, 7162.27, -449.73, 1048.40, NULL, 0),
(131, 16, 571, 7260.50, -499.61, 1067.87, NULL, 0),
(131, 17, 571, 7358.72, -549.48, 1087.34, NULL, 0),
(131, 18, 571, 7456.94, -599.36, 1106.80, NULL, 0),
(131, 19, 571, 7555.16, -649.24, 1126.27, NULL, 0),
(131, 20, 571, 7653.39, -699.11, 1145.74, NULL, 0),
(131, 21, 571, 7751.61, -748.99, 1165.20, NULL, 0),
(131, 22, 571, 7849.83, -798.86, 1184.67, 'Grom''arsh Crash-Site', 40),
(131, 23, 571, 7932.20, -735.54, 1144.93, NULL, 0),
(131, 24, 571, 8014.57, -672.21, 1105.19, NULL, 0),
(131, 25, 571, 8096.94, -608.89, 1065.45, NULL, 0),
(131, 26, 571, 8179.30, -545.56, 1025.71, NULL, 0),
(131, 27, 571, 8261.67, -482.23, 985.97, NULL, 0),
(131, 28, 571, 8344.04, -418.91, 946.23, NULL, 0),
(131, 29, 571, 8426.41, -355.58, 906.49, 'Bouldercrag''s Refuge', 40),
(132, 1, 571, 7114.15, -1633.32, 820.57, 'Brunnhildar Village', 40),
(132, 2, 571, 7166.78, -1735.91, 854.29, NULL, 0),
(132, 3, 571, 7219.41, -1838.51, 888.01, NULL, 0),
(132, 4, 571, 7272.03, -1941.10, 921.73, NULL, 0),
(132, 5, 571, 7324.66, -2043.70, 955.45, NULL, 0),
(132, 6, 571, 7377.29, -2146.29, 989.16, NULL, 0),
(132, 7, 571, 7429.92, -2248.89, 1022.88, NULL, 0),
(132, 8, 571, 7482.54, -2351.48, 1056.60, NULL, 0),
(132, 9, 571, 7535.17, -2454.08, 1090.32, NULL, 0),
(132, 10, 571, 7587.80, -2556.67, 1124.04, NULL, 0),
(132, 11, 571, 7640.43, -2659.27, 1157.76, NULL, 0),
(132, 12, 571, 7693.05, -2761.86, 1191.48, NULL, 0),
(132, 13, 571, 7745.68, -2864.46, 1225.20, NULL, 0),
(132, 14, 571, 7798.31, -2967.05, 1258.92, 'Camp Tunka''lo', 40);
INSERT INTO `world`.`lw_caravan` (`route`, `name`, `master_entry`, `kodo_entry`, `guard_entry`, `guards`, `copper_per_yard`, `pingpong`) VALUES
(100, 'The Salty Sailor Tavern - Fort Livingston Caravan', 9900300, 9900299, 93158, 2, 2, 1),
(101, 'Nethergarde Keep - Dreadmaul Hold Caravan', 9900301, 9900299, 93158, 2, 2, 1),
(102, 'Iron Summit - Fuselight-by-the-Sea Caravan', 9900302, 9900299, 93158, 2, 2, 1),
(103, 'The Farstrider Lodge - Thundermar Caravan', 9900303, 9900299, 93158, 2, 2, 1),
(104, 'Highbank - The Krazzworks Caravan', 9900304, 9900299, 93158, 2, 2, 1),
(105, 'Deepwater Tavern - Greenwarden''s Grove Caravan', 9900305, 9900299, 93158, 2, 2, 1),
(106, 'Revantusk Village - Chillwind Camp Caravan', 9900306, 9900299, 93158, 2, 2, 1),
(107, 'The Sepulcher - Forsaken Rear Guard Caravan', 9900307, 9900299, 93158, 2, 2, 1),
(108, 'Andorhal - Brill Caravan', 9900308, 9900299, 93158, 2, 2, 1),
(109, 'The Road Warrior - Speedbarge Bar Caravan', 9900309, 9900299, 93158, 2, 2, 1),
(110, 'Freewind Post - Desolation Hold Caravan', 9900310, 9900299, 93158, 2, 2, 1),
(111, 'Stonemaul Hold - Camp Ataya Caravan', 9900311, 9900299, 93158, 2, 2, 1),
(112, 'Northwatch Hold - Splintertree Post Caravan', 9900312, 9900299, 93158, 2, 2, 1),
(113, 'Camp Una''fe - Krom''gar Fortress Caravan', 9900313, 9900299, 93158, 2, 2, 1),
(114, 'Karnum''s Glade - Thal''darah Overlook Caravan', 9900314, 9900299, 93158, 2, 2, 1),
(115, 'Silverwind Refuge - Hellscream''s Watch Caravan', 9900315, 9900299, 93158, 2, 2, 1),
(116, 'Wildheart Point - Talonbranch Glade  Caravan', 9900316, 9900299, 93158, 2, 2, 1),
(117, 'Dragonmaw Base Camp - Allerian Stronghold Caravan', 9900317, 9900299, 93158, 2, 2, 1),
(118, 'Honor Hold - Thrallmar Caravan', 9900318, 9900299, 93158, 2, 2, 1),
(119, 'Falcon Watch - Orebor Harborage Caravan', 9900319, 9900299, 93158, 2, 2, 1),
(120, 'Toshley''s Station - Rusty Rocket Tavern Caravan', 9900320, 9900299, 93158, 2, 2, 1),
(121, 'Hatchet Hills - Falconwing Inn Caravan', 9900321, 9900299, 93158, 2, 2, 1),
(122, 'New Agamand - Valgarde Caravan', 9900322, 9900299, 93158, 2, 2, 1),
(123, 'Kamagua - Westguard Inn Caravan', 9900323, 9900299, 93158, 2, 2, 1),
(124, 'Vengeance Landing Inn - Westfall Brigade Encampment Caravan', 9900324, 9900299, 93158, 2, 2, 1),
(125, 'Valiant Rest - Warsong Hold Caravan', 9900325, 9900299, 93158, 2, 2, 1),
(126, 'Moa''ki Harbor - Venomspite Caravan', 9900326, 9900299, 93158, 2, 2, 1),
(127, 'Unu''pe - Nesingwary Base Camp Caravan', 9900327, 9900299, 93158, 2, 2, 1),
(128, 'Conquest Hold - Amberpine Lodge Caravan', 9900328, 9900299, 93158, 2, 2, 1),
(129, 'Stars'' Rest - Agmar''s Hammer Caravan', 9900329, 9900299, 93158, 2, 2, 1),
(130, 'The Argent Stand - Zim''Torga Caravan', 9900330, 9900299, 93158, 2, 2, 1),
(131, 'K3 - Bouldercrag''s Refuge Caravan', 9900331, 9900299, 93158, 2, 2, 1),
(132, 'Brunnhildar Village - Camp Tunka''lo Caravan', 9900332, 9900299, 93158, 2, 2, 1);
INSERT INTO `world`.`lw_patrol` (`id`, `name`, `route`, `leader_entry`, `member_entry`, `members`, `loop_route`, `camp_chance`, `camp_minutes`, `night_only`) VALUES
(100, 'The Salty Sailor Tavern - Fort Livingston Patrol', 100, 9900400, 93158, 3, 0, 3, 8, 0),
(101, 'Nethergarde Keep - Dreadmaul Hold Patrol', 101, 9900401, 93158, 3, 0, 3, 8, 0),
(102, 'Iron Summit - Fuselight-by-the-Sea Patrol', 102, 9900402, 93158, 3, 0, 3, 8, 0),
(103, 'The Farstrider Lodge - Thundermar Patrol', 103, 9900403, 1423, 3, 0, 3, 8, 0),
(104, 'Highbank - The Krazzworks Patrol', 104, 9900404, 93158, 3, 0, 3, 8, 0),
(105, 'Deepwater Tavern - Greenwarden''s Grove Patrol', 105, 9900405, 1423, 3, 0, 3, 8, 0),
(106, 'Revantusk Village - Chillwind Camp Patrol', 106, 9900406, 93158, 3, 0, 3, 8, 0),
(107, 'The Sepulcher - Forsaken Rear Guard Patrol', 107, 9900407, 9900115, 3, 0, 3, 8, 0),
(108, 'Andorhal - Brill Patrol', 108, 9900408, 93158, 3, 0, 3, 8, 0),
(109, 'The Road Warrior - Speedbarge Bar Patrol', 109, 9900409, 93158, 3, 0, 3, 8, 0),
(110, 'Freewind Post - Desolation Hold Patrol', 110, 9900410, 9900115, 3, 0, 3, 8, 0),
(111, 'Stonemaul Hold - Camp Ataya Patrol', 111, 9900411, 93158, 3, 0, 3, 8, 0),
(112, 'Northwatch Hold - Splintertree Post Patrol', 112, 9900412, 93158, 3, 0, 3, 8, 0),
(113, 'Camp Una''fe - Krom''gar Fortress Patrol', 113, 9900413, 93158, 3, 0, 3, 8, 0),
(114, 'Karnum''s Glade - Thal''darah Overlook Patrol', 114, 9900414, 9900115, 3, 0, 3, 8, 0),
(115, 'Silverwind Refuge - Hellscream''s Watch Patrol', 115, 9900415, 9900115, 3, 0, 3, 8, 0),
(116, 'Wildheart Point - Talonbranch Glade  Patrol', 116, 9900416, 93158, 3, 0, 3, 8, 0),
(117, 'Dragonmaw Base Camp - Allerian Stronghold Patrol', 117, 9900417, 93158, 3, 0, 3, 8, 0),
(118, 'Honor Hold - Thrallmar Patrol', 118, 9900418, 93158, 3, 0, 3, 8, 0),
(119, 'Falcon Watch - Orebor Harborage Patrol', 119, 9900419, 93158, 3, 0, 3, 8, 0),
(120, 'Toshley''s Station - Rusty Rocket Tavern Patrol', 120, 9900420, 93158, 3, 0, 3, 8, 0),
(121, 'Hatchet Hills - Falconwing Inn Patrol', 121, 9900421, 9900115, 3, 0, 3, 8, 0),
(122, 'New Agamand - Valgarde Patrol', 122, 9900422, 93158, 3, 0, 3, 8, 0),
(123, 'Kamagua - Westguard Inn Patrol', 123, 9900423, 93158, 3, 0, 3, 8, 0),
(124, 'Vengeance Landing Inn - Westfall Brigade Encampment Patrol', 124, 9900424, 93158, 3, 0, 3, 8, 0),
(125, 'Valiant Rest - Warsong Hold Patrol', 125, 9900425, 93158, 3, 0, 3, 8, 0),
(126, 'Moa''ki Harbor - Venomspite Patrol', 126, 9900426, 93158, 3, 0, 3, 8, 0),
(127, 'Unu''pe - Nesingwary Base Camp Patrol', 127, 9900427, 93158, 3, 0, 3, 8, 0),
(128, 'Conquest Hold - Amberpine Lodge Patrol', 128, 9900428, 93158, 3, 0, 3, 8, 0),
(129, 'Stars'' Rest - Agmar''s Hammer Patrol', 129, 9900429, 93158, 3, 0, 3, 8, 0),
(130, 'The Argent Stand - Zim''Torga Patrol', 130, 9900430, 93158, 3, 0, 3, 8, 0),
(131, 'K3 - Bouldercrag''s Refuge Patrol', 131, 9900431, 93158, 3, 0, 3, 8, 0),
(132, 'Brunnhildar Village - Camp Tunka''lo Patrol', 132, 9900432, 93158, 3, 0, 3, 8, 0);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3002400001, 9900300, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -14454.70, 498.35, 15.21, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400002, 9900400, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -12849.10, -440.99, 13.05, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400003, 9900301, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -10922.30, -3414.68, 66.58, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400004, 9900401, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -10862.70, -2677.27, 9.89, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400005, 9900302, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -7082.53, -1199.19, 323.99, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400006, 9900402, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -6624.65, -4670.51, 9.19, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400007, 9900303, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -5673.20, -4250.09, 407.09, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400008, 9900403, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3229.32, -5051.93, 120.71, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400009, 9900304, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4900.77, -6607.56, 10.92, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400010, 9900404, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2739.68, -6412.73, 242.18, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400011, 9900305, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3822.19, -830.29, 0.73, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400012, 9900405, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3229.31, -2798.98, 21.21, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400013, 9900306, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, -619.03, -4580.40, 11.77, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400014, 9900406, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 939.11, -1449.09, 63.48, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400015, 9900307, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 474.14, 1503.55, 135.60, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400016, 9900407, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1094.57, 1584.29, 28.61, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400017, 9900308, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1540.40, -1658.51, 67.99, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400018, 9900408, 0, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2282.78, 279.27, 33.49, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400019, 9900309, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -7066.17, -3851.53, 9.93, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400020, 9900409, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -6163.77, -3800.82, 6.26, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400021, 9900310, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -5469.94, -2454.68, 89.37, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400022, 9900410, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3223.69, -1666.86, 99.99, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400023, 9900311, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -4561.63, 1838.27, 87.52, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400024, 9900411, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -3100.09, 2560.18, 50.26, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400025, 9900312, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2093.83, -3501.85, 95.08, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400026, 9900412, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2338.86, -2569.99, 103.18, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400027, 9900313, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1469.14, -1908.76, 95.26, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400028, 9900413, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 874.29, -23.31, 92.76, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400029, 9900314, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, -1044.23, 1686.57, 60.22, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400030, 9900414, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2110.13, 1572.49, 343.44, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400031, 9900315, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2094.67, -1205.05, 101.88, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400032, 9900415, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3048.23, -529.09, 205.72, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400033, 9900316, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 4738.21, -863.35, 343.55, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400034, 9900416, 1, 0, 0, '0', 0, 0, 0, -1, 0, 0, 6152.55, -1953.85, 568.13, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400035, 9900317, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -5139.57, 584.33, 84.14, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400036, 9900417, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -2920.88, 4018.48, 0.51, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400037, 9900318, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -705.87, 2742.13, 94.82, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400038, 9900418, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 187.88, 2607.93, 87.37, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400039, 9900319, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, -565.98, 4154.49, 68.22, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400040, 9900419, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1053.38, 7367.99, 39.67, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400041, 9900320, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1947.85, 5540.87, 266.73, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400042, 9900420, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3059.15, 3698.82, 142.56, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400043, 9900321, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 6791.71, -7535.12, 126.11, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400044, 9900421, 530, 0, 0, '0', 0, 0, 0, -1, 0, 0, 9473.91, -6862.21, 17.42, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400045, 9900322, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 442.53, -4547.71, 245.71, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400046, 9900422, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 596.04, -4931.18, 19.09, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400047, 9900323, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 707.03, -2929.88, -2.99, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400048, 9900423, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1442.72, -3266.48, 167.39, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400049, 9900324, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 1876.32, -6215.15, 13.18, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400050, 9900424, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 4593.14, -4240.28, 178.74, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400051, 9900325, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2285.29, 5213.83, 12.58, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400052, 9900425, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2800.70, 6151.50, 85.25, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400053, 9900326, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 2782.23, 930.02, 22.61, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400054, 9900426, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3211.17, -687.08, 167.62, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400055, 9900327, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3006.71, 4055.13, 26.45, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400056, 9900427, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5563.25, 5760.71, -75.14, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400057, 9900328, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3259.43, -2199.08, 117.11, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400058, 9900428, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3403.96, -2791.63, 201.60, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400059, 9900329, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3480.54, 2009.68, 64.95, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400060, 9900429, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 3827.37, 1482.49, 92.06, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400061, 9900330, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5465.97, -2636.05, 306.63, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400062, 9900430, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 5758.11, -3565.79, 387.13, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400063, 9900331, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 6127.42, -1077.96, 402.62, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400064, 9900431, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 8423.41, -358.58, 906.49, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400065, 9900332, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 7117.15, -1630.32, 820.57, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3002400066, 9900432, 571, 0, 0, '0', 0, 0, 0, -1, 0, 0, 7795.31, -2970.05, 1258.92, 0, 120, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);
