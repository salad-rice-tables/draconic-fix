-- 86636 Void Walk With Me: restore retail objectives from TDB 12.1 (world had 460909/460333 rewritten into a 2nd item objective + Antenorian kill at the wrong slots).
CREATE TABLE IF NOT EXISTS bak_20261022_qo_86636 AS SELECT * FROM quest_objectives WHERE QuestID=86636;
DELETE FROM quest_objectives WHERE QuestID=86636;
INSERT INTO quest_objectives SELECT * FROM tdb1210_world.quest_objectives WHERE QuestID=86636;
