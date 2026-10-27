-- Mysterious Corpse (528310): retail template has lock 4368 is a spell-key lock (OPEN_LOCK spell 1286595) the core cannot drive; keep world lock 93, loot template exists under the GO entry; point chestLoot (Data1) at it.
CREATE TABLE IF NOT EXISTS bak_20261021_go_528310 AS SELECT * FROM gameobject_template WHERE entry=528310;
UPDATE gameobject_template SET Data1=528310 WHERE entry=528310;
