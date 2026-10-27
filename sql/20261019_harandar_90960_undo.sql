-- =====================================================================
-- 20261019_harandar_90960_undo.sql
-- Undo pre 20261019_harandar_90960.sql
-- =====================================================================

-- Vrat 5 bug-class SAI riadkov (presne ako boli)
INSERT INTO world.smart_scripts
  (entryorguid, source_type, id, link, Difficulties, event_type, event_phase_mask,
   event_chance, event_flags, event_param1, event_param2, event_param3, event_param4,
   event_param5, event_param_string, action_type, action_param1, action_param2,
   action_param3, action_param4, action_param5, action_param7, action_param_string,
   action_param6, target_type, target_param1, target_param2, target_param3,
   target_param4, target_param_string, target_x, target_y, target_z, target_o, comment)
VALUES
  (245096,0,100,0,'',64,0,100,0,0,0,0,0,0,'',33,245096,0,0,0,0,0,'',0,7,0,0,0,0,'',0.0,0.0,0.0,0.0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
  (245097,0,100,0,'',64,0,100,0,0,0,0,0,0,'',33,245097,0,0,0,0,0,'',0,7,0,0,0,0,'',0.0,0.0,0.0,0.0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
  (245097,0,101,0,'',64,0,100,0,0,0,0,0,0,'',33,246603,0,0,0,0,0,'',0,7,0,0,0,0,'',0.0,0.0,0.0,0.0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
  (246456,0,101,0,'',64,0,100,0,0,0,0,0,0,'',33,246456,0,0,0,0,0,'',0,7,0,0,0,0,'',0.0,0.0,0.0,0.0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
  (246486,0,101,0,'',64,0,100,0,0,0,0,0,0,'',33,246522,0,0,0,0,0,'',0,7,0,0,0,0,'',0.0,0.0,0.0,0.0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');

-- Zrus prazdnu npc_text
DELETE FROM world.npc_text WHERE ID=1000000010;

-- Vrat npcflag
UPDATE world.creature_template SET npcflag=0 WHERE entry=246546;
UPDATE world.creature_template SET npcflag=3 WHERE entry=246486;
