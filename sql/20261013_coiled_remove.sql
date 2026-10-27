-- Coiled Isle custom NPC removal (user-ordered 2026-10-13): 5 vendor spawns (9503xxx)
-- + 17 baked isle rows (guids 3100400001+, retail IDs placed on custom island).
-- + 22 quest-link rows to unspawned Coiled NPCs (quests unobtainable from them).
-- Templates, custom quests and lua stay (harmless, no rebake: coiled:baked:v1=1).
-- Retail spawns elsewhere untouched. Backup: world.backup_20261013_coiled_remove.
-- Undo: 20261013_coiled_remove_undo.sql. NEEDS restart (temp spawns despawn).
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9504113 AND `quest`=9501122 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501149 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501150 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501151 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501152 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501153 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501154 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501155 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505101 AND `quest`=9501156 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505102 AND `quest`=9501110 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505103 AND `quest`=9501118 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_queststarter` WHERE `id`=9505103 AND `quest`=9501119 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9504113 AND `quest`=9501122 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501149 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501150 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501151 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501153 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501154 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501155 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505101 AND `quest`=9501156 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505102 AND `quest`=9501109 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature_questender` WHERE `id`=9505103 AND `quest`=9501118 AND `VerifiedBuild`=0;
DELETE FROM `world`.`creature` WHERE (`id` BETWEEN 9503000 AND 9505999) OR (`guid` BETWEEN 3100400001 AND 3100499999);
