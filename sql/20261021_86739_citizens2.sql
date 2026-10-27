-- 3rd Mr. Fluff in quest phase 45588 (original in 45589 is only visible after 86740)
CREATE TEMPORARY TABLE t_c AS SELECT * FROM creature WHERE guid=3000208748;
UPDATE t_c SET guid=3000500827, position_x=7300, position_y=-4165, position_z=89;
INSERT INTO creature SELECT * FROM t_c;
