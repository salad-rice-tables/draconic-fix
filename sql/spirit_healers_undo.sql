-- Undo pre spirit_healers.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3002000001 AND 3002000736;
DELETE FROM `world`.`graveyard_zone` WHERE `Comment` = 'custom: graveyard in zone';
