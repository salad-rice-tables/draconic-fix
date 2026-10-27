-- 20261026_suramar_all_in_undo.sql
UPDATE gameobject_template SET Data0=1690, Data14=120364 WHERE entry IN (252776, 252779, 252783);
UPDATE creature_template SET faction=2871, npcflag=0, AIName='SmartAI' WHERE entry=113062;
DELETE FROM creature_template_gossip WHERE CreatureID=113062;
