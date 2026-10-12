-- =====================================================================
-- Progression (lua/progression.lua): Rebirth spells 1402200-1402204 (+3% all stats each),
-- titles 1409 "the Reborn" and 1410 "Season Champion" (hotfix push 1900190), tables for the
-- intro, rebirths, seasons, guild villages and herald news (website). Undo: progression_undo.sql
-- =====================================================================
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900190;
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell` WHERE `ID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` IN (1409, 1410);
INSERT INTO `hotfixes`.`spell_name` (`ID`, `Name`, `VerifiedBuild`) VALUES
(1402200, 'Reborn I', 69933),
(1402201, 'Reborn II', 69933),
(1402202, 'Reborn III', 69933),
(1402203, 'Reborn IV', 69933),
(1402204, 'Reborn V', 69933);
INSERT INTO `hotfixes`.`spell` (`ID`, `NameSubtext`, `Description`, `AuraDescription`, `VerifiedBuild`) VALUES
(1402200, 'Rebirth', 'Reborn hero: all stats increased by 3%.', 'Reborn hero: all stats increased by 3%.', 69933),
(1402201, 'Rebirth', 'Reborn hero: all stats increased by 3%.', 'Reborn hero: all stats increased by 3%.', 69933),
(1402202, 'Rebirth', 'Reborn hero: all stats increased by 3%.', 'Reborn hero: all stats increased by 3%.', 69933),
(1402203, 'Rebirth', 'Reborn hero: all stats increased by 3%.', 'Reborn hero: all stats increased by 3%.', 69933),
(1402204, 'Rebirth', 'Reborn hero: all stats increased by 3%.', 'Reborn hero: all stats increased by 3%.', 69933);
INSERT INTO `hotfixes`.`spell_misc` (`ID`, `Attributes1`, `Attributes2`, `Attributes3`, `Attributes4`, `Attributes5`, `Attributes6`, `Attributes7`, `Attributes8`,
  `Attributes9`, `Attributes10`, `Attributes11`, `Attributes12`, `Attributes13`, `Attributes14`, `Attributes15`, `Attributes16`, `Attributes17`,
  `DifficultyID`, `CastingTimeIndex`, `DurationIndex`, `PvPDurationIndex`, `RangeIndex`, `SchoolMask`, `Speed`, `LaunchDelay`, `MinDuration`,
  `SpellIconFileDataID`, `ActiveIconFileDataID`, `ContentTuningID`, `ShowFutureSpellPlayerConditionID`, `SpellVisualScript`, `ActiveSpellVisualScript`, `SpellID`, `VerifiedBuild`) VALUES
(1402200, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 1, 1, 0, 0, 0, 1129668, 0, 0, 0, 0, 0, 1402200, 69933),
(1402201, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 1, 1, 0, 0, 0, 1129668, 0, 0, 0, 0, 0, 1402201, 69933),
(1402202, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 1, 1, 0, 0, 0, 1129668, 0, 0, 0, 0, 0, 1402202, 69933),
(1402203, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 1, 1, 0, 0, 0, 1129668, 0, 0, 0, 0, 0, 1402203, 69933),
(1402204, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 21, 0, 1, 1, 0, 0, 0, 1129668, 0, 0, 0, 0, 0, 1402204, 69933);
INSERT INTO `hotfixes`.`spell_effect` (`ID`, `EffectAura`, `DifficultyID`, `EffectIndex`, `Effect`, `EffectAmplitude`, `EffectAttributes`, `EffectAuraPeriod`,
  `EffectBonusCoefficient`, `EffectChainAmplitude`, `EffectChainTargets`, `EffectItemType`, `EffectMechanic`, `EffectPointsPerResource`, `EffectPosFacing`,
  `EffectRealPointsPerLevel`, `EffectTriggerSpell`, `BonusCoefficientFromAP`, `PvpMultiplier`, `Coefficient`, `Variance`, `ResourceCoefficient`,
  `GroupSizeBasePointsCoefficient`, `EffectBasePoints`, `ScalingClass`, `TargetNodeGraph`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectRadiusIndex1`,
  `EffectRadiusIndex2`, `EffectSpellClassMask1`, `EffectSpellClassMask2`, `EffectSpellClassMask3`, `EffectSpellClassMask4`, `ImplicitTarget1`, `ImplicitTarget2`, `SpellID`, `VerifiedBuild`) VALUES
