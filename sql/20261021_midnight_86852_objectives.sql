-- 86852 Light's Last Stand: restore retail objectives (tdb1210_world): "Void forces repelled" = 10x 244047, boss "Imperatus slain" 244088 (flags 3).
-- Live had a progress-bar copy (Type 15) and a duplicate 241575 where the Imperatus fight belongs.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86852 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86852 SELECT * FROM quest_objectives WHERE QuestID=86852 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86852);
DELETE FROM quest_objectives WHERE QuestID=86852;
INSERT INTO quest_objectives SELECT * FROM tdb1210_world.quest_objectives WHERE QuestID=86852;
