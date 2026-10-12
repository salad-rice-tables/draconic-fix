-- =====================================================================
-- Legends Armory vendor (Keeper Juzan, ethereal) + stock of verified
-- iconic weapons. Armor/transmog picks per kit to be added from
-- player selections (looks cannot be curated from server DB).
-- Idempotent (DELETE + INSERT). Needs worldserver restart (spawns).
-- =====================================================================

DELETE FROM `world`.`creature_template` WHERE `entry` = 95106;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95106, 0, 0, 'Keeper Juzan', NULL, 'Hall of Legends', NULL, NULL, 0, 0, 35, 129, 1, 1.14286, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 95106;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95106, 0, 19780, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 95106;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95106, 0, 0, 0, 2, 0, 1, 1, 1, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000734);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000734, 95106, 1, 1637, 5169, '0', 0, 0, 0, -1, 0, 0, 1432.0, -4425.0, 25.45, 3.14, 60, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- Verified iconic stock (Thunderfury 13550 does NOT exist in this DB, skipped)
DELETE FROM `world`.`npc_vendor` WHERE `entry` = 95106;
INSERT INTO `world`.`npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `ExtendedCost`, `type`, `PlayerConditionID`, `IgnoreFiltering`, `VerifiedBuild`) VALUES
(95106, 1, 17182, 0, 0, 1, 0, 0, 0),
(95106, 2, 32837, 0, 0, 1, 0, 0, 0),
(95106, 3, 32838, 0, 0, 1, 0, 0, 0);
