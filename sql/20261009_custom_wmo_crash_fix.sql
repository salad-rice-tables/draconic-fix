-- Custom WMO struktury (kamilia/12dur/10dj): type 38 GARRISON_BUILDING -> 5 GENERIC
-- + nulove GeoBoxy -> +-1. Rovnaky pattern ako crashujuci stan 5084299.
-- Iba custom mena (.wmo/12dur*/10dj*), retail garrison budovy netknute.
-- Ziadna z nich nie je spawnuta (cisto /gmt-spawn-safe). Idempotentne.
UPDATE `world`.`gameobject_template` SET `type` = 5 WHERE `type` = 38 AND (`name` LIKE '%.wmo' OR `name` LIKE '12dur%' OR `name` LIKE '10dj%');
UPDATE `hotfixes`.`gameobject_display_info` di JOIN `world`.`gameobject_template` gt ON gt.displayId = di.ID SET di.GeoBoxMinX = -1, di.GeoBoxMinY = -1, di.GeoBoxMinZ = -1, di.GeoBoxMaxX = 1, di.GeoBoxMaxY = 1, di.GeoBoxMaxZ = 1 WHERE (gt.`name` LIKE '%.wmo' OR gt.`name` LIKE '12dur%' OR gt.`name` LIKE '10dj%') AND di.GeoBoxMinX = 0 AND di.GeoBoxMaxX = 0;
