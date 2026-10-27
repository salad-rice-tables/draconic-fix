-- 42229 Shal'Aran (Nightfallen intro, retail tour of Shal'Aran)
-- TDB marks the two stage objectives hidden (Flags 24); the world copy had them visible (2).
UPDATE quest_objectives SET Flags=24 WHERE QuestID=42229 AND StorageIndex IN (2,3);

-- These custom areatrigger SAI rows never fire: areatriggers 9106435-9106438 do not exist in the client.
DELETE FROM smart_scripts WHERE source_type=12 AND entryorguid IN (9106435,9106436,9106437,9106438);

-- 98312 SmartAI credited 98312 ("Explore Shal'aran") on gossip hello; that also completed 42229's main
-- objective as soon as the player clicked the starter again. 40009 "Search Shal'Aran" is now credited by
-- lua/suramar_shalaran.lua only while 40009 is in progress, so 42229 cannot be skipped.
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=98312 AND id=2;
