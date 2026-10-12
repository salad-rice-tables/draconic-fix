-- UNDO: 20261011_eversong_b1.sql.
INSERT IGNORE INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES (240663, 86742, 66102);
DELETE FROM `world`.`creature_queststarter` WHERE `quest` = 86743 AND `id` = 240663 AND `VerifiedBuild` = 0;
