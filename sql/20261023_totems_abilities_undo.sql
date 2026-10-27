DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866);
DELETE FROM creature_template_spell WHERE CreatureID IN (251863,251866);
UPDATE creature_template SET AIName='' WHERE entry IN (251863,251866);
