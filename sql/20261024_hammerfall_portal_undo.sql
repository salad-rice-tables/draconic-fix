UPDATE gameobject SET id=570777 WHERE guid=990000000101167997;
DELETE FROM gameobject_template WHERE entry=9108871;
UPDATE creature_template SET AIName='SmartAI' WHERE entry IN (245186,247299);
UPDATE creature_template_gossip SET MenuID=38678 WHERE CreatureID IN (245186,247299);
