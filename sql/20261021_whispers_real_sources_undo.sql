DELETE FROM gameobject_template WHERE entry IN (527827,527829,527831,537177,537178,537179,508217);
INSERT INTO gameobject_template SELECT * FROM bak_20261021_gameobject_template_whispers;
UPDATE creature_template SET KillCredit2=0 WHERE entry IN (251764,251769);
