-- Undo pre lw_npcs.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000901 AND 3001000960;
UPDATE `world`.`lw_patrol` SET `member_entry` = 3296 WHERE `id` IN (1, 2);
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900115, 9900116, 9900120, 9900121, 9900122);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900115, 9900116, 9900120, 9900121, 9900122);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900115, 9900116, 9900120, 9900121, 9900122);
