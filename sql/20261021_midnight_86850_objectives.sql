-- 86850 Broken Sun: live changed objective 457508 ("Escape on the Empowered Dragonhawk", creature 237388) into a duplicate of 241610. Restore retail.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86850 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86850 SELECT * FROM quest_objectives WHERE QuestID=86850 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86850);
UPDATE quest_objectives l JOIN tdb1210_world.quest_objectives t ON t.ID=l.ID SET l.ObjectID=t.ObjectID, l.Flags=t.Flags, l.Description=t.Description WHERE l.QuestID=86850;
