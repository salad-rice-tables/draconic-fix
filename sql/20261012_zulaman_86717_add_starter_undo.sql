-- Undo for 20261012_zulaman_86717_add_starter.sql.
DELETE FROM `world`.`creature_queststarter`
WHERE `id` = 236559 AND `quest` = 86717 AND `VerifiedBuild` = 0;
