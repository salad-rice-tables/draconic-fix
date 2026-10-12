-- Undo pre hero_class.sql (Hero Classes v1).
-- Pozn.: naucene spelly hracom ostanu; pred undo ich odober cez NPC (Abandon path).
DELETE FROM `world`.`creature` WHERE `guid` = 3001000900;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 9900100;
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 9900100;
DELETE FROM `world`.`creature_template` WHERE `entry` = 9900100;
DROP TABLE IF EXISTS `characters`.`hero_class`;
