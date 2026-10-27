-- 91000 A Humble Servant / 86846 Resupplying Our Suppliers: Hammerfall NPC spawns (coords from Wowhead map %, converted to world coords with a fit on the 8 Injured Peon spawns)
-- own clean phase 60020 visible while either quest is in progress / complete / rewarded
INSERT IGNORE INTO phase_area (AreaId,PhaseId,Comment) VALUES (9734,60020,'Hammerfall: A Humble Servant / Resupplying (own phase)');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60020 AND SourceEntry=9734;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60020,9734,0,0,47,0,91000,74,0,'',0,0,0,'','Hammerfall 60020: A Humble Servant'),
(26,60020,9734,0,1,47,0,86846,74,0,'',0,0,0,'','Hammerfall 60020: Resupplying Our Suppliers');
-- NPC templates: gossip with existing menu, no SmartAI
UPDATE creature_template SET AIName='',npcflag=npcflag|1 WHERE entry IN (238101,238081,232031,232033,232036,232037,232035,245257);
DELETE FROM creature_template_gossip WHERE CreatureID IN (238101,238081,232031,232033,232036,232037,232035,245257);
INSERT INTO creature_template_gossip (CreatureID,MenuID,VerifiedBuild) VALUES (238101,999999999,0),(238081,999999999,0),(232031,999999999,0),(232033,999999999,0),(232036,999999999,0),(232037,999999999,0),(232035,999999999,0),(245257,999999999,0);
-- spawns
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,PhaseId,PhaseGroup,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,unit_flags) VALUES
(3100920001,238101,0,0,0,'0',60020,0,0,0,-976.4,-3505.4,57.0,3.1,300,0,0,100,0,32768),
(3100920002,238081,0,0,0,'0',60020,0,0,0,-957.9,-3512.4,57.0,3.1,300,0,0,100,0,32768),
(3100920003,232031,0,0,0,'0',60020,0,0,0,-953.2,-3533.3,70.5,3.1,300,0,0,100,0,32768),
(3100920004,232033,0,0,0,'0',60020,0,0,0,-1013.5,-3491.5,62.2,3.1,300,0,0,100,0,32768),
(3100920005,232036,0,0,0,'0',60020,0,0,0,-967.2,-3561.1,58.7,3.1,300,0,0,100,0,32768),
(3100920006,232037,0,0,0,'0',60020,0,0,0,-883.7,-3505.4,70.5,3.1,300,0,0,100,0,32768),
(3100920007,232035,0,0,0,'0',60020,0,0,0,-916.1,-3533.3,70.5,3.1,300,0,0,100,0,32768);
-- existing Hammerfall spawns that sat in invisible phases (0 / 45806) -> 60020
UPDATE creature SET PhaseId=60020 WHERE id IN (240579,245257,240581) AND map=0 AND position_x BETWEEN -1100 AND -850 AND position_y BETWEEN -3600 AND -3450;
UPDATE gameobject SET PhaseId=60020 WHERE id IN (525458,525459) AND map=0 AND position_x BETWEEN -1100 AND -850 AND position_y BETWEEN -3600 AND -3450;
