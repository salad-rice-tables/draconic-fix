DELETE FROM smart_scripts WHERE source_type=9 AND entryorguid=23661000;
DELETE FROM smart_scripts WHERE source_type=0 AND ((entryorguid=241205 AND id IN (111,112)) OR (entryorguid=236610 AND id=105));
DELETE FROM creature_text WHERE CreatureID=236610 AND GroupID IN (2,3,4);
