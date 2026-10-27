-- Scarlet Halls (map 2857): area 16170 has quest phases only -> phase-0 spawns (all Scarlet mobs) invisible. Add default phase 169.
INSERT IGNORE INTO phase_area (AreaId,PhaseId,Comment) VALUES (16170,169,'Scarlet Halls default phase (Arator journey)'),(16171,169,'Huntsmans Cloister default phase'),(16172,169,'Training Grounds default phase');
-- 86843 needs 20/20/20/34 kills but only 10/6/3/10 spawns -> quicker respawn (front-line feel)
UPDATE creature SET spawntimesecs=30 WHERE map=2857 AND id IN (237801,237802,237782,237772);
