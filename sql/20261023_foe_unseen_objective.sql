-- 86642 A Foe Unseen: align 'Amani operations investigated' with TDB (creature credit 245221 x5)
UPDATE quest_objectives SET Type=0,ObjectID=245221,Amount=5,Flags=0,ProgressBarWeight=0 WHERE ID=461957 AND QuestID=86642;
DELETE FROM quest_objectives WHERE ID=461957004 AND QuestID=86642;
