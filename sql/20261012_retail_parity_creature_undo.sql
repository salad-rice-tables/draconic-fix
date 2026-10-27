-- Undo for 20261012_retail_parity_creature.sql.
INSERT IGNORE INTO `world`.`creature` SELECT * FROM `world`.`backup_20261012_creature`;
