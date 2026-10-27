-- Undo for 20261012_retail_parity_gameobject.sql.
INSERT IGNORE INTO `world`.`gameobject` SELECT * FROM `world`.`backup_20261012_gameobject`;
