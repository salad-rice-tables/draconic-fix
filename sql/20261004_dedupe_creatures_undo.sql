-- Undo pre 20261004_dedupe_creatures.sql: vrati vsetky zmazane spawny (creature_addon riadky ostali v DB).
INSERT IGNORE INTO `world`.`creature` SELECT * FROM `world`.`custom_removed_creature`;
DROP TABLE `world`.`custom_removed_creature`;
