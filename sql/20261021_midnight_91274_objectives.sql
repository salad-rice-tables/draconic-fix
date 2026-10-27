-- 91274 Severing the Void: restore retail objectives (tdb1210_world). Live had the per-sentinel credits A-E made visible (Flags 24 removed),
-- descriptions rewritten and sentinel E (246255) replaced by a second Pylon row -> tracker showed 7 lines instead of retail's 2.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_91274 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_91274 SELECT * FROM quest_objectives WHERE QuestID=91274 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_91274);
DELETE FROM quest_objectives WHERE QuestID=91274;
INSERT INTO quest_objectives SELECT * FROM tdb1210_world.quest_objectives WHERE QuestID=91274;
