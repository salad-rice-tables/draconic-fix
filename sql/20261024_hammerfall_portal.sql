-- 86845 The Sunwalker Path: own goober copy of "Borrowed Portal" (570777 is a spellcaster whose SAI is gossip-select based and cannot give quest credit)
DELETE FROM gameobject_template WHERE entry=9108871;
INSERT INTO gameobject_template (entry,type,displayId,name,IconName,castBarCaption,size,Data0,Data1,Data2,Data3,Data8,Data30,VerifiedBuild) VALUES
(9108871,10,9011,'Borrowed Portal','Interact','',1.0,0,0,3000,0,0,0,0);
UPDATE gameobject SET id=9108871 WHERE guid=990000000101167997;
-- Sunwalker Dezco: gossip menu 38678 does not exist -> not interactable; hello auto-credit removed
DELETE FROM smart_scripts WHERE source_type=0 AND event_type=64 AND action_type=33 AND entryorguid IN (245186,247299);
UPDATE creature_template SET AIName='' WHERE entry IN (245186,247299);
UPDATE creature_template_gossip SET MenuID=999999999 WHERE CreatureID IN (245186,247299) AND MenuID=38678;
