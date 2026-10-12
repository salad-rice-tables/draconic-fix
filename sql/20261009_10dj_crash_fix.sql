-- 10dj WMO struktury: type 38 (GARRISON_BUILDING) -> 5 GENERIC + nulovy GeoBox -> +-1.
-- Rovnaky model cez typ 5 funguje (4150731); 38 + nuly = crash klienta.
-- Vzor: ostatne custom sablony (4104839: -1/1/1). Idempotentne.
UPDATE `world`.`gameobject_template` SET `type` = 5 WHERE `entry` IN (5084336,5084571,5084572,5084573,5084334,5084335,5084729,5084337,5084333,5084339,5084353,5084639,5084640,5084299,5084352,5084338) AND `type` = 38;
UPDATE `hotfixes`.`gameobject_display_info` SET `GeoBoxMinX` = -1, `GeoBoxMinY` = -1, `GeoBoxMinZ` = -1, `GeoBoxMaxX` = 1, `GeoBoxMaxY` = 1, `GeoBoxMaxZ` = 1 WHERE `ID` IN (521132,521367,521368,521369,521130,521131,521525,521133,521129,521135,521149,521435,521436,521095,521148,521134) AND `GeoBoxMinX` = 0 AND `GeoBoxMaxX` = 0;
-- + zvysnych 107 nulovych GeoBoxov 10dj displayov ( rovnake pravidlo, len 10dj sablony).
UPDATE hotfixes.gameobject_display_info di JOIN world.gameobject_template gt ON gt.displayId = di.ID SET di.GeoBoxMinX = -1, di.GeoBoxMinY = -1, di.GeoBoxMinZ = -1, di.GeoBoxMaxX = 1, di.GeoBoxMaxY = 1, di.GeoBoxMaxZ = 1 WHERE gt.name LIKE '10dj%' AND di.GeoBoxMinX = 0 AND di.GeoBoxMaxX = 0;
