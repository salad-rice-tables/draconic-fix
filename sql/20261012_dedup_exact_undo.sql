-- Undo for 20261012_dedup_exact.sql.
INSERT IGNORE INTO `world`.`creature` SELECT * FROM `world`.`backup_20261012_dedup_creature`;
INSERT IGNORE INTO `world`.`gameobject` SELECT * FROM `world`.`backup_20261012_dedup_gameobject`;
