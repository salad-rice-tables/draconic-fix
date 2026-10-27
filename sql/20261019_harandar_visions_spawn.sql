-- Forgotten Song / Forgotten Melody must not stand there from the start: Eluna (harandar_90960.lua) summons them after the Legacy Stone is used.
CREATE TABLE IF NOT EXISTS bak_20261019_harandar_visions LIKE creature;
INSERT INTO bak_20261019_harandar_visions SELECT * FROM creature WHERE guid IN (11841215, 11841218);
DELETE FROM creature WHERE guid IN (11841215, 11841218);
