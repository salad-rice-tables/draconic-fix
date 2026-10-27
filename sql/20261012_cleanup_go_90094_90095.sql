-- Cleanup: wrong-table GO links for Harandar quests 90094/90095.
-- GO 900014/900015 = Anima-charged Crystal (Shadowlands), 0 spawns; unrelated.
-- Creature starter+ender (239650/239795/243884, all spawned) cover the flow.
-- Audit 2026-10-12. Undo: 20261012_cleanup_go_90094_90095_undo.sql
DELETE FROM `world`.`gameobject_questender` WHERE `id`=900014 AND `quest`=90094 AND `VerifiedBuild`=0;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id`=900014 AND `quest`=90095 AND `VerifiedBuild`=0;
DELETE FROM `world`.`gameobject_questender` WHERE `id`=900015 AND `quest`=90095 AND `VerifiedBuild`=0;
