-- 86641 Old Scars: Enforcer x10 (6 spawns) and Cre'van x5 (2 spawns) need fast respawn
UPDATE creature SET spawntimesecs=10 WHERE id IN (236374,250719);
