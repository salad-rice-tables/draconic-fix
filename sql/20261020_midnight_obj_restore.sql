-- Midnight 86780 + 88719: restore retail objectives (tdb1210_world) - live had a type-15 clobber of 458211, duplicate StorageIndex 2 and synthetic dup rows
CREATE TABLE IF NOT EXISTS bak_20261020_quest_objectives LIKE quest_objectives;
INSERT INTO bak_20261020_quest_objectives SELECT * FROM quest_objectives WHERE ID IN (458211,458211001,88719000,88719001) AND ID NOT IN (SELECT ID FROM bak_20261020_quest_objectives);
DELETE FROM quest_objectives WHERE ID IN (458211,458211001,88719000,88719001);
INSERT INTO quest_objectives SELECT * FROM tdb1210_world.quest_objectives WHERE ID=458211;
