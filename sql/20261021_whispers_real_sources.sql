-- Whispers in the Twilight: restore retail credit sources instead of the fallback timer.
-- Retail GOs cast spells with KILL_CREDIT2 effects: 1228112 -> 241879 (disturbance), 1234198 -> 244057 (plant), 1229738 -> 242268 (growth).
CREATE TABLE IF NOT EXISTS bak_20261021_gameobject_template_whispers AS SELECT * FROM gameobject_template WHERE entry IN (527827,527829,527831,537177,537178,537179,508217);
DELETE FROM gameobject_template WHERE entry IN (527827,527829,527831,537177,537178,537179);
INSERT INTO gameobject_template SELECT * FROM tdb1210_world.gameobject_template WHERE entry IN (527827,527829,527831,537177,537178,537179);
UPDATE gameobject_template SET Data10=1229738 WHERE entry=508217;
-- (spawns for 527831 x2 and 537179 x1 already exist in world)
-- 86742: kills of the two retail "examine" mobs also count as growths examined (spells 1235086/1235087 give 242268 together with B/C credit)
UPDATE creature_template SET KillCredit2=242268 WHERE entry IN (251764,251769);
