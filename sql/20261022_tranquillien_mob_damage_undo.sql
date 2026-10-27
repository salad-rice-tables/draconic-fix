UPDATE creature_template_difficulty d JOIN bak_20261022_ctd_damage b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.DamageModifier=b.DamageModifier;
