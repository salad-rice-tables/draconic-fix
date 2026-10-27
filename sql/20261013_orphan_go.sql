-- Orphan GO cleanup (2026-10-13): spawns whose template exists in NO table
-- (world/TDB-full/hotfixes). Client cannot render them. 13 rows.
-- Backup: world.backup_20261013_orphan_go. Undo: 20261013_orphan_go_undo.sql
DELETE FROM `world`.`gameobject` WHERE `guid` IN (500063,10000338,10000344,10000360,10000396,10001544,10001554,10001575,10001581,10001589,10001599,10001600,10001617);
