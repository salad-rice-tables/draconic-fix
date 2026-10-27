-- Undo for 20261013_tdb_gap_import.sql.
DELETE w FROM `world`.`creature` w JOIN `world`.`backup_20261013_gap_creature` i ON i.guid=w.guid;
DELETE w FROM `world`.`gameobject` w JOIN `world`.`backup_20261013_gap_gameobject` i ON i.guid=w.guid;
