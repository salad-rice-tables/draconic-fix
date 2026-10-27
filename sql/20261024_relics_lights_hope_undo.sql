INSERT IGNORE INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,action_type,action_param1,target_type,comment) VALUES (240240,0,100,0,64,0,100,0,33,240240,7,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');
UPDATE creature_template SET AIName='SmartAI' WHERE entry=240240;
UPDATE creature_template_gossip SET MenuID=39376 WHERE CreatureID=237594;
UPDATE creature_template_gossip SET MenuID=41060 WHERE CreatureID=241255;
