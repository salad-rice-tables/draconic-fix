-- undo 20261024_movie_cinematics_import.sql
DELETE FROM cinematic_camera WHERE VerifiedBuild = 70391;
DELETE FROM cinematic_sequences WHERE VerifiedBuild = 70391;
DELETE FROM movie WHERE VerifiedBuild = 70391;
