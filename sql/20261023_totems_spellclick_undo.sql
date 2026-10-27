UPDATE creature_template SET unit_flags=unit_flags&~2 WHERE entry IN (251863,251866);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866) AND id=0 AND event_type=10;
