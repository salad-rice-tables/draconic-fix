-- Cleanup: redundant dead ender links (NPC unspawned, same quest has
-- spawned same-name ender covering turn-in). Audit 2026-10-12.
-- Undo: 20261012_cleanup_redundant_enders_undo.sql
DELETE FROM `world`.`creature_questender` WHERE `id`=23544 AND `quest`=9577 AND `VerifiedBuild`=0; -- Kyle Radue covered by [50523]
DELETE FROM `world`.`creature_questender` WHERE `id`=23544 AND `quest`=11121 AND `VerifiedBuild`=0; -- Kyle Radue covered by [50523]
DELETE FROM `world`.`creature_questender` WHERE `id`=69782 AND `quest`=32474 AND `VerifiedBuild`=0; -- Wrathion covered by [64616, 207350]
DELETE FROM `world`.`creature_questender` WHERE `id`=69782 AND `quest`=32476 AND `VerifiedBuild`=0; -- Wrathion covered by [64616, 207350]
DELETE FROM `world`.`creature_questender` WHERE `id`=152261 AND `quest`=49882 AND `VerifiedBuild`=0; -- Miju covered by [131397]
DELETE FROM `world`.`creature_questender` WHERE `id`=466128 AND `quest`=84684 AND `VerifiedBuild`=0; -- ? covered by []
