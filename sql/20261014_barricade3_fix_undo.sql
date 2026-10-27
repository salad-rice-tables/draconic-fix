-- Undo for 20261014_barricade3_fix.sql.
UPDATE `world`.`gameobject` SET `spawnDifficulties`='0', `zoneId`=0, `areaId`=0, `spawntimesecs`=0, `visibility`=0, `rotation3`=1 WHERE `guid`=990000000101200822;
