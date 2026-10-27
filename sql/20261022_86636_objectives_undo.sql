DELETE FROM quest_objectives WHERE QuestID=86636;
INSERT INTO quest_objectives SELECT * FROM bak_20261022_qo_86636;
