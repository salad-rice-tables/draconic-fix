DELETE FROM creature_queststarter WHERE quest=86842;
INSERT INTO creature_queststarter (id,quest,VerifiedBuild) VALUES (237594,86842,150895);
INSERT IGNORE INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,action_type,action_param1,target_type,comment) VALUES (241255,0,101,0,64,0,100,0,33,242627,7,'On player opened gossip - Gossip player: Give kill credit');
UPDATE creature_template SET AIName='SmartAI' WHERE entry=241255;
UPDATE creature_template_gossip SET MenuID=38571 WHERE CreatureID=240714;
UPDATE creature_template_gossip SET MenuID=37900 WHERE CreatureID=237602;