(1402200, 137, 0, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 3, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402200, 69933),
(1402201, 137, 0, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 3, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402201, 69933),
(1402202, 137, 0, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 3, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402202, 69933),
(1402203, 137, 0, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 3, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402203, 69933),
(1402204, 137, 0, 0, 6, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 3, 0, 0, -1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402204, 69933);
INSERT INTO `hotfixes`.`char_titles` (`ID`, `Name`, `Name1`, `MaskID`, `Flags`, `VerifiedBuild`) VALUES
(1409, '%s the Reborn', '%s the Reborn', 909, 0, 69933), (1410, '%s, Season Champion', '%s, Season Champion', 910, 0, 69933);
INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(1900190, 4100019000, 1187407512, 1402200, 1, 69933),
(1900190, 4100019001, 1187407512, 1402201, 1, 69933),
(1900190, 4100019002, 1187407512, 1402202, 1, 69933),
(1900190, 4100019003, 1187407512, 1402203, 1, 69933),
(1900190, 4100019004, 1187407512, 1402204, 1, 69933),
(1900190, 4100019005, 3776013982, 1402200, 1, 69933),
(1900190, 4100019006, 3776013982, 1402201, 1, 69933),
(1900190, 4100019007, 3776013982, 1402202, 1, 69933),
(1900190, 4100019008, 3776013982, 1402203, 1, 69933),
(1900190, 4100019009, 3776013982, 1402204, 1, 69933),
(1900190, 4100019010, 3322146344, 1402200, 1, 69933),
(1900190, 4100019011, 3322146344, 1402201, 1, 69933),
(1900190, 4100019012, 3322146344, 1402202, 1, 69933),
(1900190, 4100019013, 3322146344, 1402203, 1, 69933),
(1900190, 4100019014, 3322146344, 1402204, 1, 69933),
(1900190, 4100019015, 4030871717, 1402200, 1, 69933),
(1900190, 4100019016, 4030871717, 1402201, 1, 69933),
(1900190, 4100019017, 4030871717, 1402202, 1, 69933),
(1900190, 4100019018, 4030871717, 1402203, 1, 69933),
(1900190, 4100019019, 4030871717, 1402204, 1, 69933),
(1900190, 4100019020, 2246024846, 1409, 1, 69933),
(1900190, 4100019021, 2246024846, 1410, 1, 69933);
CREATE TABLE IF NOT EXISTS `characters`.`hero_intro` (`name` varchar(12) NOT NULL, `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `characters`.`hero_rebirth` (`name` varchar(12) NOT NULL, `count` tinyint unsigned NOT NULL DEFAULT 0, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `characters`.`season_points` (`name` varchar(12) NOT NULL, `season` int unsigned NOT NULL, `points` int unsigned NOT NULL DEFAULT 0,
  `faction` tinyint unsigned NOT NULL DEFAULT 0, PRIMARY KEY (`name`, `season`), KEY (`season`, `points`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `characters`.`season_awarded` (`season` int unsigned NOT NULL, `name` varchar(12) NOT NULL, PRIMARY KEY (`season`, `name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `world`.`guild_village` (`guild_id` int unsigned NOT NULL, `guild_name` varchar(48) NOT NULL, `area` int unsigned NOT NULL,
  `area_name` varchar(64) NOT NULL, `adopted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, `defenses` int unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`guild_id`), UNIQUE KEY (`area`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `world`.`lw_news` (`id` int unsigned NOT NULL AUTO_INCREMENT, `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text` varchar(255) NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
