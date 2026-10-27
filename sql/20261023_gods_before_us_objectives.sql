-- 86644 Gods Before Us: align with TDB (creature credits 242144 'Amani Riddle solved', 240667 'Carved Tiles matched'; remove bogus GO child objective)
UPDATE quest_objectives SET Type=0,ObjectID=242144 WHERE ID=461814 AND QuestID=86644;
UPDATE quest_objectives SET Type=0,ObjectID=240667 WHERE ID=459563 AND QuestID=86644;
DELETE FROM quest_objectives WHERE ID=461814001 AND QuestID=86644;
