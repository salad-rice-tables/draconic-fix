-- 2026-10-25 Suramar: An Elven Problem (Horde) quest wiring + phase conditions
-- Sources: warcraft.wiki.gg quest pages 40391/40632/41607/41916/43810/43812/44834/44842/44843/44844/44845
-- and Wowhead quest 40632 (objective "Meet with Khadgar in Suramar", ender 114909).

-- 40632 Take Me To Your Leader (Horde): start at Thalyssra 97140, end at Khadgar 114909.
DELETE FROM creature_queststarter WHERE quest = 40632 AND id <> 97140;
INSERT INTO creature_queststarter (id, quest) VALUES (97140, 40632) ON DUPLICATE KEY UPDATE id = VALUES(id);
DELETE FROM creature_questender WHERE quest = 40632 AND id <> 114909;
INSERT INTO creature_questender (id, quest) VALUES (114909, 40632) ON DUPLICATE KEY UPDATE id = VALUES(id);

-- 41607 Taking a Promenade (Horde): previous 40632; start and end at Rommath 114883.
UPDATE quest_template_addon SET PrevQuestID = 40632 WHERE ID = 41607;
DELETE FROM creature_queststarter WHERE quest = 41607 AND id <> 114883;
INSERT INTO creature_queststarter (id, quest) VALUES (114883, 41607) ON DUPLICATE KEY UPDATE id = VALUES(id);
DELETE FROM creature_questender WHERE quest = 41607 AND id <> 114883;
INSERT INTO creature_questender (id, quest) VALUES (114883, 41607) ON DUPLICATE KEY UPDATE id = VALUES(id);
UPDATE creature_template SET npcflag = npcflag | 2 WHERE entry = 114883;

-- 43812 Down to Business (Horde): previous 40632; start and end at Liadrin 114841.
UPDATE quest_template_addon SET PrevQuestID = 40632 WHERE ID = 43812;
DELETE FROM creature_queststarter WHERE quest = 43812 AND id <> 114841;
INSERT INTO creature_queststarter (id, quest) VALUES (114841, 43812) ON DUPLICATE KEY UPDATE id = VALUES(id);
DELETE FROM creature_questender WHERE quest = 43812 AND id <> 114841;
INSERT INTO creature_questender (id, quest) VALUES (114841, 43812) ON DUPLICATE KEY UPDATE id = VALUES(id);

-- 43810 Down to Business (Alliance): previous is Take Me To Your Leader (Alliance), not Crystal Clearing.
UPDATE quest_template_addon SET PrevQuestID = 40391 WHERE ID = 43810;

-- 40632/40391 real objective: meet Khadgar (TALKTO 114909). The client data carried a wrong kill objective.
DELETE FROM quest_objectives WHERE QuestID IN (40391, 40632);
INSERT INTO quest_objectives (ID, QuestID, Type, `Order`, StorageIndex, ObjectID, Amount, ConditionalAmount, Flags, Flags2, ProgressBarWeight, ParentObjectiveID, Visible, Description, VerifiedBuild) VALUES
(2000000403, 40391, 3, 0, 0, 114909, 1, 0, 0, 0, 0, 0, 1, 'Meet with Khadgar in Suramar', 0),
(2000000406, 40632, 3, 0, 0, 114909, 1, 0, 0, 0, 0, 0, 1, 'Meet with Khadgar in Suramar', 0);

