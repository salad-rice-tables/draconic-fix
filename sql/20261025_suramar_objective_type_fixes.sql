-- Suramar objective type fixes (verified against tdb1210_world.quest_objectives).
-- The world DB had Type=2 (GAMEOBJECT) where retail credits a creature (kill credit bunny),
-- so the objective could never be credited and the quest GO "did not exist".
-- Both rows were applied on 2026-10-25; `quest_template` reload picks them up live.

-- 40747 The Delicate Art of Telemancy: "Use teleporter at Oculeth's Workshop"
-- retail: Type=0, ObjectID=101542 (First Teleporter Used Kill Credit)
UPDATE quest_objectives
SET Type=0, ObjectID=101542, Flags=0
WHERE ID=281159 AND QuestID=40747;

-- 40748 Network Security: "Teleport to the Test Chamber"
-- retail: Type=0, ObjectID=101703 (Finale Teleporter Used Kill Credit)
UPDATE quest_objectives
SET Type=0, Flags=0
WHERE ID=281204 AND QuestID=40748;
