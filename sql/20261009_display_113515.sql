-- 12TR Amani door 574919: display 113515 chybal uplne. Doplneny podla listfile
-- (7035724 = world/expansion11/doodads/troll/12tr_amani_navigation_door_small01.m2).
-- GeoBox +-1 (fallback vzor custom displayov). Aditivne, idempotentne.
INSERT IGNORE INTO `hotfixes`.`gameobject_display_info` (`ID`, `GeoBoxMinX`, `GeoBoxMinY`, `GeoBoxMinZ`, `GeoBoxMaxX`, `GeoBoxMaxY`, `GeoBoxMaxZ`, `FileDataID`, `ObjectEffectPackageID`, `OverrideLootEffectScale`, `OverrideNameScale`, `AlternateDisplayType`, `ClientCreatureDisplayInfoID`, `ClientItemID`, `Unknown1100`, `VerifiedBuild`) VALUES (113515, -1, -1, -1, 1, 1, 1, 7035724, 0, 0, 0, 0, 0, 0, 0, 0);
