-- 20261018_harandar_retail_only_undo.sql
-- Undo of 20261018_harandar_retail_only.sql — restores the removed custom rows from backups.

INSERT IGNORE INTO creature    SELECT * FROM backup_20261018_harandar_creature_custom;
INSERT IGNORE INTO gameobject  SELECT * FROM backup_20261018_harandar_gameobject_custom;
INSERT IGNORE INTO phase_area  SELECT * FROM backup_20261018_harandar_phase_area_custom;
