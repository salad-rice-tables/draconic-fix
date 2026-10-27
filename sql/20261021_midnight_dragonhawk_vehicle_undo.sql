UPDATE creature_template t JOIN bak_20261021_ct_240226 b ON b.entry=t.entry SET t.VehicleId=b.VehicleId WHERE t.entry=240226;
DELETE FROM creature_template_spell WHERE CreatureID = 240226;
DELETE FROM spell_target_position WHERE ID = 1224705 AND EffectIndex = 0;
DELETE FROM creature_template_addon WHERE entry = 240226;
