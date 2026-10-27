-- Isle of Quel'Danas (Midnight intro, map 2858 / zone 16182) had no graveyard: dying there sent the player to Northern Barrens.
-- No retail graveyard data available; spirit healer spot at the Silver Landing (quest hub of the intro).
DELETE FROM world_safe_locs WHERE ID = 9200013;
INSERT INTO world_safe_locs (ID, MapID, LocX, LocY, LocZ, Facing, TransportSpawnId, Comment) VALUES (9200013, 2858, 10745.0, -4252.0, 18.0, 3.2, NULL, 'Midnight - Isle of Quel''Danas - Silver Landing');
DELETE FROM graveyard_zone WHERE ID = 9200013;
INSERT INTO graveyard_zone (ID, GhostZone, Comment) VALUES (9200013, 16182, 'Isle of Quel''Danas (Midnight intro) - Silver Landing');
