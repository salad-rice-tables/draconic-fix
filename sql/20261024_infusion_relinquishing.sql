-- 92136 Infusion of Hope / 86902 Relinquishing Relics: Lua (infusion_relics.lua) drives gossip + credits.
-- SmartAI hello "oathstone" auto-credits removed, Eluna gossip needs AIName=''.
DELETE FROM smart_scripts WHERE source_type=0 AND event_type=64 AND action_type=33 AND entryorguid IN (237602,251355,248326,248321,239623,248408,248323,248322);
UPDATE creature_template SET AIName='' WHERE entry IN (237602,251355,248326,248321,239623);
-- relic receivers / Aelyse must be gossip NPCs with an existing menu
UPDATE creature_template SET npcflag=npcflag|1 WHERE entry IN (248323,248322,248408,248326,248321,239623);
DELETE FROM creature_template_gossip WHERE CreatureID IN (248323,248322,248408,248326,248321,239623,251355,237602);
INSERT INTO creature_template_gossip (CreatureID,MenuID,VerifiedBuild) VALUES
(248323,999999999,0),(248322,999999999,0),(248408,999999999,0),(248326,999999999,0),(248321,999999999,0),(239623,999999999,0),(251355,999999999,0),(237602,999999999,0);

-- 92136: own goober portal (spell 32270 of GO 246004 teleports to OLD Silvermoon, map 530)
DELETE FROM gameobject_template WHERE entry=9108870;
INSERT INTO gameobject_template (entry,type,displayId,name,IconName,castBarCaption,size,Data0,Data1,Data2,Data3,Data8,Data30,VerifiedBuild) VALUES
(9108870,10,6956,'Portal to Silvermoon','Interact','',1.0,0,0,3000,0,0,0,0);

-- 86902: relic receivers were phase 0 (invisible in Isle of Quel'Danas, area 16215 has quest phases only) -> phase 45803 (92136 started/rewarded)
UPDATE creature SET PhaseId=45803 WHERE guid IN (3000208398,3000208544,3000208558,3000208559,3000208576,3000208588,3000208552,3000208553) AND PhaseId=0;
