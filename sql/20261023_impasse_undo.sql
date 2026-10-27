DELETE FROM smart_scripts WHERE (entryorguid=-3000209895 AND source_type=0 AND id>=200) OR (entryorguid=86646 AND source_type=5) OR (entryorguid IN (23761001,23661031,23661030) AND source_type=9) OR (entryorguid=236610 AND source_type=0 AND id=120);
DELETE FROM creature_text WHERE (CreatureID=237386 AND GroupID IN (0,1)) OR (CreatureID=236610 AND GroupID IN (14,15,16));
