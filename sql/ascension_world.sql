-- =====================================================================
-- Ascension world systems (lua/ascension_world.lua): Lost Satchel object for
-- High-Risk deaths and the daily bounty table. Bounty Master NPCs are in
-- mystic_altars.sql. Undo: ascension_world_undo.sql
-- =====================================================================
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 9709998;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9709998, 10, 323, 'Lost Satchel', 'Interact', '', '', 1, 0);
CREATE TABLE IF NOT EXISTS `characters`.`hero_bounty` (
  `name` varchar(12) NOT NULL, `day` date NOT NULL, `slot` tinyint unsigned NOT NULL,
  `kind` varchar(12) NOT NULL, `need` smallint unsigned NOT NULL, `have` smallint unsigned NOT NULL DEFAULT 0,
  `claimed` tinyint unsigned NOT NULL DEFAULT 0, PRIMARY KEY (`name`, `day`, `slot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
