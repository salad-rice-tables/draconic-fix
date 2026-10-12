-- Chybajuce kill-credit sablony 91006xx (shipyard Ashran), mena = objektiv texty.
-- Vzor: rodina 9100600+ (faction 35, npcflag 3, type 9 Mechanical, SmartAI).
-- Kredity funguju aj bez sablony (GrantKillCredit podla ID); sablona pre konzistenciu.
-- Aditivne, idempotentne.
INSERT IGNORE INTO `world`.`creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(9100688, 0, 0, 'Start a Naval Mission', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100689, 0, 0, 'Complete a Naval Mission', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100690, 0, 0, 'Construct a Destroyer in your Shipyard', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100692, 0, 0, 'Choose Reinforcements', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100693, 0, 0, 'Shipyard legendary mission', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100694, 0, 0, 'Explore The Molten Quarry', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100695, 0, 0, 'Explore The Road of Glory', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100696, 0, 0, 'Explore Brute\'s Rise', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100697, 0, 0, 'Explore Ashmaul Burial Grounds', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100698, 0, 0, 'Explore The Amphitheater Of Annihilation', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0),
(9100699, 0, 0, 'Ashran event credit', NULL, NULL, NULL, NULL, 0, 0, 35, 3, 1, 1.14286, 1, 0, 0, 2000, 0, 1, 1, 0, 0, 0, 0, 0, 0, 9, 0, 'SmartAI', 1, 1, 0, 0, 0, 0, 1, 0, 0, '', NULL, 0);
