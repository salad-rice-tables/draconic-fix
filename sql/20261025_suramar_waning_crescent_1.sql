-- The Waning Crescent, first half: 41877 Lady Lunastre -> 40746 One of the People ->
-- 41148 Dispensing Compassion -> 40947 Special Delivery.
-- Retail: 40746 is a talk-to quest; 41148 is completed by offering Mana Wine through the
-- citizens' gossip option; 40947 starts and ends at Silgryn in Suramar City.

-- 40746 had no objective at all, so it completed on accept. Retail requires meeting Vanthir.
DELETE FROM quest_objectives WHERE ID=2000000407;
INSERT INTO quest_objectives (ID,QuestID,Type,`Order`,StorageIndex,ObjectID,Amount,ConditionalAmount,Flags,Flags2,ProgressBarWeight,ParentObjectiveID,Visible,Description,VerifiedBuild) VALUES
(2000000407,40746,3,0,0,107598,1,0,0,0,0.0,0,1,'Meet with Vanthir in Suramar City',0);

-- Credit the TALKTO objective when Vanthir's gossip is opened (core has the automatic
-- TalkedToCreature call in NPCHandler commented out; SAI action 153 is the supported path).
UPDATE creature_template SET AIName='SmartAI' WHERE entry=107598;
DELETE FROM smart_scripts WHERE entryorguid=107598 AND source_type=0 AND id=101;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,Difficulties,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,event_param_string,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,action_param7,action_param_string,target_type,target_param1,target_param2,target_param3,target_param4,target_param_string,target_x,target_y,target_z,target_o,comment) VALUES
(107598,0,101,0,'',64,0,100,0,0,0,0,0,0,'',153,0,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Vanthir - gossip hello - credit TALKTO objective for 40746');

-- 40947 is given and turned in by Silgryn in Suramar City (107997). 132029 is the unrelated
-- Arluelle world-quest Silgryn; Vanthir is not a giver for this quest.
DELETE FROM creature_queststarter WHERE quest=40947;
INSERT INTO creature_queststarter (id,quest,VerifiedBuild) VALUES (107997,40947,0);
DELETE FROM creature_questender WHERE quest=40947;
INSERT INTO creature_questender (id,quest,VerifiedBuild) VALUES (107997,40947,0);

-- Silgryn 107997 was gated behind phase 41098, which only opens when 42486 Little One Lost is
-- complete/rewarded, so he was missing for 40947 and 40745. Add an early-chapter copy of the
-- same NPC in its own phase; the two phases hand over when 42486 completes.
DELETE FROM creature WHERE guid=990000000101180000;
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,npcflag,unit_flags,unit_flags2,unit_flags3,ScriptName,StringId,VerifiedBuild,size) VALUES
(990000000101180000,107997,1220,7637,0,'0',0,60048,0,-1,0,0,364.363,3978.12,1.38834,4.58841,300,0,0,100,0,NULL,NULL,NULL,NULL,'',NULL,0,-1.0);

DELETE FROM phase_area WHERE PhaseId=60048;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES
(7637,60048,'40745/40947 Silgryn in Suramar City (early Waning Crescent)');

DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60048;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60048,7637,0,0,47,0,41877,64,0,'',0,0,0,'','41877 rewarded'),
(26,60048,7637,0,0,47,0,42486,2,0,'',1,0,0,'','42486 not complete'),
(26,60048,7637,0,0,47,0,42486,64,0,'',1,0,0,'','42486 not rewarded'),
(26,60048,7637,0,0,47,0,43309,74,0,'',1,0,0,'','43309 not started');

-- 41148: the four citizens credited on gossip hello, so the wine option was cosmetic. Credit
-- only when the player picks the option, and also progress the 4-count aggregate objective.
UPDATE quest_objectives SET Amount=4, Flags=0 WHERE QuestID=41148 AND ObjectID=107636;
UPDATE quest_objectives SET Flags=24 WHERE QuestID=41148 AND ObjectID IN (108344,108345,108346,108347,138308);

DELETE FROM smart_scripts WHERE entryorguid IN (108344,108345,108346,108347) AND source_type=0;
INSERT INTO smart_scripts (entryorguid,source_type,id,link,Difficulties,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,event_param_string,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,action_param7,action_param_string,target_type,target_param1,target_param2,target_param3,target_param4,target_param_string,target_x,target_y,target_z,target_o,comment) VALUES
(108346,0,1,0,'',62,0,100,0,19829,0,0,0,0,'',33,108346,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Lunette - offer Mana Wine - credit Mother Revived'),
(108346,0,2,0,'',62,0,100,0,19829,0,0,0,0,'',33,107636,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Lunette - offer Mana Wine - progress Citizens Revived'),
(108347,0,1,0,'',62,0,100,0,19830,0,0,0,0,'',33,108347,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Ambrena - offer Mana Wine - credit Neighbor Revived'),
(108347,0,2,0,'',62,0,100,0,19830,0,0,0,0,'',33,107636,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Ambrena - offer Mana Wine - progress Citizens Revived'),
(108345,0,1,0,'',62,0,100,0,19831,0,0,0,0,'',33,108345,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Clotaire - offer Mana Wine - credit Brother Revived'),
(108345,0,2,0,'',62,0,100,0,19831,0,0,0,0,'',33,107636,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Clotaire - offer Mana Wine - progress Citizens Revived'),
(108344,0,1,0,'',62,0,100,0,19832,0,0,0,0,'',33,108344,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Donatien - offer Mana Wine - credit Husband Revived'),
(108344,0,2,0,'',62,0,100,0,19832,0,0,0,0,'',33,107636,0,0,0,0,0,0,'',7,0,0,0,0,'',0.0,0.0,0.0,0.0,'Donatien - offer Mana Wine - progress Citizens Revived');

-- Hide the "Offer Mana Wine" option unless 41148 is accepted or complete.
DELETE FROM conditions WHERE SourceTypeOrReferenceId=15 AND SourceGroup IN (19829,19830,19831,19832);
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(15,19829,0,0,0,47,0,41148,10,0,'',0,0,0,'','Offer Mana Wine - 41148 accepted/complete'),
(15,19830,0,0,0,47,0,41148,10,0,'',0,0,0,'','Offer Mana Wine - 41148 accepted/complete'),
(15,19831,0,0,0,47,0,41148,10,0,'',0,0,0,'','Offer Mana Wine - 41148 accepted/complete'),
(15,19832,0,0,0,47,0,41148,10,0,'',0,0,0,'','Offer Mana Wine - 41148 accepted/complete');
