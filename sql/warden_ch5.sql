-- =====================================================================
-- Warden Campaign, Chapter 5: Fel Hunt (4 quests, Night Elf only).
-- The hunt goes wide: Satyrnaar hounds, Ashenvale bats, Jadefire lashers,
-- Felwood reavers. All custom entries (no DB reuses).
-- Chain: 95010 -> 95011 -> 95012 -> 95013 -> 95014.
-- Idempotent (DELETE + INSERT). Quests reload live, spawns need restart.
-- =====================================================================

-- --- Templates ---
DELETE FROM `world`.`creature_template` WHERE `entry` IN (95140, 95215, 95218, 95252);
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95140, 0, 0, 'Felbound Hound', NULL, 'Hound of Satyrnaar', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 3, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95215, 0, 0, 'Felwing Terror', NULL, 'Terror of the Pines', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95218, 0, 0, 'Fel Lasher', NULL, 'Rooted in Fel', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 3, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95252, 0, 0, 'Felsworn Marauder', NULL, 'Marauder of Felwood', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (95140, 95215, 95218, 95252);
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95140, 0, 1913, 1, 1, 0),
(95215, 0, 65307, 1, 1, 0),
(95218, 0, 79783, 1.2, 1, 0),
(95252, 0, 62676, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (95140, 95215, 95218, 95252);
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95140, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95215, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95218, 0, 0, 0, 2, 0, 2.0, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95252, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --- Spawns ---
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000800 AND 3001000829;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
-- Felbound Hound x6 (Satyrnaar, Ashenvale)
(3001000800, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2619.1, -2116.3, 197.3, 1.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000801, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2602.2, -2126.9, 196.6, 2.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000802, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2592.4, -2250.7, 201.6, 4.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000803, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2563.6, -2124.4, 197.4, 0.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000804, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2556.7, -2160.1, 195.6, 3.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000805, 95140, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2510.3, -2145.7, 199.5, 5.2, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Felwing Terror x6 (circling above Satyrnaar)
(3001000806, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2619.1, -2116.3, 210.0, 1.7, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000807, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2602.2, -2126.9, 209.0, 3.1, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000808, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2592.4, -2250.7, 214.0, 5.3, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000809, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2563.6, -2124.4, 210.0, 0.9, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000810, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2556.7, -2160.1, 208.0, 2.2, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000811, 95215, 1, 331, 428, '0', 0, 0, 0, -1, 0, 0, 2510.3, -2145.7, 212.0, 4.4, 40, 8, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Fel Lasher x6 (rooted, Jadefire Run)
(3001000812, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3746.8, -877.7, 321.0, 1.3, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000813, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3755.1, -838.0, 309.9, 2.7, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000814, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3796.5, -769.3, 317.6, 0.2, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000815, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3801.8, -784.5, 311.8, 4.1, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000816, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3807.7, -691.1, 344.5, 1.8, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000817, 95218, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3846.6, -747.8, 316.0, 3.6, 40, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Felsworn Marauder x6 (Felwood war-camp)
(3001000818, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 6923.1, -2274.5, 590.4, 1.1, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000819, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 7372.6, -2205.9, 536.0, 2.9, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000820, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 7347.4, -2200.1, 535.5, 4.3, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000821, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 6946.9, -2260.6, 590.8, 0.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000822, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 5957.4, -1207.8, 380.8, 3.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000823, 95252, 1, 361, 1769, '0', 0, 0, 0, -1, 0, 0, 6209.3, -1937.6, 569.1, 5.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 12: Hounds of Satyrnaar (kill 8 Felbound Hound) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95011;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95011, 2, 0, 0, 331, 0, 0, 95012, 5, 1, 0, 1, 60000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Hounds of Satyrnaar',
'Put down 8 Felbound Hounds in Satyrnaar for Warden Velarys.',
'The Avatar is fallen, but her whispers outlive her. Packs of felbound hounds now run the Satyrnaar thickets, sniffing out loyal patrols for masters yet unnamed.$b$bHunt them where they den, hunter. Eight pelts, and the thickets breathe again.',
NULL, 'The hounds hunt our patrols. Hunt them first.', 'Warden Velarys', 'Pelts for the Watch.', 'Warden Velarys',
'The thickets breathe again. But wings gather above.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95011;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95011, 0, 0, 0, 95010, 95012, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95011;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955011, 95011, 0, 0, 0, 95140, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 13: Wings Over Ashenvale (kill 8 Felwing Terror) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95012;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95012, 2, 0, 0, 331, 0, 0, 95013, 5, 1, 0, 1, 80000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Wings Over Ashenvale',
'Bring down 8 Felwing Terrors circling Satyrnaar for Warden Velarys.',
'The hounds are meat. Their masters circle above - felwing terrors, grown fat on corrupted thermals, watching every patrol path with a dozen eyes.$b$bThey cannot be stalked. They must be met in the open sky of the hunt. Bring eight of them down, hunter, and the Watch moves unseen again.',
NULL, 'Look up. That is your next enemy.', 'Warden Velarys', 'Clipped and fallen.', 'Warden Velarys',
'The sky is ours again. But the ground itself turns.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95012;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95012, 0, 0, 0, 95011, 95013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95012;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955012, 95012, 0, 0, 0, 95215, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 14: Root of Fel (kill 6 Fel Lasher in Jadefire Run) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95013;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95013, 2, 0, 0, 331, 0, 0, 95014, 5, 1, 0, 1, 100000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Root of Fel',
'Uproot 6 Fel Lashers in Jadefire Run for Warden Velarys.',
'Wings clipped. Now look down - the ground itself has turned. Where satyr fel pools the forest, the roots drink deep and rise as Fel Lashers, thorned maws that feed the corruption back into the soil.$b$bThey do not run, hunter, so you must walk into their reach and tear them out by the root. Six of them. Jadefire Run.',
NULL, 'The forest fights back now. Answer it.', 'Warden Velarys', 'Uprooted and burned.', 'Warden Velarys',
'The soil breathes again. One war-camp remains.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95013;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95013, 0, 0, 0, 95012, 95014, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95013;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955013, 95013, 0, 0, 0, 95218, 6, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 15: Reavers of Felwood (kill 8 Felsworn Marauder) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95014;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95014, 2, 0, 0, 361, 0, 0, 0, 5, 1, 0, 1, 150000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Reavers of Felwood',
'Break 8 Felsworn Marauders in their Felwood war-camp for Warden Velarys.',
'Roots torn out. Now the hand that planted them: a Felsworn war-camp squats in the grey woods of Felwood, marauders drilling for a push south into Ashenvale. No scouts, no warnings this time - just you, hunter, and eight corpses.$b$bBreak their camp. When their commanders lie dead, greater prey will show itself. It always does.',
NULL, 'No scouts. Just corpses.', 'Warden Velarys', 'The camp is broken.', 'Warden Velarys',
'The marauders are broken. But commanders remain...', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95014;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95014, 0, 0, 0, 95013, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95014;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955014, 95014, 0, 0, 0, 95252, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Giver + ender: Warden Velarys; link Ch.4 finale into Ch.5 ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95011, 95012, 95013, 95014);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95011, 0), (95113, 95012, 0), (95113, 95013, 0), (95113, 95014, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95011, 95012, 95013, 95014);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95011, 0), (95113, 95012, 0), (95113, 95013, 0), (95113, 95014, 0);

UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95011 WHERE `ID` = 95010;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95011 WHERE `ID` = 95010;

-- --- POI (UiMap 63 Ashenvale, 77 Felwood) ---
DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (95011, 95012, 95013, 95014);
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (95011, 95012, 95013, 95014);
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95011, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95011, 0, 1, 0, 955011, 95140, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95012, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95012, 0, 1, 0, 955012, 95215, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95013, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95013, 0, 1, 0, 955013, 95218, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95014, 0, 0, -1, 0, 0, 1, 77, 0, 1, 0, 0, 0, 0, 0, 0),
(95014, 0, 1, 0, 955014, 95252, 1, 77, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95011, 0, 0, 2580, -2140, 198, 0),
(95011, 1, 0, 2619.1, -2116.3, 197.3, 0),
(95011, 1, 1, 2602.2, -2126.9, 196.6, 0),
(95011, 1, 2, 2592.4, -2250.7, 201.6, 0),
(95011, 1, 3, 2563.6, -2124.4, 197.4, 0),
(95011, 1, 4, 2556.7, -2160.1, 195.6, 0),
(95011, 1, 5, 2510.3, -2145.7, 199.5, 0),
(95012, 0, 0, 2580, -2140, 210, 0),
(95012, 1, 0, 2619.1, -2116.3, 210.0, 0),
(95012, 1, 1, 2602.2, -2126.9, 209.0, 0),
(95012, 1, 2, 2592.4, -2250.7, 214.0, 0),
(95012, 1, 3, 2563.6, -2124.4, 210.0, 0),
(95012, 1, 4, 2556.7, -2160.1, 208.0, 0),
(95012, 1, 5, 2510.3, -2145.7, 212.0, 0),
(95013, 0, 0, 3800, -780, 320, 0),
(95013, 1, 0, 3746.8, -877.7, 321.0, 0),
(95013, 1, 1, 3755.1, -838.0, 309.9, 0),
(95013, 1, 2, 3796.5, -769.3, 317.6, 0),
(95013, 1, 3, 3801.8, -784.5, 311.8, 0),
(95013, 1, 4, 3807.7, -691.1, 344.5, 0),
(95013, 1, 5, 3846.6, -747.8, 316.0, 0),
(95014, 0, 0, 6600, -2100, 550, 0),
(95014, 1, 0, 6923.1, -2274.5, 590.4, 0),
(95014, 1, 1, 7372.6, -2205.9, 536.0, 0),
(95014, 1, 2, 7347.4, -2200.1, 535.5, 0),
(95014, 1, 3, 6946.9, -2260.6, 590.8, 0),
(95014, 1, 4, 5957.4, -1207.8, 380.8, 0),
(95014, 1, 5, 6209.3, -1937.6, 569.1, 0);
