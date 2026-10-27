-- The lost outsider of Traditional Duties is faction specific: Alton Parsons (Alliance) / Galtra Bloodcleave (Horde).
-- The two static Alton spawns (Saptor area 11841518, Den 11841519) were visible to both factions -> removed (backup table), Eluna summons the
-- right one per player (harandar_intro.lua). Galtra gets the gossip flag and menu so she can be talked to.
CREATE TABLE IF NOT EXISTS bak_20261020_alton_spawns LIKE creature;
INSERT INTO bak_20261020_alton_spawns SELECT * FROM creature WHERE guid IN (11841518, 11841519);
DELETE FROM creature WHERE guid IN (11841518, 11841519);
UPDATE creature_template SET npcflag = 1 WHERE entry = 246353;
DELETE FROM creature_template_gossip WHERE CreatureID = 246353;
INSERT INTO creature_template_gossip (CreatureID, MenuID, VerifiedBuild) VALUES (246353, 999999999, 0);
