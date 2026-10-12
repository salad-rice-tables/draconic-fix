-- World quests like retail: the quests on the map right now (rotation: lua_scripts/world_quest_rotation.lua, core: WorldQuests.h)
CREATE TABLE IF NOT EXISTS world_quest_active (QuestID INT UNSIGNED NOT NULL PRIMARY KEY, EndTime BIGINT NOT NULL) ENGINE=InnoDB;
