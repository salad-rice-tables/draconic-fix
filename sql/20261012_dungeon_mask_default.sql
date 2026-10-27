-- Fix: instance maps 1754/2097/2993 (InstanceType 1) have mask 0 = skipped at load
-- (ObjectMgr.cpp:2223, difficulty 0 not valid for instances). Set Claude/3004 default mask
-- so spawns appear in the default (normal) instance. 81 rows. Audit 2026-10-12.
-- Undo: 20261012_dungeon_mask_default_undo.sql
UPDATE `world`.`creature` SET `spawnDifficulties`='0,1,2,8,14,15,16,17,23,24,205' WHERE `map` IN (1754,2097,2993) AND `spawnDifficulties`='0';
