INSERT INTO creature SELECT * FROM bak_20261020_alton_spawns;
UPDATE creature_template SET npcflag = 0 WHERE entry = 246353;
DELETE FROM creature_template_gossip WHERE CreatureID = 246353;
