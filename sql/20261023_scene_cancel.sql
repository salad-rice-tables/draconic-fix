-- after-scene Arator script also runs when the player skips (cancels) the cutscene
DELETE FROM smart_scripts WHERE source_type=10 AND entryorguid=9108603 AND id=1;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE source_type=10 AND entryorguid=9108603 AND id=0;
UPDATE t_ss SET id=1,event_type=80,comment='Scene cancelled/skipped: Arator after-scene script';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
