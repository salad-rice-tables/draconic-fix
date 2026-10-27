-- Fairbreeze/Silvermoon: remove 5 non-retail Lor'themar 235787 dupes (TDB has only guid 11000754).
-- 3000213364 z=-7.4 (broken), others scattered Eversong wilds; quest 86735/86736 stays via retail spawn.
-- Backup: world.backup_20261013_lorthemar_dedup. Undo: 20261013_lorthemar_dedup_undo.sql
DELETE FROM `world`.`creature` WHERE `guid` IN (3000207578,3000208816,3000209301,3000209472,3000213364);
