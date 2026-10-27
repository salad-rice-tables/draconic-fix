-- The Waning Crescent, second half: 40745 Shift Change, 42722 Friends in Cages,
-- 42486 Little One Lost, 42487 Friends On the Outside, 42488 Thalyssra's Abode,
-- 42489 Thalyssra's Drawers and 40730 Redistribution.
-- Retail interactions are driven by suramar_waning.lua; this file only supplies the
-- correct objectives, quest givers, objects, phases, spawns and loot.

-- 40745 is given by Silgryn in Suramar City. Deline and Vanthir are not retail starters.
DELETE FROM creature_queststarter WHERE quest=40745;
INSERT INTO creature_queststarter (id,quest,VerifiedBuild) VALUES (107997,40745,0);

-- 40745's first two objectives are required and sequenced; only the cage opening is a GO.
UPDATE quest_objectives SET Flags=0 WHERE ID=284377;
UPDATE quest_objectives SET Flags=2 WHERE ID IN (284378,284379);

-- 42486's escort objective is required (TDB has Flags=0, the world copy was optional).
UPDATE quest_objectives SET Flags=0 WHERE ID=284507;

-- Guard Morgaine's arrival line from BroadcastText 115406 (sound kit 66315).
DELETE FROM creature_text WHERE CreatureID=107318 AND GroupID=0 AND ID=0;
INSERT INTO creature_text (CreatureID,GroupID,ID,Text,Type,Language,Probability,Emote,Duration,Sound,SoundPlayType,BroadcastTextId,TextRange,comment) VALUES
(107318,0,0,'Keep it down, brats. You will join the others soon.',12,0,100,0,0,66315,0,115406,0,'40745 Guard Morgaine arrival');

-- The guard at the cage is spawned by the script only after the walk. The old static
-- spawn would stand at the cage before the player has followed anyone.
DELETE FROM creature WHERE guid=3000116114;

-- 40745: custom basket object placed where Silgryn marks the map.
DELETE FROM gameobject_template WHERE entry=9000001;
INSERT INTO gameobject_template (entry,type,displayId,name,size,Data0,Data1,Data2,Data3,Data10,Data33,VerifiedBuild) VALUES
(9000001,5,34802,'Conveniently Placed Basket',1.0,0,0,0,1,0,500,0);
DELETE FROM gameobject_template_addon WHERE entry=9000001;
INSERT INTO gameobject_template_addon (entry,faction,flags) VALUES (9000001,35,0);

DELETE FROM gameobject WHERE guid=990000000101180110;
INSERT INTO gameobject (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,position_x,position_y,position_z,orientation,spawntimesecs,state,VerifiedBuild,size,visibility) VALUES
(990000000101180110,9000001,1220,7637,0,'0',0,60053,0,-1,528.0,4086.0,6.48,4.71239,300,1,0,-1,256);

DELETE FROM phase_area WHERE PhaseId=60053;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (7637,60053,'40745 Conveniently Placed Basket');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60053;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60053,7637,0,0,47,0,40745,8,0,'',0,0,0,'','40745 active');

-- The spell barrier is a normal unlocked goober; the script requires the Control Orb.
UPDATE gameobject_template SET Data0=0, Data10=0, Data33=500 WHERE entry=250991;

-- 42722: the containment fields in the Terrace of Order are the cages. They must be
-- unlocked so the client can use them; the script consumes Control Orb 138301 and credits
-- the prisoner proxy only when a live accused citizen is inside the field.
UPDATE gameobject_template SET Data0=0, Data10=0, Data33=500 WHERE entry=251190;

-- 42489: Armoire starts the quest, the three containers hold the quest items.
DELETE FROM creature_queststarter WHERE quest=42489;
DELETE FROM gameobject_queststarter WHERE quest=42489;
INSERT INTO gameobject_queststarter (quest,id,VerifiedBuild) VALUES (42489,251032,0);

UPDATE gameobject_template SET Data0=0, Data33=500 WHERE entry IN (251032,251034,251035,251046);
DELETE FROM gameobject_template_addon WHERE entry IN (251032,251034,251035,251046);
INSERT INTO gameobject_template_addon (entry,faction,flags) VALUES
(251032,35,0),
(251034,35,0),
(251035,35,0),
(251046,35,0);

DELETE FROM gossip_menu WHERE MenuID=20245;
INSERT INTO gossip_menu (MenuID,TextID,VerifiedBuild) VALUES (20245,20245,0);

DELETE FROM gameobject WHERE guid IN (990000000101180101,990000000101180102,990000000101180103,990000000101180104);
INSERT INTO gameobject (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,position_x,position_y,position_z,orientation,spawntimesecs,state,VerifiedBuild,size,visibility) VALUES
(990000000101180101,251032,1220,7637,0,'0',0,60055,0,-1,1117.0,3008.0,7.0,3.14159,300,1,0,-1,256),
(990000000101180102,251034,1220,7637,0,'0',0,60055,0,-1,1049.0,3007.0,3.0,0.0,300,1,0,-1,256),
(990000000101180103,251035,1220,7637,0,'0',0,60055,0,-1,1165.0,3069.0,8.0,0.0,300,1,0,-1,256),
(990000000101180104,251046,1220,7637,0,'0',0,60055,0,-1,1102.0,2972.0,6.0,0.0,300,1,0,-1,256);

DELETE FROM phase_area WHERE PhaseId=60055;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (7637,60055,'42489 Thalyssra estate belongings');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60055;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60055,7637,0,0,47,0,42488,64,0,'',0,0,0,'','42488 rewarded'),
(26,60055,7637,0,0,47,0,42489,64,0,'',1,0,0,'','42489 not rewarded');

-- 42487: the telemancy beacon is only visible while the quest is in progress.
UPDATE gameobject SET PhaseId=60056 WHERE guid=20369429;
DELETE FROM phase_area WHERE PhaseId=60056;
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (7637,60056,'42487 Telemancy Beacon');
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup=60056;
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(26,60056,7637,0,0,47,0,42487,8,0,'',0,0,0,'','42487 active');

-- 40730: bottles and casks must be usable. A cask is worth 10 bottles (retail note);
-- the Stack of Letters drop belonged to 40947 and is removed from the cask loot.
UPDATE gameobject_template SET Data0=0, Data33=500 WHERE entry IN (250086,250239,250240);
UPDATE gameobject_loot_template SET QuestRequired=1, MinCount=10, MaxCount=10 WHERE Entry=250086 AND Item=137295;
UPDATE gameobject_loot_template SET QuestRequired=1 WHERE Entry IN (250239,250240) AND Item=137295;
DELETE FROM gameobject_loot_template WHERE Entry=250086 AND Item=137601;

-- 40730 is given and turned in by Deline; the old Vanthir starter was a hand-added error.
DELETE FROM creature_queststarter WHERE quest=40730;
INSERT INTO creature_queststarter (id,quest,VerifiedBuild) VALUES (107225,40730,0);

-- The "I found a cask of wine!" option had no action list and did nothing. The cask now
-- grants its ten bottles directly, so remove the dead option and its unused SAI hook.
DELETE FROM gossip_menu_option WHERE MenuID=19692 AND OptionID=0;
DELETE FROM smart_scripts WHERE entryorguid=107225 AND source_type=0 AND id=0;

-- 42488: Magisterial Sleuths drop Amplifier Fragments (29.8%); the completed Arcane
-- Amplifier is created by combining three fragments with item spell 215740, not by loot.
DELETE FROM creature_loot_template WHERE Entry=108190 AND Item=138391;
