-- =====================================================================
-- PROTOTYP osobnej fázy (2026-10-03): 1 mob + 1 quest, len NOVÉ ID.
-- Fáza 9511, quest 95017, tvor 95257, objektív 955017, spawn 3001000826.
-- Mechanizmus: phase_area (186 Dolanaar -> 9511) + conditions SourceType 26
-- (fáza 9511 v area 186 len ak quest 95017 aktívny: stav 8=in progress
-- alebo 2=complete, maska 10; po odovzdaní/abandone fáza zmizne).
-- Vzor: živé riadky s typom 47 (napr. fáza 169/area 5140).
-- Reštart worldservera nutný (spawny, questy, conditions, fázy).
-- Undo: 20261003_phase_prototype_undo.sql (maže LEN tieto ID).
-- =====================================================================

-- --- Fáza ---
DELETE FROM `world`.`phase_name` WHERE `ID` = 9511;
INSERT INTO `world`.`phase_name` (`ID`, `Name`) VALUES
(9511, 'Warden Campaign Prototype Phase');

DELETE FROM `world`.`phase_area` WHERE `AreaId` = 186 AND `PhaseId` = 9511;
INSERT INTO `world`.`phase_area` (`AreaId`, `PhaseId`, `Comment`) VALUES
(186, 9511, 'Warden prototype: Dolanaar sees phase 9511 (gated by conditions)');

DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` = 9511 AND `SourceEntry` = 186 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 95017;
INSERT INTO `world`.`conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(26, 9511, 186, 0, 0, 47, 0, 95017, 10, 0, '', 0, 0, 0, '', 'Warden prototype: phase 9511 in Dolanaar while quest 95017 active (8=progress,2=complete)');

-- --- Tvor: Phase Test Watcher (obyčajný sentinel model, slabý, fáza 9511) ---
DELETE FROM `world`.`creature_template` WHERE `entry` = 95257;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95257, 0, 0, 'Phase Test Watcher', NULL, 'Phase Prototype', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 95257;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95257, 0, 4849, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 95257;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95257, 0, 0, 0, 2, 0, 1.0, 1, 1, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000826);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000826, 95257, 1, 141, 186, '0', 0, 9511, 0, -1, 0, 0, 9795.0, 990.0, 1313.98, 1.6, 30, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 95017: Phase Test (kill 1, bez odmien, len Night Elf) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95017;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95017, 2, 0, 0, 141, 0, 0, 0, 5, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Phase Test',
'Find the Phase Test Watcher near Velarys in Dolanaar. (Prototype quest.)',
'This is a prototype, hunter. Take this quest and look beside the inn - something that was never there will be standing in plain sight. It exists only for you, only while you carry my mark.$b$bSlay it and return. If you abandon my mark, it will be gone as if it never was.',
NULL, '', NULL, '', NULL,
'The prototype is complete. Return to Velarys.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95017;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95017, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95017;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955017, 95017, 0, 0, 0, 95257, 1, 0, 0, 0, 0, 0, 1, NULL, 0);

DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` = 95017;
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95017, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` = 95017;
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95017, 0);
