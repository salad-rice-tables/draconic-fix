-- =====================================================================
-- Ascension extras (lua/ascension_extra.lua): collection and saga tables, collection
-- titles (CharTitles 1407-1408, hotfix push 1900170). Undo: ascension_extra_undo.sql
-- =====================================================================
CREATE TABLE IF NOT EXISTS `characters`.`hero_collection` (
  `name` varchar(12) NOT NULL, `kind` varchar(4) NOT NULL, `milestone` smallint unsigned NOT NULL,
  PRIMARY KEY (`name`, `kind`, `milestone`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `characters`.`hero_saga` (
  `name` varchar(12) NOT NULL, `saga` tinyint unsigned NOT NULL, `step` tinyint unsigned NOT NULL, `have` smallint unsigned NOT NULL DEFAULT 0,
  `z1` int unsigned NOT NULL, `z2` int unsigned NOT NULL, `z3` int unsigned NOT NULL, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900170;
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` IN (1407, 1408);
INSERT INTO `hotfixes`.`char_titles` (`ID`, `Name`, `Name1`, `MaskID`, `Flags`, `VerifiedBuild`) VALUES
(1407, '%s the Worldforged', '%s the Worldforged', 907, 0, 69933),
(1408, '%s, Mystic Archivist', '%s, Mystic Archivist', 908, 0, 69933);
INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(1900170, 4100017000, 2246024846, 1407, 1, 69933),
(1900170, 4100017001, 2246024846, 1408, 1, 69933);
