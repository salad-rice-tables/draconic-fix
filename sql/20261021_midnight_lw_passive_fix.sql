-- fix: SMART_EVENT_RESET (25) never fires on spawn, so Soarlings/Slickettes stayed aggressive. Set passive on JUST_CREATED (63),
-- RESPAWN (11) and RESET (25); if they still enter combat (player hits them) they stay passive.
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (240263,241807);
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
SELECT e,0,i,0,ev,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,CONCAT(n,' - react passive (never attacks the rider)') FROM (
  SELECT 240263 e,'Voidborn Soarling' n UNION SELECT 241807,'Umbral Slickette') c
  JOIN (SELECT 0 i,63 ev UNION SELECT 1,11 UNION SELECT 2,25) x;
