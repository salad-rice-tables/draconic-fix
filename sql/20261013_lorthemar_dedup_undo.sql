-- Undo for 20261013_lorthemar_dedup.sql.
INSERT IGNORE INTO `world`.`creature` SELECT * FROM `world`.`backup_20261013_lorthemar_dedup`;
