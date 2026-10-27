UPDATE creature_template t JOIN bak_20261021_soarling_ct b ON b.entry=t.entry SET t.unit_flags=b.unit_flags;
UPDATE creature_template t JOIN bak_20261021_slickette_ct b ON b.entry=t.entry SET t.unit_flags=b.unit_flags;
UPDATE creature_template_difficulty d JOIN bak_20261021_soarling_ctd b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.DamageModifier=b.DamageModifier;
UPDATE creature_template_difficulty SET DamageModifier = 1.15 WHERE Entry = 241807;
