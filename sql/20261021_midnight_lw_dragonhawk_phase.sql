-- 86806: the clickable Empowered Dragonhawk 237221 (spellclick -> 1224696) sat in phase 45572, which phase_area/conditions show only
-- while 86806 is NOT in progress ("Uninteract"); it vanished on accept. Retail (video 0:12-0:20): it lands at the Silver Landing after accept
-- and carries the "Mount Empowered Dragonhawk" objective tooltip -> it belongs to the quest phase 45573 ("Interact").
CREATE TABLE IF NOT EXISTS bak_20261021_cr_237221 LIKE creature;
INSERT INTO bak_20261021_cr_237221 SELECT * FROM creature WHERE guid=300201029 AND guid NOT IN (SELECT guid FROM bak_20261021_cr_237221);
UPDATE creature SET PhaseId = 45573 WHERE guid = 300201029;
