-- 86643: exactly one Arator visible at any time.
-- phase 45629 (entrance/stage-2 Arator): quest in progress OR complete-not-rewarded (mask 8|2=10)
-- phase 45630 (final-spot Arator, starts 86644): only once 86643 is REWARDED (mask 64)
UPDATE conditions SET ConditionValue2=10 WHERE SourceTypeOrReferenceId=26 AND SourceGroup=45629 AND ConditionTypeOrReference=47 AND ConditionValue1=86643;
UPDATE conditions SET ConditionValue2=64 WHERE SourceTypeOrReferenceId=26 AND SourceGroup=45630 AND ConditionTypeOrReference=47 AND ConditionValue1=86643 AND NegativeCondition=0;
DELETE FROM creature WHERE guid=3000209807;
CREATE TEMPORARY TABLE t_c SELECT * FROM creature WHERE guid=3000209892;
UPDATE t_c SET guid=3000209807,PhaseId=45630,position_x=6051.2876,position_y=-5016.282,position_z=194.54639,orientation=1.79;
INSERT INTO creature SELECT * FROM t_c;
DROP TEMPORARY TABLE t_c;
