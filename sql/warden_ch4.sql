-- =====================================================================
-- Warden Campaign, Chapter 4 (finale): The Avatar's Shadow (2 quests).
-- Q95019 scouting (reward Darkness) -> Q95010 kill High Betrayer Sarthis
-- (new boss 95129) -> reward Ashadar mount (spell 366962) + title
-- Vengeance Incarnate (RewardTitle 342). Turn-in portrait: Maiev herself
-- (cameo NPC 96112 in Dolanaar). NE only. Idempotent. Quests reload live.
-- =====================================================================

-- --- High Betrayer Sarthis (boss, Thistlefur Den) ---
DELETE FROM `world`.`creature_template` WHERE `entry` = 95129;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95129, 0, 0, 'High Betrayer Sarthis', NULL, 'Voice of the Dreadlord', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1.15, 1, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 95129;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95129, 0, 63393, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 95129;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95129, 0, 0, 0, 2, 0, 3.0, 1, 1, 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000798);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000798, 95129, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3439.3, -365.0, 133.9, 1.0, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Maiev Shadowsong cameo (Dolanaar, silent witness of the finale) ---
DELETE FROM `world`.`creature_template` WHERE `entry` = 96112;
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(96112, 0, 0, 'Maiev Shadowsong', NULL, 'Warden of the Watch', NULL, NULL, 0, 0, 35, 0, 1, 1.14286, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 0, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 96112;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(96112, 0, 21349, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 96112;
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(96112, 0, 0, 0, 2, 0, 1, 1, 1, 0.2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` IN (3001000799);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000799, 96112, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 9796.0, 980.0, 1313.98, 1.6, 60, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 10: Whispers of the Dreadlord (kill 10 Felsworn, reward Darkness) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95019;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95019, 2, 0, 0, 331, 0, 0, 95010, 5, 1, 0, 1, 100000, 0, 0, 0, 196718, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Whispers of the Dreadlord',
'Destroy 10 Felsworn Wardens and listen for the voice behind them.',
'The debt is settled, but the ledger is not closed. Dying turncloaks whisper one name with their last breaths - a voice that was never elven, coaxing from the dark between the pines. A dreadlord\'s whisper.$b$bDestroy ten more of the Felsworn and listen. Learn how the whisper tastes - and I will teach you to answer it with Darkness itself.',
NULL, 'Something speaks in the dark. Listen.', 'Warden Velarys', 'Now you hear it too.', 'Warden Velarys',
'The whisper has a name now. Return to Velarys.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95019;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95019, 0, 0, 0, 95018, 95010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95019;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955019, 95019, 0, 0, 0, 95128, 10, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 11 (FINALE): The Avatar's Shadow (kill Sarthis, reward Ashadar + title) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95010;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `RewardTitle`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95010, 2, 0, 0, 331, 0, 0, 0, 5, 1, 0, 1, 300000, 0, 0, 0, 366962, 0, 0, 0, 540672, 0, 0, 0, 342, 890, 878, 0, 0, 8, -2, 0, 0,
'The Avatar\'s Shadow',
'Slay High Betrayer Sarthis in Thistlefur Den and return to Dolanaar.',
'The whisper has a throat now: Sarthis, once Warden of the Western Watch, now voice of a dreadlord hiding behind her blades. She lairs at Thistlefur Den, wrapped in stolen shadows, waiting for the hunter Maiev herself could not spare.$b$bEnd her. And when you return, hunter... look who waits beside me beneath the great tree.',
NULL, 'End this, and end it as a Warden.', 'Warden Velarys', 'Kneel, hunter. Rise, Warden.', 'Maiev Shadowsong',
'The Watch has a new blade. Maiev herself witnessed it.', 0, 0, 0,
95113, 96112);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95010;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95010, 0, 0, 0, 95019, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95010;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955010, 95010, 0, 0, 0, 95129, 1, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Giver + ender: Warden Velarys; link Ch.3 finale into Ch.4 ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95019, 95010);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95019, 0), (95113, 95010, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95019, 95010);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95019, 0), (95113, 95010, 0);

UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95019 WHERE `ID` = 95018;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95019 WHERE `ID` = 95018;

-- --- POI for Ch.4 (UiMap 63) ---
DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (95019, 95010);
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (95019, 95010);
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95019, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95019, 0, 1, 0, 955019, 95128, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95010, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95010, 0, 1, 0, 955010, 95129, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95019, 0, 0, 3420, -380, 140, 0),
(95019, 1, 0, 3442.0, -363.0, 134.0, 0),
(95019, 1, 1, 3435.0, -375.0, 134.0, 0),
(95019, 1, 2, 3415.0, -460.0, 160.0, 0),
(95019, 1, 3, 3405.0, -330.0, 134.0, 0),
(95010, 0, 0, 3420, -380, 140, 0),
(95010, 1, 0, 3439.3, -365.0, 133.9, 0);
