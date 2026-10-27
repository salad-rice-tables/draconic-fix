-- 86848 Light's Arsenal: restore retail objective 459702 (Type 0 creature credit 240919 x7 "Weapons collected"); live had a progress bar (Type 15 x1).
-- Each Plaque chest (Infinity Blades, Devastation, Warp Slicer, ...) gives one legendary weapon; credit is awarded per weapon by midnight_arsenal.lua.
CREATE TABLE IF NOT EXISTS bak_20261021_qo_86848 LIKE quest_objectives;
INSERT INTO bak_20261021_qo_86848 SELECT * FROM quest_objectives WHERE ID=459702 AND ID NOT IN (SELECT ID FROM bak_20261021_qo_86848);
UPDATE quest_objectives l JOIN tdb1210_world.quest_objectives t ON t.ID=l.ID SET l.Type=t.Type, l.ObjectID=t.ObjectID, l.Amount=t.Amount WHERE l.ID=459702;
