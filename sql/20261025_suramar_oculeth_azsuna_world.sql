-- 44873 Oculeth Ex Machina / 44874 Unbeleyvable / 44875 The Art of Flow / 44876 A Dance with Dragons
-- Retail chain in the Ley-Ruins of Zarkhenar (Azsuna, area 7334). 44873 is completed by the
-- Oculeth teleport scene and turned in to Valtrois; 44876 is turned in to Thalyssra in Shal'Aran.
-- Worlds DB: quest links, starters/enders, npc_text, phases/conditions, spawns, tap interaction radius.

-- 44876 is preceded by 44875 (The Art of Flow), not 44874.
UPDATE quest_template_addon SET PrevQuestID=44875 WHERE ID=44876;

-- 44874's three tap objectives are gameobject objectives. They were stored as MONSTER (type 0),
-- so GameObject::Use -> KillCreditGO (which updates type 2) could never credit them.
UPDATE quest_objectives SET Type=2 WHERE ID IN (287270,287274,287276);

-- Quest givers / enders.
DELETE FROM creature_queststarter WHERE quest IN (44873,44874,44875,44876);
INSERT INTO creature_queststarter (id, quest, VerifiedBuild) VALUES
(103155,44873,0),
(103155,44874,0),
(103155,44875,0),
(115878,44876,0);

DELETE FROM creature_questender WHERE quest IN (44873,44874,44875,44876);
INSERT INTO creature_questender (id, quest, VerifiedBuild) VALUES
(103155,44873,0),
(103155,44874,0),
(103155,44875,0),
(97140,44876,0);

-- Gossip prompt texts: Valtrois ritual 1/2/3, Oculeth teleport, Stellagosa ride.
DELETE FROM npc_text WHERE ID BETWEEN 920001 AND 920005;
INSERT INTO npc_text (ID, Probability0, BroadcastTextID0, VerifiedBuild) VALUES
(920001,1.0,124420,0),
(920002,1.0,124463,0),
(920003,1.0,124464,0),
(920004,1.0,124288,0),
(920005,1.0,124454,0);

-- Azsuna phasing for the cave and surface versions of Valtrois/Stellagosa and the three taps.
DELETE FROM phase_area WHERE PhaseId BETWEEN 60043 AND 60047;
INSERT INTO phase_area (AreaId, PhaseId, Comment) VALUES
(7334,60043,'44873/44874 Valtrois in the Ley-Ruins cave'),
(7334,60044,'44874/44875 Stellagosa (elf form) in the Ley-Ruins cave'),
(7334,60045,'44874 Ley Line Tap objects'),
(7334,60046,'44876 Valtrois at the cave entrance'),
(7334,60047,'44876 Stellagosa (dragon form) at the cave entrance');

-- Quest-state conditions. Type 47 uses a bitmask: 2=complete, 8=incomplete, 64=rewarded.
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup IN (60043,60044,60045,60046,60047);
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60043,7334,0,0,47,0,44873,64,0,'',0,0,0,'','44873 rewarded'),
(26,60043,7334,0,0,47,0,44876,8,0,'',1,0,0,'','44876 not active'),
(26,60043,7334,0,0,47,0,44876,64,0,'',1,0,0,'','44876 not rewarded'),
(26,60043,7334,0,1,47,0,44873,2,0,'',0,0,0,'','44873 complete'),
(26,60043,7334,0,1,47,0,44876,8,0,'',1,0,0,'','44876 not active'),
(26,60043,7334,0,1,47,0,44876,64,0,'',1,0,0,'','44876 not rewarded'),
(26,60044,7334,0,0,47,0,44874,8,0,'',0,0,0,'','44874 active'),
(26,60044,7334,0,1,47,0,44875,8,0,'',0,0,0,'','44875 active'),
(26,60045,7334,0,0,47,0,44874,8,0,'',0,0,0,'','44874 active'),
(26,60045,7334,0,1,47,0,44874,64,0,'',0,0,0,'','44874 rewarded'),
(26,60045,7334,0,1,47,0,44876,64,0,'',1,0,0,'','44876 not rewarded'),
(26,60046,7334,0,0,47,0,44876,8,0,'',0,0,0,'','44876 active'),
(26,60047,7334,0,0,47,0,44875,64,0,'',0,0,0,'','44875 rewarded'),
(26,60047,7334,0,0,47,0,44876,64,0,'',1,0,0,'','44876 not rewarded');

-- Cave Valtrois (phase 60043) at the upper ledge where the player lands.
-- Cave Stellagosa (elf form, phase 60044). Surface Valtrois (phase 60046) and dragon Stellagosa (phase 60047)
-- at the cave entrance (quest POI z=31).
DELETE FROM creature WHERE guid IN (990000000101170000,990000000101170001,990000000101170002,990000000101170003);
INSERT INTO creature (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,modelid,equipment_id,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,npcflag,unit_flags,unit_flags2,unit_flags3,ScriptName,StringId,VerifiedBuild,size) VALUES
(990000000101170000,103155,1220,7334,0,'0',0,60043,0,-1,0,0,1176.0,5884.0,0.0,3.14159,300,0,0,100,0,3,NULL,NULL,NULL,'',NULL,0,-1.0),
(990000000101170001,115701,1220,7334,0,'0',0,60044,0,-1,0,0,1180.0,5885.0,0.0,3.14159,300,0,0,100,0,0,NULL,NULL,NULL,'',NULL,0,-1.0),
(990000000101170002,103155,1220,7334,0,'0',0,60046,0,-1,0,0,1178.0,5885.0,31.0,3.14159,300,0,0,100,0,3,NULL,NULL,NULL,'',NULL,0,-1.0),
(990000000101170003,115878,1220,7334,0,'0',0,60047,0,-1,0,0,1180.0,5885.0,31.0,3.14159,300,0,0,100,0,3,NULL,NULL,NULL,'',NULL,0,-1.0);

-- Three real Ley Line Taps (GOOBER, spell 230153) on the cave floor.
DELETE FROM gameobject WHERE guid IN (990000000101170010,990000000101170011,990000000101170012);
INSERT INTO gameobject (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecs,animprogress,state,ScriptName,StringId,VerifiedBuild,size,visibility) VALUES
(990000000101170010,266150,1220,7334,0,'0',0,60045,0,-1,1176.0,5884.0,-13.0,0.0,0.0,0.0,0.0,0.0,300,0,1,'',NULL,0,-1.0,256.0),
(990000000101170011,266184,1220,7334,0,'0',0,60045,0,-1,1174.0,5863.0,-12.0,0.0,0.0,0.0,0.0,0.0,300,0,1,'',NULL,0,-1.0,256.0),
(990000000101170012,266186,1220,7334,0,'0',0,60045,0,-1,1194.0,5868.0,-10.0,0.0,0.0,0.0,0.0,0.0,300,0,1,'',NULL,0,-1.0,256.0);

-- The taps are quest objects, not locked containers. Drop the stale lock id (Data0=43, no lock row)
-- and give the tiny model a 5 yard interaction radius (Data33 is yards * 100).
UPDATE gameobject_template SET Data0=0, Data33=500 WHERE entry IN (266150,266184,266186);
