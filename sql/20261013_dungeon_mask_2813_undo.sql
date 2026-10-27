-- Undo for 20261013_dungeon_mask_2813.sql.
UPDATE `world`.`creature` SET `spawnDifficulties`='0' WHERE `map`=2813 AND `spawnDifficulties`='0,1,2,8,14,15,16,17,23,24,205';
