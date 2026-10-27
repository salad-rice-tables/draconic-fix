UPDATE creature_template_difficulty d JOIN bak_20261021_civ_ctd b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.StaticFlags1=b.StaticFlags1;
