-- Barricade #3 visibility fix (2026-10-14): visibility 0->256, respawn 0->180, mask+zone.
-- Undo: 20261014_barricade3_fix_undo.sql -- NEEDS restart
UPDATE `world`.`gameobject` SET `spawnDifficulties`='0,1,2,8,14,15,16,17,23,24,205', `zoneId`=16365, `areaId`=16793, `spawntimesecs`=180, `visibility`=256, `rotation3`=0 WHERE `guid`=990000000101200822;
