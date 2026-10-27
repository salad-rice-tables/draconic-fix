-- 86739 needs 3 citizens (Mr. Fluff credit 237406) but only 2 spawns existed; add a third in the quest phase.
CREATE TEMPORARY TABLE t_c AS SELECT * FROM creature WHERE guid=3000208748;
UPDATE t_c SET guid=3000500826, position_x=7325, position_y=-4160;
INSERT INTO creature SELECT * FROM t_c;
