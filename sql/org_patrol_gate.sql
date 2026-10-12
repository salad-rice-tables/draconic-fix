-- Orgrimmar gate patrol: 3 guards, loop PathId 900001
-- Revert: DELETE FROM waypoint_path_node WHERE PathId=900001;
--         DELETE FROM waypoint_path WHERE PathId=900001;
--         DELETE FROM creature_addon WHERE guid IN (3001000729,3001000730,3001000731);
--         DELETE FROM creature WHERE guid IN (3001000729,3001000730,3001000731);
INSERT INTO `waypoint_path` (`PathId`,`MoveType`,`Flags`,`Velocity`,`Comment`) VALUES
(900001,0,0,NULL,'Orgrimmar gate patrol loop (custom)');
INSERT INTO `waypoint_path_node` (`PathId`,`NodeId`,`PositionX`,`PositionY`,`PositionZ`,`Orientation`,`Delay`) VALUES
(900001,1,1384.87,-4359.69,25.76,NULL,0),
(900001,2,1411.74,-4359.85,25.41,NULL,0),
(900001,3,1424.27,-4380.05,25.40,NULL,0),
(900001,4,1438.99,-4404.04,25.39,NULL,6000),
(900001,5,1450.79,-4416.45,25.39,NULL,0),
(900001,6,1483.05,-4410.65,25.42,NULL,0),
(900001,7,1484.95,-4425.24,25.42,NULL,0),
(900001,8,1455.00,-4435.00,25.50,NULL,0);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`,`size`) VALUES
(3001000729,3296,1,1637,5170,'0',0,0,0,-1,0,0,1384.87,-4359.69,25.76,1.57,120,0,0,100,2,NULL,NULL,NULL,NULL,'','',69933,1),
(3001000730,3296,1,1637,5170,'0',0,0,0,-1,0,0,1411.74,-4359.85,25.41,1.57,120,0,0,100,2,NULL,NULL,NULL,NULL,'','',69933,1),
(3001000731,3296,1,1637,5170,'0',0,0,0,-1,0,0,1424.27,-4380.05,25.40,1.57,120,0,0,100,2,NULL,NULL,NULL,NULL,'','',69933,1);
INSERT INTO `creature_addon` (`guid`,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(3001000729,900001,0,0,0,0,0,1,0,0,0,0,0,0,NULL),
(3001000730,900001,0,0,0,0,0,1,0,0,0,0,0,0,NULL),
(3001000731,900001,0,0,0,0,0,1,0,0,0,0,0,0,NULL);
