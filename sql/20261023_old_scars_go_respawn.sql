-- 86641 Old Scars: burn (9) / destroy (13) objects < 17 needed -> 15s respawn
UPDATE gameobject SET spawntimesecs=15 WHERE id IN (584749,584759,584765,547064,572133,572139,572141);
