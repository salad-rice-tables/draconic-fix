-- 86638 Choking Tendrils: kill totals exceed spawn counts -> fast respawn + extra Lasher/Hydra clones
UPDATE creature SET spawntimesecs=10 WHERE id IN (239866,240138,240129,236367,240103,236560,244533);
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,PhaseId,PhaseGroup,PhaseUseFlags,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,npcflag,unit_flags,unit_flags2,unit_flags3,ScriptName,StringId,VerifiedBuild)
SELECT 3000500840+n.i, c.id,c.map,c.zoneId,c.areaId,c.spawnDifficulties,0,0,0,0,c.equipment_id,c.position_x+n.dx,c.position_y+n.dy,c.position_z,c.orientation,10,c.wander_distance,0,100,c.MovementType,c.npcflag,c.unit_flags,c.unit_flags2,c.unit_flags3,'',NULL,c.VerifiedBuild
FROM creature c JOIN (SELECT 0 i,5 dx,5 dy UNION SELECT 1,-6,4 UNION SELECT 2,4,-6) n WHERE c.guid=3000203489;
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,PhaseId,PhaseGroup,PhaseUseFlags,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,npcflag,unit_flags,unit_flags2,unit_flags3,ScriptName,StringId,VerifiedBuild)
SELECT 3000500850+n.i, c.id,c.map,c.zoneId,c.areaId,c.spawnDifficulties,0,0,0,0,c.equipment_id,c.position_x+n.dx,c.position_y+n.dy,c.position_z,c.orientation,10,c.wander_distance,0,100,c.MovementType,c.npcflag,c.unit_flags,c.unit_flags2,c.unit_flags3,'',NULL,c.VerifiedBuild
FROM creature c JOIN (SELECT 0 i,6 dx,0 dy UNION SELECT 1,-6,0) n WHERE c.guid=3000203686;
