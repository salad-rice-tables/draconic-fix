-- Skymaster Skyles (239639) wrongly granted Reliquary credit 242435 on gossip (copy of Valeera's script); remove (Reliquary = Valeera 242381 only).
CREATE TABLE IF NOT EXISTS bak_20261021_smart_scripts_skymaster AS SELECT * FROM smart_scripts WHERE entryorguid=239639 AND source_type=0 AND id=100;
DELETE FROM smart_scripts WHERE entryorguid=239639 AND source_type=0 AND id=100;
