-- Ceera/Elana duplicate spawns floating at z=72 outside the bank (real ones at z=22 with Hatheon + bank areatrigger 9108384).
CREATE TABLE IF NOT EXISTS bak_20261021_creature_bankers AS SELECT * FROM creature WHERE guid IN (3000207271,3000207384);
DELETE FROM creature WHERE guid IN (3000207271,3000207384);
DELETE FROM creature_addon WHERE guid IN (3000207271,3000207384);
