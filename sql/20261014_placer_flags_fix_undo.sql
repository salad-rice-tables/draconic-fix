-- Undo for 20261014_placer_flags_fix.sql (exact guids in backup_20261014_flagfix).
UPDATE `world`.`creature` w JOIN `world`.`backup_20261014_flagfix` b ON b.guid=w.guid SET w.`npcflag`=0, w.`unit_flags`=0, w.`unit_flags2`=0, w.`unit_flags3`=0, w.`curHealthPct`=100;
