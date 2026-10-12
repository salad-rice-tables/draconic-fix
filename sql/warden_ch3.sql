-- =====================================================================
-- Warden Campaign, Chapter 3: Hunt the Betrayers (3 quests, NE only).
-- The hunt continues in Ashenvale: turncoats, fel-sworn, and their master.
-- Chain: 95005 -> 95006 -> 95007 -> 95018.
-- Rewards: Throw Glaive (185123), Burden ensemble (203431),
-- Vengeful Retreat (198793). Idempotent. Quests reload live.
-- =====================================================================

-- --- New mobs: Duskwarden Turncoat / Felsworn Warden ---
DELETE FROM `world`.`creature_template` WHERE `entry` IN (95127, 95128);
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95127, 0, 0, 'Duskwarden Turncoat', NULL, 'Satyr-Sworn Turncloak', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95128, 0, 0, 'Felsworn Warden', NULL, 'Satyr-Sworn Turncloak', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (95127, 95128);
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95127, 0, 20628, 1, 1, 0),
(95128, 0, 21349, 1, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (95127, 95128);
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95127, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95128, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000786 AND 3001000797;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
-- Duskwarden Turncoat x6 (Jadefire Run)
(3001000786, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3750.0, -870.0, 320.0, 1.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000787, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3760.0, -845.0, 310.0, 2.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000788, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3790.0, -775.0, 317.0, 4.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000789, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3810.0, -700.0, 344.0, 0.5, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000790, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3850.0, -740.0, 316.0, 3.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000791, 95127, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3900.0, -650.0, 334.0, 5.0, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- Felsworn Warden x6 (Thistlefur Den)
(3001000792, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3442.0, -363.0, 134.0, 1.6, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000793, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3435.0, -375.0, 134.0, 3.2, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000794, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3415.0, -460.0, 160.0, 0.8, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000795, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3405.0, -330.0, 134.0, 4.7, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000796, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3390.0, -250.0, 121.0, 2.3, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000797, 95128, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3365.0, -470.0, 154.0, 0.1, 40, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Quest 7: The Turncoat Trail (kill 8 Duskwarden Turncoat, reward Throw Glaive) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95006;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95006, 2, 0, 0, 331, 0, 0, 95007, 5, 1, 0, 1, 40000, 0, 0, 0, 185123, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'The Turncoat Trail',
'Hunt 8 Duskwarden Turncoats in Jadefire Run for Warden Velarys.',
'The wind carried you well. Now follow where it points: deeper into the fel-tainted hollows of Jadefire Run, where Duskwarden Turncoats - wardens who traded their crescents for satyr promises - run messages between the corrupted dens.$b$bThey throw their glaives as we do, hunter. Take eight of them down, and their throwing art is yours to keep.',
NULL, '', NULL, '', NULL,
'Their glaives fly for the wrong mistress. Take the art for yourself.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95006;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95006, 0, 0, 0, 95005, 95007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95006;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955006, 95006, 0, 0, 0, 95127, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 8: Raiment of the Watch (kill 8 Felsworn Warden, reward Burden ensemble) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95007;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `RewardItem1`, `RewardAmount1`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95007, 2, 0, 0, 331, 0, 0, 95018, 5, 1, 0, 1, 50000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 203431, 1, 890, 878, 0, 0, 8, -2, 0, 0,
'Raiment of the Watch',
'Destroy 8 Felsworn Wardens at Thistlefur Den for Warden Velarys.',
'You throw like one of us now. But a warden is known by her raiment as much as her blade, and the Felsworn strip the honored dead of theirs. Eight of them lair at Thistlefur Den, wearing stolen crescents.$b$bStrip them back. Bring me their silence, and you shall wear the raiment of the Watch itself - every huntress will know you for what you are.',
NULL, '', NULL, '', NULL,
'Wear what you have earned. Return in the raiment.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95007;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95007, 0, 0, 0, 95006, 95018, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95007;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955007, 95007, 0, 0, 0, 95128, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 9: Debts of Shadow (kill 10 Pineshadow Turncloak, reward Vengeful Retreat) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95018;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`,
`PortraitGiver`, `PortraitTurnIn`) VALUES
(95018, 2, 0, 0, 331, 0, 0, 0, 5, 1, 0, 1, 60000, 0, 0, 0, 198793, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Debts of Shadow',
'Settle with 10 Pineshadow Turncloaks in Jadefire Run for Warden Velarys.',
'The raiment suits you, hunter. But the debt is not settled - the Pineshadow Turncloaks you bloodied in Jadefire Run have put a price on every loyal head in Ashenvale, yours first among them.$b$bThey are hunting you. Let them come, and teach them the last lesson of the Watch: strike, vanish, and never be where vengeance lands.',
NULL, 'Debts come due in shadow.', 'Warden Velarys', 'Paid in full, hunter.', 'Warden Velarys',
'The debt is settled. Something greater stirs - return to Velarys.', 0, 0, 0,
95113, 95113);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95018;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95018, 0, 0, 0, 95007, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95018;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955018, 95018, 0, 0, 0, 95125, 10, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Portraits for Ch.3 (Velarys) ---
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'They throw as we do. Take the art for yourself.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'Well thrown, hunter.' WHERE `ID` = 95006;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'Strip them back. Wear what you earn.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'The raiment knows its own.' WHERE `ID` = 95007;

-- --- Giver + ender: Warden Velarys ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95006, 95007, 95018);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95006, 0), (95113, 95007, 0), (95113, 95018, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95006, 95007, 95018);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95006, 0), (95113, 95007, 0), (95113, 95018, 0);

-- --- POI for Ch.3 (UiMap 63) ---
DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (95006, 95007, 95018);
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (95006, 95007, 95018);
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95006, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95006, 0, 1, 0, 955006, 95127, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95007, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95007, 0, 1, 0, 955007, 95128, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95018, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95018, 0, 1, 0, 955018, 95125, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95006, 0, 0, 3800, -780, 320, 0),
(95006, 1, 0, 3750.0, -870.0, 320.0, 0),
(95006, 1, 1, 3760.0, -845.0, 310.0, 0),
(95006, 1, 2, 3790.0, -775.0, 317.0, 0),
(95006, 1, 3, 3810.0, -700.0, 344.0, 0),
(95006, 1, 4, 3850.0, -740.0, 316.0, 0),
(95006, 1, 5, 3900.0, -650.0, 334.0, 0),
(95007, 0, 0, 3420, -380, 140, 0),
(95007, 1, 0, 3442.0, -363.0, 134.0, 0),
(95007, 1, 1, 3435.0, -375.0, 134.0, 0),
(95007, 1, 2, 3415.0, -460.0, 160.0, 0),
(95007, 1, 3, 3405.0, -330.0, 134.0, 0),
(95007, 1, 4, 3390.0, -250.0, 121.0, 0),
(95007, 1, 5, 3365.0, -470.0, 154.0, 0),
(95018, 0, 0, 3800, -780, 320, 0),
(95018, 1, 0, 3746.8, -877.7, 321.0, 0),
(95018, 1, 1, 3755.1, -838.0, 309.9, 0),
(95018, 1, 2, 3796.5, -769.3, 317.6, 0),
(95018, 1, 3, 3801.8, -784.5, 311.8, 0),
(95018, 1, 4, 3807.7, -691.1, 344.5, 0),
(95018, 1, 5, 3846.6, -747.8, 316.0, 0);

-- --- Link Ch.2 finale into Ch.3 ---
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95006 WHERE `ID` = 95005;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95006 WHERE `ID` = 95005;
