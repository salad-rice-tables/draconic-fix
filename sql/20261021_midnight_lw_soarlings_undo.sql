UPDATE creature_template_difficulty d JOIN bak_20261021_soarling_ctd b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.StaticFlags1=b.StaticFlags1;
UPDATE creature c JOIN bak_20261021_soarling_cr b ON b.guid=c.guid SET c.position_z=b.position_z;
UPDATE creature_template t JOIN bak_20261021_soarling_ct b ON b.entry=t.entry SET t.AIName=b.AIName;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=240263;
UPDATE smart_scripts SET event_param1=2000, event_param2=8000, event_param3=12000, event_param4=20000 WHERE source_type=0 AND entryorguid IN (241810,241817,241819) AND id=3;
