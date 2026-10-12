-- =====================================================================
-- Warden campaign custom mobs: betrayer wardens (NEW entries, Maiev
-- models), NOT database reuses. Dolanaar (95114-95116) + Ashenvale
-- (95124-95126). Hostile (faction 16), humanoid.
-- Also retargets Ch.1/Ch.2 objectives + story texts to them.
-- Idempotent (DELETE + INSERT). Needs worldserver restart (spawns).
-- =====================================================================

-- --- Templates ---
DELETE FROM `world`.`creature_template` WHERE `entry` IN (95114, 95115, 95116, 95124, 95125, 95126);
INSERT INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(95114, 0, 0, 'Duskwatch Renegade', NULL, 'Oathbreaker of the Watch', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95115, 0, 0, 'Shadowfen Betrayer', NULL, 'Oathbreaker of the Watch', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95116, 0, 0, 'Talonbreaker Renegade', NULL, 'Oathbreaker of the Watch', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95124, 0, 0, 'Ashenfall Betrayer', NULL, 'Satyr-Sworn Turncloak', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95125, 0, 0, 'Pineshadow Turncloak', NULL, 'Satyr-Sworn Turncloak', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(95126, 0, 0, 'Felbriar Warden', NULL, 'Satyr-Sworn Turncloak', NULL, NULL, 0, 0, 16, 0, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 7, 0, '', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);

DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (95114, 95115, 95116, 95124, 95125, 95126);
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(95114, 0, 66480, 0.5, 1, 0),
(95115, 0, 21349, 1, 1, 0),
(95116, 0, 63393, 1, 1, 0),
(95124, 0, 20628, 1, 1, 0),
(95125, 0, 21349, 1, 1, 0),
(95126, 0, 63393, 1.05, 1, 0);

DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (95114, 95115, 95116, 95124, 95125, 95126);
INSERT INTO `world`.`creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`) VALUES
(95114, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95115, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95116, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95124, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95125, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(95126, 0, 0, 0, 2, 0, 1.5, 1, 1, 0.8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --- Spawns: Dolanaar wilds (map 1, zone 141) ---
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000736 AND 3001000760;
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES
(3001000736, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10600.6, 633.2, 1329.7, 1.5, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000737, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10651.3, 684.2, 1329.3, 3.0, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000738, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10681.2, 848.7, 1322.0, 0.5, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000739, 95114, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10633.6, 933.4, 1320.2, 4.5, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000740, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10531.5, 1065.1, 1321.4, 2.0, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000741, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10508.0, 1064.5, 1326.1, 5.0, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000742, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10482.6, 1065.9, 1327.5, 1.0, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000743, 95115, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10516.4, 1048.0, 1323.0, 3.5, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000744, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10426.0, 546.9, 1333.5, 0.8, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000745, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10432.0, 551.0, 1333.5, 2.2, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000746, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10420.0, 542.5, 1333.5, 4.0, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000747, 95116, 1, 141, 186, '0', 0, 0, 0, -1, 0, 0, 10436.0, 540.0, 1333.5, 5.5, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
-- --- Spawns: Ashenvale, Thistlefur Den (map 1, zone 331) ---
(3001000748, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3439.3, -365.0, 133.9, 1.2, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000749, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3412.7, -462.5, 160.5, 2.8, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000750, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3408.6, -328.1, 134.0, 0.3, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000751, 95124, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3387.5, -248.7, 120.9, 4.4, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000752, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3369.1, -476.6, 154.3, 1.9, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000753, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3360.7, -462.6, 154.2, 3.3, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000754, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3354.4, -303.9, 131.6, 0.9, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000755, 95125, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3341.9, -443.7, 151.5, 5.1, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000756, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3445.0, -360.0, 133.9, 2.4, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000757, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3433.0, -370.0, 133.9, 0.6, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000758, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3442.0, -358.0, 134.0, 3.8, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000759, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3436.0, -372.0, 134.0, 1.1, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1),
(3001000760, 95126, 1, 331, 412, '0', 0, 0, 0, -1, 0, 0, 3450.0, -368.0, 134.0, 4.9, 120, 5, 0, NULL, 1, NULL, NULL, NULL, NULL, '', NULL, 0, -1);

-- --- Retarget objectives to the new NPCs ---
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95114 WHERE `QuestID` = 95000;
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95115 WHERE `QuestID` = 95001;
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95116 WHERE `QuestID` = 95002;
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95124 WHERE `QuestID` = 95003;
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95125 WHERE `QuestID` = 95004;
UPDATE `world`.`quest_objectives` SET `ObjectID` = 95126 WHERE `QuestID` = 95005;

-- --- Retitle + rewrite Ch.1 texts (betrayers, not beasts) ---
UPDATE `world`.`quest_template` SET
`LogTitle` = 'The Warden\'s Summons',
`LogDescription` = 'Slay 6 Duskwatch Renegades in the woods around Dolanaar to prove yourself to Warden Velarys.',
`QuestDescription` = '$C! Another hunter of demons beneath the boughs of Teldrassil. Good. Maiev freed your kind from the Vault to bleed the Legion dry, but freedom is not trust - and trust has already been broken once.$b$bWardens of my own watch have cast aside their oaths for fel whispers. The Duskwatch Renegades skulk the thickets around Dolanaar, blades once sworn to the night now bared against it. Cut six of them down and return. Then we shall see if there is a shadow in you worth shaping.',
`QuestCompletionLog` = 'The renegades bleed like anyone. Return to Velarys in Dolanaar.'
WHERE `ID` = 95000;

UPDATE `world`.`quest_template` SET
`LogDescription` = 'Destroy 8 Shadowfen Betrayers lurking around Dolanaar for Warden Velarys.',
`QuestDescription` = 'You spill traitor blood well enough. But a warden does not charge screaming through the brush - a warden is the shadow the prey never sees. The Shadowfen Betrayers coil in the southern thickets, waiting to slit loyal throats.$b$bDo as the shadow does. Destroy eight of them, and when you return I will teach you to step through shadow itself.',
`QuestCompletionLog` = 'The shadow waits to be stepped through. Return to Velarys.'
WHERE `ID` = 95001;

UPDATE `world`.`quest_template` SET
`LogTitle` = 'Trial of Resolve',
`LogDescription` = 'Defeat 8 Talonbreaker Renegades prowling the wilds for Warden Velarys.',
`QuestDescription` = 'Shadows obey you now. But the Talonbreakers were wardens once too, and they remember every step of the dance. They hunt our patrols in pairs along the wilds, daring us to answer.$b$bAnswer them. Bring down eight, and I will teach you the warden\'s dance - to be everywhere the blade is not.',
`QuestCompletionLog` = 'Resolve must be proven in motion. Return to Velarys.'
WHERE `ID` = 95002;

-- --- Rewrite Ch.2 texts (betrayers among the furbolg, satyr-sworn) ---
UPDATE `world`.`quest_template` SET
`LogDescription` = 'Slay 8 Ashenfall Betrayers hiding in Ashenvale for Warden Velarys.',
`QuestDescription` = 'The shadows of Dolanaar obey you, but the rot runs deeper than one forest. Renegade wardens have fled east into Ashenvale, hiding among the corrupted Thistlefur and selling our patrol routes to the satyrs for fel scraps.$b$bGo into the pines. Slay eight of the Ashenfall Betrayers, and look - truly look - at what they carry. Report everything.',
`QuestCompletionLog` = 'The pines hide traitors. Return to Velarys when the betrayers fall.'
WHERE `ID` = 95003;

UPDATE `world`.`quest_template` SET
`LogDescription` = 'Kill 8 Pineshadow Turncloaks in Ashenvale for Warden Velarys.',
`QuestDescription` = 'You saw truly - the betrayers feed our movements to the Jadefire satyrs, and the Pineshadow Turncloaks are their go-betweens, walking openly where loyal blades cannot follow. They believe no blade can reach them unseen.$b$bProve them wrong. Walk into the pines and leave eight corpses. Do it without ever being seen first, and I will teach you to wear shadow as a cloak.',
`QuestCompletionLog` = 'The turncloaks whisper no more. Return to Velarys.'
WHERE `ID` = 95004;

UPDATE `world`.`quest_template` SET
`LogDescription` = 'Hunt down 10 Felbriar Wardens in Ashenvale for Warden Velarys.',
`QuestDescription` = 'The turncloaks are thinning, and their masters - the Felbriar Wardens, wardens no longer but fel-sworn butchers - now hunt YOU through the pines to avenge their kin. Good. Let them run. A warden does not chase; a warden arrives.$b$bHunt ten of the Felbriar across Ashenvale. Feel the wind answer your stride, and I will teach you to ride it as the demon hunters do.',
`QuestCompletionLog` = 'The Felbriar run. Catch them. Return to Velarys.'
WHERE `ID` = 95005;

-- --- Velarys threat-topic rewrite (betrayers, not beasts) ---
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900003;
INSERT INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES
('The Legion is broken, but its leavings fester - and worse, our own ranks fester with it. Wardens of my watch have broken their oaths for fel whispers: renegades skulk the woods of Dolanaar, and the satyr-sworn sell our patrol routes in Ashenvale. Satyrs laugh in the deep thickets, deserters of every banner prey on the weak, and the wards fail. That is our chaos, hunter - and you will cut it out blade by blade.', '', 9900003, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
