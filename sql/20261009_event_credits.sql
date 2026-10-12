-- Event/mechanik kredity bez sablony (funguju podla ID; sablona pre konzistenciu).
-- 213070 Spare Hologem, 242966 Latent Arcana, 242968 Runestone defended, 247297 Chase.
-- Vzor: rodina 91006xx (faction 35, npcflag 3, type 9 Mechanical, SmartAI).
-- Aditivne, idempotentne.
INSERT IGNORE INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(213070, 0, 0, 'Spare Hologem used', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(242966, 0, 0, 'Latent Arcana collected', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(242968, 0, 0, 'Runestone defended', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(247297, 0, 0, 'Chase (Endurance Hunter)', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(264929, 0, 0, 'Kill Credit: Abyss Angler Achievement', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(264930, 0, 0, 'Kill Credit: Abyss Angler Sunken Treasure', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);
