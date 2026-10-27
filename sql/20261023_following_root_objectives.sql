-- 86643 Following the Root: align with TDB/Wowhead (4 Warding totems; Speak to Arator = creature credit 240558)
UPDATE quest_objectives SET Amount=4,Description='Warding totems destroyed' WHERE ID=464905 AND QuestID=86643;
UPDATE quest_objectives SET Type=0,ObjectID=240558,Amount=1,Description='Speak to Arator' WHERE ID=459561 AND QuestID=86643;
