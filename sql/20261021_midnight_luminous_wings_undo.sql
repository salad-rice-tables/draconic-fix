UPDATE creature_template t JOIN bak_20261021_ct_240226 b ON b.entry=t.entry SET t.VehicleId=b.VehicleId WHERE t.entry=240226;
DELETE FROM spell_target_position WHERE ID = 1224709 AND EffectIndex = 0;
UPDATE creature_template t JOIN bak_20261021_ct_civilians b ON b.entry=t.entry SET t.AIName=b.AIName, t.npcflag=b.npcflag;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (241790,241810,241817,241818,241819);
INSERT INTO smart_scripts SELECT * FROM bak_20261021_sai_civilians;
