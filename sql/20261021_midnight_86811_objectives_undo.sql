DELETE FROM quest_objectives WHERE QuestID=86811;
INSERT INTO quest_objectives SELECT * FROM bak_20261021_qo_86811;