-- Khadgar credits the TALKTO objective when the player opens gossip.
INSERT INTO smart_scripts (entryorguid, source_type, id, link, Difficulties, event_type, event_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, event_param5, event_param_string, action_type, action_param1, action_param2, action_param3, action_param4, action_param5, action_param6, action_param7, action_param_string, target_type, target_param1, target_param2, target_param3, target_param4, target_param_string, target_x, target_y, target_z, target_o, comment) VALUES
(114909, 0, 101, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 153, 0, 0, 0, 0, 0, 0, 0, '', 7, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Khadgar - gossip hello - credit TALKTO objective for 40391/40632')
ON DUPLICATE KEY UPDATE action_type = VALUES(action_type), action_param1 = VALUES(action_param1), comment = VALUES(comment);

-- A Better Future is shared: require either faction breadcrumb.
UPDATE quest_template_addon SET PrevQuestID = 0 WHERE ID = 41916;
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 19 AND SourceGroup = 0 AND SourceEntry = 41916;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(19, 0, 41916, 0, 0, 8, 0, 40391, 0, 0, '', 0, 0, 0, '', 'A Better Future - Alliance Take Me To Your Leader'),
(19, 0, 41916, 0, 1, 8, 0, 40632, 0, 0, '', 0, 0, 0, '', 'A Better Future - Horde Take Me To Your Leader');

-- Nullified is shared: require either faction Taking a Promenade.
UPDATE quest_template_addon SET PrevQuestID = 0 WHERE ID = 44834;
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 19 AND SourceGroup = 0 AND SourceEntry = 44834;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(19, 0, 44834, 0, 0, 8, 0, 44831, 0, 0, '', 0, 0, 0, '', 'Nullified - Alliance Taking a Promenade'),
(19, 0, 44834, 0, 1, 8, 0, 41607, 0, 0, '', 0, 0, 0, '', 'Nullified - Horde Taking a Promenade');

-- Crystal Clearing is shared: require either faction Taking a Promenade.
UPDATE quest_template_addon SET PrevQuestID = 0 WHERE ID = 44843;
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 19 AND SourceGroup = 0 AND SourceEntry = 44843;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(19, 0, 44843, 0, 0, 8, 0, 44831, 0, 0, '', 0, 0, 0, '', 'Crystal Clearing - Alliance Taking a Promenade'),
(19, 0, 44843, 0, 1, 8, 0, 41607, 0, 0, '', 0, 0, 0, '', 'Crystal Clearing - Horde Taking a Promenade');

-- Powering Down the Portal is shared: require either faction Taking a Promenade.
UPDATE quest_template_addon SET PrevQuestID = 0 WHERE ID = 44844;
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 19 AND SourceGroup = 0 AND SourceEntry = 44844;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(19, 0, 44844, 0, 0, 8, 0, 44831, 0, 0, '', 0, 0, 0, '', 'Powering Down the Portal - Alliance Taking a Promenade'),
(19, 0, 44844, 0, 1, 8, 0, 41607, 0, 0, '', 0, 0, 0, '', 'Powering Down the Portal - Horde Taking a Promenade');

-- Break An Arm is shared: full chapter, faction-specific Down to Business and breadcrumb.
UPDATE quest_template_addon SET PrevQuestID = 0 WHERE ID = 44845;
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 19 AND SourceGroup = 0 AND SourceEntry = 44845;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(19, 0, 44845, 0, 0, 8, 0, 41916, 0, 0, '', 0, 0, 0, '', 'Break An Arm - A Better Future'),
(19, 0, 44845, 0, 0, 8, 0, 44831, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Alliance Taking a Promenade'),
(19, 0, 44845, 0, 0, 8, 0, 43810, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Alliance Down to Business'),
(19, 0, 44845, 0, 0, 8, 0, 44843, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Crystal Clearing'),
(19, 0, 44845, 0, 0, 8, 0, 44844, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Powering Down the Portal'),
(19, 0, 44845, 0, 0, 8, 0, 44842, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Shield, Meet Spell'),
(19, 0, 44845, 0, 1, 8, 0, 41916, 0, 0, '', 0, 0, 0, '', 'Break An Arm - A Better Future'),
(19, 0, 44845, 0, 1, 8, 0, 41607, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Horde Taking a Promenade'),
(19, 0, 44845, 0, 1, 8, 0, 43812, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Horde Down to Business'),
(19, 0, 44845, 0, 1, 8, 0, 44843, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Crystal Clearing'),
(19, 0, 44845, 0, 1, 8, 0, 44844, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Powering Down the Portal'),
(19, 0, 44845, 0, 1, 8, 0, 44842, 0, 0, '', 0, 0, 0, '', 'Break An Arm - Shield, Meet Spell');

-- Phase 45536 (Khadgar meeting): keep the camp leaders visible while the breadcrumb is accepted, complete or rewarded.
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = 45536;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(26, 45536, 0, 0, 0, 47, 0, 40391, 74, 0, '', 0, 0, 0, '', 'An Elven Problem: Khadgar meeting - Alliance'),
(26, 45536, 0, 0, 1, 47, 0, 40632, 74, 0, '', 0, 0, 0, '', 'An Elven Problem: Khadgar meeting - Horde');

-- Phase 45537 (scouts in the Promenade): Horde Taking a Promenade.
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = 45537;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(26, 45537, 0, 0, 0, 47, 0, 44831, 8, 0, '', 0, 0, 0, '', 'An Elven Problem: scouts out - Alliance'),
(26, 45537, 0, 0, 1, 47, 0, 41607, 8, 0, '', 0, 0, 0, '', 'An Elven Problem: scouts out - Horde');

-- Phase 45538 (scouts back at camp): Horde Taking a Promenade.
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = 45538;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(26, 45538, 0, 0, 0, 47, 0, 44831, 66, 0, '', 0, 0, 0, '', 'An Elven Problem: scouts back - Alliance'),
(26, 45538, 0, 0, 1, 47, 0, 41607, 66, 0, '', 0, 0, 0, '', 'An Elven Problem: scouts back - Horde');

-- Phase 45544 (Down to Business defenders): Horde version.
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = 45544;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(26, 45544, 0, 0, 0, 47, 0, 43810, 10, 0, '', 0, 0, 0, '', 'An Elven Problem: Down to Business - Alliance'),
(26, 45544, 0, 0, 1, 47, 0, 43812, 10, 0, '', 0, 0, 0, '', 'An Elven Problem: Down to Business - Horde');

-- Phase 45546 (Meredil warcamp): active from the meeting onward for both factions.
DELETE FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = 45546;
INSERT INTO conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) VALUES
(26, 45546, 0, 0, 0, 47, 0, 40391, 66, 0, '', 0, 0, 0, '', 'Insurrection: Warcamp - Alliance Take Me To Your Leader'),
(26, 45546, 0, 0, 1, 47, 0, 40632, 66, 0, '', 0, 0, 0, '', 'Insurrection: Warcamp - Horde Take Me To Your Leader');
