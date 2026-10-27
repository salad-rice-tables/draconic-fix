-- Undo for 20261014_rebake.sql.
INSERT IGNORE INTO `world`.`creature` SELECT * FROM `world`.`backup_20261014_rebake`;
