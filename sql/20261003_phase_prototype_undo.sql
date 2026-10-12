-- =====================================================================
-- UNDO k 20261003_phase_prototype.sql: maže LEN nové ID prototypu.
-- Nič pôvodné nemení ani nemazalo (prototyp len pridával).
-- Po aplikovaní: reštart worldservera.
-- =====================================================================

DELETE FROM `world`.`creature_questender` WHERE `id` = 95113 AND `quest` = 95017;
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 95113 AND `quest` = 95017;
DELETE FROM `world`.`quest_objectives` WHERE `QuestID` = 95017;
DELETE FROM `world`.`quest_template_addon` WHERE `ID` = 95017;
DELETE FROM `world`.`quest_template` WHERE `ID` = 95017;
DELETE FROM `world`.`creature` WHERE `guid` IN (3001000826);
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 95257;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 95257;
DELETE FROM `world`.`creature_template` WHERE `entry` = 95257;
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` = 9511 AND `SourceEntry` = 186 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 95017;
DELETE FROM `world`.`phase_area` WHERE `AreaId` = 186 AND `PhaseId` = 9511;
DELETE FROM `world`.`phase_name` WHERE `ID` = 9511;
