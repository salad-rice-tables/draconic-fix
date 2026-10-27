-- 86840: 54 kills needed (20 Ravaging Abomination + 34 Scourge Remnant) but only 42 spawns -> faster respawn like a busy front line
UPDATE creature SET spawntimesecs=30 WHERE id IN (237731,237739);
