-- =====================================================================
-- Warden Campaign, Chapter 1: The Release (3 quests, Night Elf only).
-- LORE: Wardens belong to kaldorei lands - giver is Warden Velarys
-- in Dolanaar, Teldrassil (next to the inn). Kaelis stays a vendor
-- in Orgrimmar (npcflag reverted to gossip+vendor).
-- Chain: 95000 -> 95001 -> 95002. Spell rewards are native.
-- Idempotent (DELETE + INSERT). Needs worldserver restart (spawns).
-- NOTE: objectives/texts below are the ORIGINAL Durotar version.
-- The current betrayer version is applied ON TOP by
-- warden_custom_mobs.sql + warden_density.sql + warden_felsong.sql
-- (apply in that order; never re-apply this file alone afterwards).
-- =====================================================================

-- Kaelis back to vendor-only (was 131 with quests, now 129)
UPDATE `world`.`creature_template` SET `npcflag` = 129 WHERE `entry` = 95104;
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95104 AND `quest` IN (95000, 95001, 95002);
DELETE FROM `world`.`creature_questender` WHERE `id` = 95104 AND `quest` IN (95000, 95001, 95002);

-- --- Warden Velarys, Dolanaar (by the inn) ---
DELETE FROM `world`.`creature_template` WHERE `entry` = 95113;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95113, 0, 0, 'Warden Velarys', NULL, 'Watcher of Dolanaar', NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 95113;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95113, 0, 20628, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 95113;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95113, 0, 0, 0, 2, 0, 1, 1, 1, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000735);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000735, 95113, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9799.8, 984.2, 1313.98, 4.8, 60, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 1: The Warden's Summons (kill 6 Grellkin) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95000;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95000, 2, 0, 0, 141, 0, 0, 95001, 5, 1, 0, 1, 2000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'The Warden\'s Summons',
'Cull 6 Grellkin in the forests around Dolanaar to prove yourself to Warden Velarys.',
'$C! Another hunter of demons beneath the boughs of Teldrassil. Good. Maiev freed your kind from the Vault to bleed the Legion dry, but freedom is not trust. The Wardens have watched these woods since before your first hunt.$b$bIf you would walk the warden\'s path, first show me you can hunt. The grellkin infest the thickets around Dolanaar, bold and spiteful. Cull six of them and return. Then we shall see if there is a shadow in you worth shaping.',
NULL, '', NULL, '', NULL,
'The warden waits beneath the great tree. Return to Velarys in Dolanaar.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95000;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95000, 0, 0, 0, 0, 95001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95000;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955000, 95000, 0, 0, 0, 1989, 6, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 2: First Trial of Shadows (kill 8 Timberling, reward Shadowstep) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95001;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95001, 2, 0, 0, 141, 0, 0, 95002, 5, 1, 0, 1, 5000, 0, 0, 0, 36554, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'First Trial of Shadows',
'Destroy 8 Timberlings in the groves around Dolanaar for Warden Velarys.',
'You spill blood well enough. But a warden does not charge screaming through the brush - a warden is the shadow the prey never sees. The timberlings walk the groves as living bark, slow and unseeing.$b$bDo as the shadow does. Destroy eight of them, and when you return I will teach you to step through shadow itself.',
NULL, '', NULL, '', NULL,
'The shadow waits to be stepped through. Return to Velarys.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95001;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95001, 0, 0, 0, 95000, 95002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95001;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955001, 95001, 0, 0, 0, 2022, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 3: Trial of the Talon (kill 8 Strigid Screecher, reward Evasion) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95002;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95002, 2, 0, 0, 141, 0, 0, 0, 5, 1, 0, 1, 10000, 0, 0, 0, 5277, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Trial of the Talon',
'Defeat 8 Strigid Screechers wheeling above Dolanaar for Warden Velarys.',
'Shadows obey you now. But the strigids hunt from a sky you cannot step through, and their talons find hunters who stand still to admire their own footwork.$b$bWhen the talons fall, do not be where they land. Bring down eight of the screechers, and I will teach you the warden\'s dance - to be everywhere the blade is not.',
NULL, '', NULL, '', NULL,
'Evasion must be learned in motion. Return to Velarys.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95002;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95002, 0, 0, 0, 95001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95002;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955002, 95002, 0, 0, 0, 1996, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Giver + ender: Warden Velarys ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95000, 95001, 95002);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95000, 0), (95113, 95001, 0), (95113, 95002, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95000, 95001, 95002);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95000, 0), (95113, 95001, 0), (95113, 95002, 0);
