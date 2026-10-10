-- Diplomacy 86734: Umbric (phase 46726 spawn, guid 3001001106) looks like a Void projection like in retail: the same creature_addon aura (166452) the retail spawn 3000207639 has.
DELETE FROM `world`.`creature_addon` WHERE `guid` = 3001001106;
INSERT INTO `world`.`creature_addon` (`guid`,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`)
SELECT 3001001106,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras` FROM `world`.`creature_addon` WHERE `guid` = 3000207639;
