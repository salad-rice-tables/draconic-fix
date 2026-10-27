-- Lady Liadrin 237278 (Sunwell, Broken Sun end / Light's Last Stand start) had faction 1665 (hostile PvP faction): she could be selected but not interacted with.
-- Same as her other spawns: faction 35 (friendly to all).
CREATE TABLE IF NOT EXISTS bak_20261021_ct_237278 LIKE creature_template;
INSERT INTO bak_20261021_ct_237278 SELECT * FROM creature_template WHERE entry=237278 AND entry NOT IN (SELECT entry FROM bak_20261021_ct_237278);
UPDATE creature_template SET faction = 35 WHERE entry = 237278;
