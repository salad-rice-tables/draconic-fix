-- 86834 Voidborn Banishing: retail objective flags (1 = tracked on minimap) were cleared to 0.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86834 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86834 SELECT * FROM quest_objectives WHERE QuestID=86834 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86834);
UPDATE quest_objectives l JOIN tdb1210_world.quest_objectives t ON t.ID=l.ID SET l.Flags=t.Flags WHERE l.QuestID=86834;
