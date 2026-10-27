-- 86648 Light Guide Us (retail flow per user description)
-- accept: Lor'themar "If you will not fight, get out of my way!", Arator "This bloodshed... it's madness..."
-- 8 sin'dorei dissuaded via gossip (Lua: light_guide_us.lua), 4 Amani banners burned + 4 sin'dorei banners planted (goobers)
-- both done -> "Resolve the battle at Amani Pass"

UPDATE quest_template_addon SET ScriptName='SmartQuest' WHERE ID=86648;

DELETE FROM creature_text WHERE (CreatureID=236612 AND GroupID=0) OR (CreatureID=236611 AND GroupID=1);
INSERT INTO creature_text (CreatureID,GroupID,ID,Text,Type,Language,Probability,Emote,Duration,Sound,BroadcastTextId,TextRange,comment) VALUES
(236612,0,0,'If you will not fight, get out of my way!',12,0,100,5,0,300107,285086,0,'86648 accept'),
(236611,1,0,'This bloodshed... it''s madness. Where is my father? He must see this by now!',12,0,100,1,0,300108,285098,0,'86648 accept');

-- accept: Lor'themar line, Arator line 4s later
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=236612 AND source_type=0 AND id=100;
DELETE FROM smart_scripts WHERE entryorguid=236612 AND source_type=0 AND id=110;
DELETE FROM smart_scripts WHERE entryorguid IN (23661201) AND source_type=9;
UPDATE t_ss SET id=110,event_type=19,event_param1=86648,action_type=80,action_param1=23661201,target_type=1,comment='On accept 86648: Lor''themar + Arator lines';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET entryorguid=23661201,source_type=9,id=0,event_type=0,event_param1=0,action_type=1,action_param1=0,target_type=1,comment='Lor''themar: get out of my way';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=1,event_param1=4000,event_param2=4000,action_type=1,action_param1=1,target_type=9,target_param1=236611,target_param2=0,target_param3=40,comment='Arator: This bloodshed...';
INSERT INTO smart_scripts SELECT * FROM t_ss;

-- banners: each burned/planted banner also counts toward "Sin'dorei Banners planted and Amani Banners burned" (258299 x8)
DELETE FROM smart_scripts WHERE entryorguid=86648 AND source_type=5 AND id BETWEEN 100 AND 120;
UPDATE t_ss SET entryorguid=86648,source_type=5,id=100,event_type=48,event_param1=462089,event_param2=0,action_type=33,action_param1=258299,target_type=7,target_param1=0,target_param2=0,target_param3=0,comment='banner -> count';
INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=101,event_param1=462090; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=102,event_param1=462091; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=103,event_param1=462092; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=104,event_param1=462078; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=105,event_param1=462079; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=106,event_param1=462080; INSERT INTO smart_scripts SELECT * FROM t_ss;
UPDATE t_ss SET id=107,event_param1=462081; INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;

-- banner spawns: drop duplicates stacked on the same spot and the copies sunk under the terrain (z 80)
DELETE FROM gameobject WHERE guid IN (19850002,19850003,990000000101165865,990000000101165869);
UPDATE gameobject SET position_z=109.6 WHERE guid=990000000101165868;

-- dissuadable sin'dorei in the battle phase get a gossip flag (Lua handles hello/select)
UPDATE creature SET npcflag=1 WHERE PhaseId=45635 AND id IN (237424,258585,258561,258564,258582);

-- both parts done -> "Resolve the battle at Amani Pass" (258301)
CREATE TEMPORARY TABLE t_ss2 SELECT * FROM smart_scripts WHERE entryorguid=86648 AND source_type=5 AND id=100;
UPDATE t_ss2 SET id=110,event_param1=468986,action_param1=258301,comment='dissuaded 8 (+banners done) -> resolve';
INSERT INTO smart_scripts SELECT * FROM t_ss2;
UPDATE t_ss2 SET id=111,event_param1=468987,comment='banners 8 (+dissuaded done) -> resolve';
INSERT INTO smart_scripts SELECT * FROM t_ss2;
DROP TEMPORARY TABLE t_ss2;
DELETE FROM conditions WHERE SourceTypeOrReferenceId=22 AND SourceEntry=86648 AND SourceId=5 AND SourceGroup IN (111,112);
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(22,111,86648,5,0,48,0,468987,0,8,0,0,0,'','banners already done'),
(22,112,86648,5,0,48,0,468986,0,8,0,0,0,'','dissuade already done');

DELETE FROM npc_text WHERE ID BETWEEN 9108821 AND 9108825;
INSERT INTO npc_text (ID,Probability0,BroadcastTextID0,VerifiedBuild) VALUES (9108821,1,307240,70391),(9108822,1,307243,70391),(9108823,1,307244,70391),(9108824,1,307250,70391),(9108825,1,307238,70391);

-- fighting sin'dorei stay talkable in combat
UPDATE creature SET unit_flags3=IFNULL(unit_flags3,0)|1048576 WHERE PhaseId=45635 AND id IN (237424,258585,258561,258564,258582);

-- (hotfixes) battle phase was Cosmetic -> units not interactable by client
-- UPDATE hotfixes.phase SET Flags=8 WHERE ID=45635;

UPDATE creature_template SET unit_flags3=unit_flags3|1048576 WHERE entry IN (237424,258585,258561,258564,258582);

-- gossip only opens for NPCs that are not hostile-flagged: use faction 35 like Spellbreaker (258585)
UPDATE creature_template SET faction=35 WHERE entry IN (237424,258561,258564,258582,258562);
