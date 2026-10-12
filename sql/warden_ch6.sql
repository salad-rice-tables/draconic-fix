-- =====================================================================
-- Warden Campaign, Chapter 6: Commanders of Fel (2 boss quests, NE only).
-- Fel Commander Urgoz waits on Mardum; the Felborne Overfiend descends
-- on Jadefire Run. Finale grants the Demonslayer title (MaskID 367).
-- Chain: 95014 -> 95015 -> 95016. Idempotent. Spawns need restart.
-- =====================================================================

-- --- Templates ---
DELETE FROM `world`.`creature_template` WHERE `entry` IN (95287, 95293);
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95287, 0, 0, 'Fel Commander Urgoz', NULL, 'Commander of the Mardum Remnant', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1.1, 1, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95293, 0, 0, 'Felborne Overfiend', NULL, 'Terror of Jadefire', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1.2, 1, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (95287, 95293);
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95287, 0, 18526, 1, 1, 0),
(95293, 0, 61981, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (95287, 95293);
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95287, 0, 0, 0, 2, 0, 5.0, 1, 1, 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95293, 0, 0, 0, 2, 0, 8.0, 1, 1, 1.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000824, 3001000825);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000824, 95287, 1481, 7705, 7705, '0', 0, 0, 0, -1, 0, 0, 1184.0, 3232.7, 58.8, 1.0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000825, 95293, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3820.0, -730.0, 330.0, 3.0, 600, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 16: The Commander's Head (kill Urgoz on Mardum) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95015;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95015, 2, 0, 0, 1481, 0, 0, 95016, 5, 1, 0, 1, 200000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'The Commander\'s Head',
'Slay Fel Commander Urgoz on Mardum and bring proof to Warden Velarys.',
'The marauders talked before they died - of a commander rallying the Mardum remnant, drilling a broken Legion back into an army. Fel Commander Urgoz. A name from the invasion, hunter, and one you will know well.$b$bGo to Mardum, where your own hated kin once bled. Take his head. The Watch pays in gold and remembers in song.',
NULL, 'Mardum calls you home, hunter.', 'Warden Velarys', 'One commander fewer.', 'Warden Velarys',
'Urgoz is fallen. But something worse heard the blow land.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95015;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95015, 0, 0, 0, 95014, 95016, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95015;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955015, 95015, 0, 0, 0, 95287, 1, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 17 (FINALE): Fall of the Overfiend (kill Overfiend, title Demonslayer) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95016;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `RewardTitle`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95016, 2, 0, 0, 331, 0, 0, 0, 5, 1, 0, 1, 500000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 367, 890, 878, 0, 0, 8, -2, 0, 0,
'Fall of the Overfiend',
'Destroy the Felborne Overfiend looming over Jadefire Run.',
'Urgoz is dead - and something heard it. Above Jadefire Run the sky has torn open a second time, and through it came the thing the turncloaks prayed to: a Felborne Overfiend, vast and burning, come to finish what the Legion started.$b$bThis is the last hunt I will ever ask of you, hunter. End it, and no demon in any world will ever again hear your name without fear.',
NULL, 'End this, and end it forever.', 'Warden Velarys', 'Demonslayer. Let the name be enough.', 'Warden Velarys',
'The Overfiend is fallen. The Watch endures.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95016;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95016, 0, 0, 0, 95015, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95016;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955016, 95016, 0, 0, 0, 95293, 1, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Giver + ender: Warden Velarys; link Ch.5 finale into Ch.6 ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95015, 95016);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95015, 0), (95113, 95016, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95015, 95016);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95015, 0), (95113, 95016, 0);

UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95015 WHERE `ID` = 95014;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95015 WHERE `ID` = 95014;

-- --- POI (Mardum UiMap 672, Ashenvale 63) ---
DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (95015, 95016);
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (95015, 95016);
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95015, 0, 0, -1, 0, 0, 1481, 672, 0, 1, 0, 0, 0, 0, 0, 0),
(95015, 0, 1, 0, 955015, 95287, 1481, 672, 0, 7, 0, 0, 0, 0, 0, 0),
(95016, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95016, 0, 1, 0, 955016, 95293, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95015, 0, 0, 1184, 3233, 59, 0),
(95015, 1, 0, 1184.0, 3232.7, 58.8, 0),
(95016, 0, 0, 3820, -730, 330, 0),
(95016, 1, 0, 3820.0, -730.0, 330.0, 0);

-- --- Boss taunts ---
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (95287, 95293) AND `source_type` = 0 AND `id` IN (0, 1);
INSERT INTO `world`.`smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param7`, `action_param_string`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(95287, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Urgoz - On Aggro - Yell'),
(95287, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Urgoz - On Death - Yell'),
(95293, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Overfiend - On Aggro - Yell'),
(95293, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Overfiend - On Death - Yell');

DELETE FROM `world`.`creature_text` WHERE `CreatureID` IN (95287, 95293) AND `GroupID` IN (0, 1);
INSERT INTO `world`.`creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(95287, 0, 0, 'I drilled armies before your world had a name!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Urgoz aggro'),
(95287, 1, 0, 'The Legion... does not... end...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Urgoz death'),
(95293, 0, 0, 'I AM THE END OF YOUR WATCH!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Overfiend aggro'),
(95293, 1, 0, 'Impossible... slain... by prey...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Overfiend death');
