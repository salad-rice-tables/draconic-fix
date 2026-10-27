-- 42225 Breaking the Seal: two arcane coils (tall / short beam) aim at the three seals; seals need to be interactable (lock removed)
DELETE FROM gameobject_template WHERE entry IN (9108872,9108873);
INSERT INTO gameobject_template (entry,type,displayId,name,IconName,castBarCaption,unk1,size,Data0,Data1,Data2) VALUES
(9108872,10,27812,'Arcane Coil (Tall Beam)','Interact','','',1.0,0,0,1000),
(9108873,10,27812,'Arcane Coil (Short Beam)','Interact','','',1.0,0,0,1000);
UPDATE gameobject_template SET Data0=0 WHERE entry IN (250378,250666,250667);
DELETE FROM gameobject WHERE guid IN (9108872001,9108872002);
INSERT INTO gameobject (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecs,animprogress,state,VerifiedBuild) VALUES
(9108872001,9108872,1220,7637,7995,'0',0,0,0,-1,2043.0,5689.5,86.3,0,0,0,0,1,300,255,1,0),
(9108872002,9108873,1220,7637,7995,'0',0,0,0,-1,2050.0,5700.5,86.3,0,0,0,0,1,300,255,1,0);
UPDATE gameobject_template SET Data10=0, Data14=0 WHERE entry IN (250378,250666,250667);   -- spell + playerCondition 105601 blocked the click
-- retail seals (250378/250666/250667) keep a client-cached lock/spell; use clean own copies
DELETE FROM gameobject_template WHERE entry IN (9108874,9108875,9108876);
INSERT INTO gameobject_template (entry,type,displayId,name,IconName,size,Data3)
SELECT e,10,34066,n,'Interact',1.0,1 FROM (SELECT 9108874 e,'Seal of the Tides' n UNION SELECT 9108875,'Seal of the Earth' UNION SELECT 9108876,'Seal of the Sky') t;
