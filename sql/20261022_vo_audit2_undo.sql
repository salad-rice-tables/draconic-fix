-- undo 20261022_vo_audit2

DELETE FROM world.creature_text WHERE CreatureID=25697 AND GroupID=0 AND ID=0;
DELETE FROM world.creature_text WHERE CreatureID=25697 AND GroupID=1 AND ID=0;
DELETE FROM world.creature_text WHERE CreatureID=25697 AND GroupID=2 AND ID=0;
UPDATE world.creature_text w JOIN world.bak_20261022_vo_audit2_ct b ON w.CreatureID=b.CreatureID AND w.GroupID=b.GroupID AND w.ID=b.ID
SET w.Text=b.Text, w.BroadcastTextId=b.BroadcastTextId, w.Sound=b.Sound;
