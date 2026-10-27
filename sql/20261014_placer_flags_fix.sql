-- Placer rows overrode template flags with explicit 0 (questgiver flag lost -> NPCs unclickable).
-- Reset nullable flags to NULL so template defaults apply (equipment_id=0 already means template).
-- 282 rows (guids in backup_20261014_flagfix).
-- Undo: 20261014_placer_flags_fix_undo.sql. NEEDS restart.
UPDATE `world`.`creature` w JOIN `world`.`backup_20261014_flagfix` b ON b.guid=w.guid SET w.`npcflag`=NULL, w.`unit_flags`=NULL, w.`unit_flags2`=NULL, w.`unit_flags3`=NULL, w.`curHealthPct`=NULL;
