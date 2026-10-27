-- 20261018_harandar_retail_only.sql
-- Harandar (map 2694): remove ALL custom (repack) content, keep only retail-derived rows.
-- Custom = creature/gameobject rows with guid >= 3000000000 (repack namespace)
--          + custom phase bindings (PhaseId > 30000) in phase_area for Harandar areas.
-- Retail kept: 162 creatures + 32 gameobjects (guids < 3000000000, phases 0/26037-27835/26622/26891).
-- Backups: backup_20261018_harandar_creature_custom / _gameobject_custom / _phase_area_custom
-- Undo: 20261018_harandar_retail_only_undo.sql

CREATE TABLE IF NOT EXISTS backup_20261018_harandar_creature_custom LIKE creature;
INSERT INTO backup_20261018_harandar_creature_custom
  SELECT * FROM creature WHERE map=2694 AND guid>=3000000000;

CREATE TABLE IF NOT EXISTS backup_20261018_harandar_gameobject_custom LIKE gameobject;
INSERT INTO backup_20261018_harandar_gameobject_custom
  SELECT * FROM gameobject WHERE map=2694 AND guid>=3000000000;

CREATE TABLE IF NOT EXISTS backup_20261018_harandar_phase_area_custom LIKE phase_area;
INSERT INTO backup_20261018_harandar_phase_area_custom
  SELECT * FROM phase_area
  WHERE AreaId IN (15355,15918,15919,15922,15924,15926,15928,15930,15931,15932,15934,15936,16401,16583)
    AND PhaseId>30000;

DELETE FROM creature WHERE map=2694 AND guid>=3000000000;
DELETE FROM gameobject WHERE map=2694 AND guid>=3000000000;
DELETE FROM phase_area
  WHERE AreaId IN (15355,15918,15919,15922,15924,15926,15928,15930,15931,15932,15934,15936,16401,16583)
    AND PhaseId>30000;
