DELETE FROM smart_scripts WHERE source_type=1 AND entryorguid IN (525293,526968,525307);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=237386 AND id=101;
UPDATE gameobject_template SET AIName='' WHERE entry IN (525293,526968,525307);
