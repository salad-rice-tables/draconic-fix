-- Fix: q86717 Show Us Your Worth - add correct Wiki giver as starter (additive only).
-- Audit: C:/Wowserver/Custom/docs/audit_zulaman_batch.json (2026-10-12).
-- Wiki Start: Zul'jarra; DB starter was only 236522 Zul'jan (WRONG GIVER side).
-- Evidence: Wowhead quest page links NPC 236559 Zul'jarra
--   (C:/Wowserver/Custom/docs/scrape_blocked_batch.json, 2026-10-12, no 403);
--   236559 spawned 2x (guids 3000210644/3000210751, map 0, Atal'Aman cluster);
--   tooltip name Zul'jarra == DB creature_template name.
-- Existing (236522,86717) row KEPT (no destructive change).
-- Undo: 20261012_zulaman_86717_add_starter_undo.sql
INSERT IGNORE INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`)
VALUES (236559, 86717, 0);
