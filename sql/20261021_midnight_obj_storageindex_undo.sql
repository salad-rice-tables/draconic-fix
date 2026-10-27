DELETE FROM quest_objectives WHERE ID IN (SELECT ID FROM bak_20261021_qo_si);
INSERT INTO quest_objectives SELECT * FROM bak_20261021_qo_si;
