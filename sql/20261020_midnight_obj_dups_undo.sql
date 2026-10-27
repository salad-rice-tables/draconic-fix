INSERT INTO quest_objectives SELECT * FROM bak_20261020_quest_objectives WHERE ID NOT IN (SELECT ID FROM quest_objectives);
