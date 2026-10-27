UPDATE creature_template t JOIN bak_20261021_behemoth_ct b ON b.entry=t.entry SET t.faction=b.faction, t.unit_flags=b.unit_flags;
UPDATE creature_template_difficulty d JOIN bak_20261021_behemoth_ctd b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.DamageModifier=b.DamageModifier;
