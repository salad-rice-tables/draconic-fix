-- 86823 The Dark Horde: Blackrock Soldier (7025) spawns are phase 0; area 46 only has quest phases -> invisible. Add default phase 169.
INSERT IGNORE INTO phase_area (AreaId,PhaseId,Comment) VALUES (46,169,'Burning Steppes default phase');
