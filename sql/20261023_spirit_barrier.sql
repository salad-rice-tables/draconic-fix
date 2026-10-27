-- 86643: replace Spirit Wall (209922) with Spirit Barrier (516343) at the same two spots; not selectable, only visible while 86643 is in progress (phase 45629)
DELETE FROM gameobject_template_addon WHERE entry=516343;
INSERT INTO gameobject_template_addon (entry,faction,flags,mingold,maxgold,artkit0,artkit1,artkit2,artkit3,artkit4,WorldEffectID,AIAnimKitID) VALUES (516343,0,16,0,0,0,0,0,0,0,0,0);
UPDATE gameobject SET id=516343,PhaseId=45629,spawntimesecs=120 WHERE guid IN (990000000101167822,990000000101167823);
