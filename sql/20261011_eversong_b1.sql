-- Eversong davka 1 (scrape 2026-10-10, Wowhead Quick Facts):
-- 86742 Curious Cultivation: End len Orweyna -> Haranir ender (240663) prec.
-- 86743 Trimming the Lightbloom: Start aj End Orweyna + Inquisitive Haranir -> Haranir starter DOPLNIT.
-- Ostatne z davky (86733/35/36/37/38/39/40/41/44/45) sedia s DB.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
DELETE FROM `world`.`creature_questender` WHERE `quest` = 86742 AND `id` = 240663;
INSERT IGNORE INTO `world`.`creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES (240663, 86743, 0);
