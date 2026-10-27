-- Fix: q86809 Test of Conviction - remove dead ender link (236141,86809,66263).
-- Audit: C:/Wowserver/Custom/docs/audit_zulaman_batch.json (2026-10-12).
-- Wiki Start/End: Zul'jarra (verbatim in audit). DB enders: 236126 (1 spawn),
--   236141 (0 spawns, task-list ID), 244422 (2 spawns).
-- Reason for DELETE (destructive): ender NPC 236141 has 0 rows in `creature`
--   (verified 2026-10-12), same VerifiedBuild 66263 as spawned 236126 which
--   covers the Zul'jarra turn-in; Wiki ender stays satisfied via 236126+244422.
-- Cross-check: tooltip name Zul'jarra == DB creature_template name for all three IDs.
-- Undo: 20261012_zulaman_86809_dead_ender_undo.sql
DELETE FROM `world`.`creature_questender`
WHERE `id` = 236141 AND `quest` = 86809 AND `VerifiedBuild` = 66263;
