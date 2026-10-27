-- 86770 Champions of Quel'Danas: recruit credit must come on gossip OPTION select (Lua midnight_champions.lua), not on gossip open (SAI event 64).
CREATE TABLE IF NOT EXISTS bak_20261020_smart_scripts_champions LIKE smart_scripts;
INSERT INTO bak_20261020_smart_scripts_champions SELECT * FROM smart_scripts WHERE source_type=0 AND entryorguid IN (236789,237211,236657) AND id=100 AND event_type=64 AND NOT EXISTS (SELECT 1 FROM bak_20261020_smart_scripts_champions b WHERE b.entryorguid=smart_scripts.entryorguid AND b.source_type=0 AND b.id=100);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (236789,237211,236657) AND id=100 AND event_type=64;
