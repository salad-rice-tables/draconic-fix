-- =====================================================================
-- Warden Campaign, Chapter 2: Umbral Trials (3 quests, Night Elf only).
-- Giver/ender: Warden Velarys (95113, Dolanaar) sends you to Ashenvale:
-- track the corrupted Thistlefur and strike the satyrs unseen.
-- Chain: 95002 -> 95003 -> 95004 -> 95005 (prev links).
-- Rewards: Cloak of Shadows (31224), Fel Rush (195072).
-- Idempotent (DELETE + INSERT). Quests reload live (no restart needed).
-- =====================================================================

-- --- Quest 4 (overall): Whispers in the Pines (kill 8 Thistlefur Warrior) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95003;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95003, 2, 0, 0, 331, 0, 0, 95004, 5, 1, 0, 1, 15000, 0, 0, 0, 0, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Whispers in the Pines',
'Slay 8 Thistlefur Warriors in Ashenvale and look for signs of corruption.',
'The shadows of Dolanaar obey you, but the sickness runs deeper than one forest. My scouts whisper of the Thistlefur of Ashenvale - once proud furbolg, now raving, their eyes lit with green fire. Someone is pouring poison into their dens.$b$bGo east into Ashenvale. Slay eight of the corrupted warriors, and look - truly look - at what festers in their wounds. Report everything.',
NULL, '', NULL, '', NULL,
'The pines hide the rot. Return to Velarys when the warriors fall.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95003;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95003, 0, 0, 0, 95002, 95004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95003;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955003, 95003, 0, 0, 0, 33390, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 5: The Unseen Blade (kill 8 Jadefire Satyr, reward Cloak) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95004;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95004, 2, 0, 0, 331, 0, 0, 95005, 5, 1, 0, 1, 20000, 0, 0, 0, 31224, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'The Unseen Blade',
'Kill 8 Jadefire Satyrs in Ashenvale for Warden Velarys.',
'You saw truly - fel ichor in the wounds, satyr work. The Jadefire cavort through the pines, corrupting all they touch, and they believe no blade can reach them unseen.$b$bProve them wrong. Walk into their revels and leave eight corpses. Do it without ever being seen first, and I will teach you to wear shadow as a cloak.',
NULL, '', NULL, '', NULL,
'The satyrs laugh in the dark. Silence them, then return.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95004;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95004, 0, 0, 0, 95003, 95005, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95004;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955004, 95004, 0, 0, 0, 7105, 8, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Quest 6: Ride the Wind (kill 10 Thistlefur Avenger, reward Fel Rush) ---
DELETE FROM `world`.`quest_template` WHERE `ID` = 95005;
INSERT INTO `world`.`quest_template` (`ID`, `QuestType`, `QuestPackageID`, `ContentTuningID`, `QuestSortID`, `QuestInfoID`, `SuggestedGroupNum`, `RewardNextQuest`, `RewardXPDifficulty`, `RewardXPMultiplier`, `RewardMoneyDifficulty`, `RewardMoneyMultiplier`, `RewardBonusMoney`, `RewardDisplaySpell1`, `RewardDisplaySpell2`, `RewardDisplaySpell3`, `RewardSpell`, `RewardHonor`, `RewardKillHonor`, `StartItem`, `Flags`, `FlagsEx`, `FlagsEx2`, `FlagsEx3`, `AcceptedSoundKitID`, `CompleteSoundKitID`, `AreaGroupID`, `TimeAllowed`, `AllowableRaces`, `Expansion`, `ManagedWorldStateID`, `QuestSessionBonus`, `LogTitle`, `LogDescription`, `QuestDescription`, `AreaDescription`, `PortraitGiverText`, `PortraitGiverName`, `PortraitTurnInText`, `PortraitTurnInName`, `QuestCompletionLog`, `ResetByScheduler`, `VerifiedBuild`, `RewardFavor`) VALUES
(95005, 2, 0, 0, 331, 0, 0, 0, 5, 1, 0, 1, 30000, 0, 0, 0, 195072, 0, 0, 0, 540672, 0, 0, 0, 890, 878, 0, 0, 8, -2, 0, 0,
'Ride the Wind',
'Hunt down 10 Thistlefur Avengers in Ashenvale for Warden Velarys.',
'The satyrs are thinning, and their Avengers - the strongest of the corrupted - now hunt YOU through the pines to avenge their kin. Good. Let them run. A warden does not chase; a warden arrives.$b$bHunt ten of the Avengers across Ashenvale. Feel the wind answer your stride, and I will teach you to ride it as the demon hunters do.',
NULL, '', NULL, '', NULL,
'The Avengers run. Catch them. Return to Velarys.', 0, 0, 0);

DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95005;
INSERT INTO `world`.`quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `BreadcrumbForQuestId`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(95005, 0, 0, 0, 95004, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 'SmartQuest');

DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95005;
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(955005, 95005, 0, 0, 0, 3925, 10, 0, 0, 0, 0, 0, 1, NULL, 0);

-- --- Giver + ender: Warden Velarys (also link Ch.1 -> Ch.2) ---
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` IN (95003, 95004, 95005);
INSERT INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95003, 0), (95113, 95004, 0), (95113, 95005, 0);

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` IN (95003, 95004, 95005);
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(95113, 95003, 0), (95113, 95004, 0), (95113, 95005, 0);

-- Link chapter 1 finale into chapter 2 start
UPDATE `world`.`quest_template` SET `RewardNextQuest` = 95003 WHERE `ID` = 95002;
UPDATE `world`.`quest_template_addon` SET `NextQuestID` = 95003 WHERE `ID` = 95002;

-- --- Portrait dialogues (talking-head, Warden Velarys) for Ch.1 + Ch.2 ---
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'Another hunter. Good. The Watch has room for one more blade - if it proves sharp.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'Six renegades down. Perhaps there is hope for you yet.' WHERE `ID` = 95000;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'Become the shadow, or feed it.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'Unseen and unheard. The shadow accepts you.' WHERE `ID` = 95001;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'Stand still and you die. Move.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'You dance well, hunter.' WHERE `ID` = 95002;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'The pines rot from within. Find the rot.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'Traitor blood. Bring me answers, not just corpses.' WHERE `ID` = 95003;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'They laugh in the dark. Silence them.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'The dark is quiet now. As are you.' WHERE `ID` = 95004;
UPDATE `world`.`quest_template` SET `PortraitGiver` = 95113, `PortraitGiverName` = 'Warden Velarys', `PortraitGiverText` = 'Let them run. You will arrive first.', `PortraitTurnIn` = 95113, `PortraitTurnInName` = 'Warden Velarys', `PortraitTurnInText` = 'The wind itself carried you. The trials continue.' WHERE `ID` = 95005;
