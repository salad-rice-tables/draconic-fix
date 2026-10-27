-- 42230 The Valewalker's Burden: own clean copy of the Fal'adora Beacon (retail template has lock 1691 / spell / playerCondition that blocks the click)
DELETE FROM gameobject_template WHERE entry=9108877;
INSERT INTO gameobject_template (entry,type,displayId,name,IconName,size,Data3)
SELECT 9108877,10,displayId,name,'Interact',size,1 FROM gameobject_template WHERE entry=251047;
