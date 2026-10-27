-- 86849 Wrath Unleashed: objective 462948 flags back to retail (2 = sequenced; live had 6).
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86849 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86849 SELECT * FROM quest_objectives WHERE QuestID=86849 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86849);
UPDATE quest_objectives l JOIN tdb1210_world.quest_objectives t ON t.ID=l.ID SET l.Flags=t.Flags WHERE l.QuestID=86849;
