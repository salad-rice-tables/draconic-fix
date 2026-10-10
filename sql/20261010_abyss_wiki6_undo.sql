-- UNDO: 20261010_abyss_wiki6.sql.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 250580 AND `source_type` = 0 AND `id` = 2 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 9100622 AND `source_type` = 0 AND `id` = 4 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`creature_text` WHERE `CreatureID` = 250580 AND `GroupID` = 1 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`creature_text` WHERE `CreatureID` = 9100622 AND `GroupID` = 1 AND `comment` LIKE '%(wiki)';
