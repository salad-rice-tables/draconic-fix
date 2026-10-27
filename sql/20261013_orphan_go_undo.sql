-- Undo for 20261013_orphan_go.sql.
INSERT IGNORE INTO `world`.`gameobject` SELECT * FROM `world`.`backup_20261013_orphan_go`;
