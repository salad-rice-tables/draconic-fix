-- 86811 Ethereal Eradication: restore retail objectives (tdb1210_world): Norkonahl the Looter + 12 "Shadowguard forces slain" (238186).
-- Live had turned the kill objective into a progress bar fed by 3 synthetic rows (238186/245706/245707 x12), which the offer text showed
-- as "1 Shadowguard intruders". Retail needs no workaround: Fatestealer 245706 and Spoiler 245707 carry KillCredit1 = 238186.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86811 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86811 SELECT * FROM quest_objectives WHERE QuestID=86811 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86811);
DELETE FROM quest_objectives WHERE QuestID=86811;
INSERT INTO quest_objectives SELECT * FROM tdb1210_world.quest_objectives WHERE QuestID=86811;
