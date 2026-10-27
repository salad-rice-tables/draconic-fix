UPDATE creature_template SET npcflag = npcflag & ~1 WHERE entry = 245117;
DELETE FROM gameobject_template WHERE entry IN (9100701, 9100702);
DELETE FROM smart_scripts WHERE source_type = 0 AND ((entryorguid = 246277 AND id IN (100,101)) OR (entryorguid = 255723 AND id IN (101,102)));
INSERT INTO smart_scripts SELECT * FROM bak_20261019_harandar_sai;
DELETE FROM creature_template_gossip WHERE CreatureID = 245117;
