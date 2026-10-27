-- Murder Row 2813: 290 spawns mask 0 = invisible (same class as 1754/2097/2993).
-- Set default mask. Undo: 20261013_dungeon_mask_2813_undo.sql. NEEDS restart.
UPDATE `world`.`creature` SET `spawnDifficulties`='0,1,2,8,14,15,16,17,23,24,205' WHERE `map`=2813 AND `spawnDifficulties`='0';
