-- Fix: Zul'jan 245646 spawn guid 3000205352 is undermap (position_z = 0.0).
-- Audit: C:/Wowserver/Custom/docs/audit_zulaman_batch.json (2026-10-12).
-- Evidence: sibling spawn guid 3000211638 (same entry 245646) at
--   5057.44,-8229.41,139.91 (distance ~6.6 yd, within +-15 yd cross-check);
--   broken row zoneId 15947 matches tooltip zone family; x/y already in cluster.
-- Minimal change: only position_z 0.0 -> 139.91 (phase/coords kept).
-- Undo: 20261012_zulaman_245646_broken_z_undo.sql
UPDATE `world`.`creature` SET `position_z` = 139.91 WHERE `guid` = 3000205352;
