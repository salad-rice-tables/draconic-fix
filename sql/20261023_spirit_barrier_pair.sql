-- 516342/516343: consecutive Spirit Barrier objects (same displayId 97744, same size 0.82481) -> entrance barrier = 516342, lower barrier = 516343
DELETE FROM gameobject_template_addon WHERE entry=516342;
INSERT INTO gameobject_template_addon (entry,faction,flags,mingold,maxgold,artkit0,artkit1,artkit2,artkit3,artkit4,WorldEffectID,AIAnimKitID) VALUES (516342,0,16,0,0,0,0,0,0,0,0,0);
UPDATE gameobject SET id=516342 WHERE guid=990000000101167823;
