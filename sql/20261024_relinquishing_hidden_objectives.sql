-- 86902: two hidden engine-driven objectives cannot be emulated here (type 21 criteria 5346 "Relics Distributed", type 19 areatrigger 39102 "First Raid Preview Conversation") -> quest never completable. Removed.
DELETE FROM quest_objectives WHERE QuestID=86902 AND ID IN (463490,470164);
