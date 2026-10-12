-- =====================================================================
-- Hero Classes v1 (prototyp) - tabulka stavu + NPC Hero Master.
-- Logika je v Custom/lua/hero_class.lua. Undo: hero_class_undo.sql
-- NPC 9900100 Hero Master Arvenne, spawn guid 3001000900 (Orgrimmar,
-- vedla Fortuny 95000).
-- =====================================================================

CREATE TABLE IF NOT EXISTS `characters`.`hero_class` (
  `name` varchar(24) NOT NULL,
  `path` tinyint unsigned NOT NULL DEFAULT '0',
  `hxp` int unsigned NOT NULL DEFAULT '0',
  `granted` varchar(64) NOT NULL DEFAULT '',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DELETE FROM `world`.`creature_template` WHERE `entry` = 9900100;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(9900100, 0, 0, 'Hero Master Arvenne', NULL, 'Hero Paths', NULL, NULL, 0, 0, 35, 1, 1, 1.14286, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900100;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(9900100, 0, 20628, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900100;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(9900100, 0, 0, 0, 2, 0, 1, 1, 1, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` = 3001000900;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000900, 9900100, 1, 1637, 5169, '0', 0, 0, 0, -1, 0, 0, 1437.5, -4417.5, 25.45, 3.14, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);
