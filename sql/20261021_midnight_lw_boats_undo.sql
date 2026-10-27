UPDATE gameobject g JOIN bak_20261021_go_lw b ON b.guid=g.guid SET g.visibility=b.visibility;
UPDATE creature c JOIN bak_20261021_cr_lw b ON b.guid=c.guid SET c.position_x=b.position_x, c.position_y=b.position_y, c.position_z=b.position_z;
DELETE FROM creature_addon WHERE guid IN (3000201011,3000201013,3000201017);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (241810,241817,241819) AND id=3;
