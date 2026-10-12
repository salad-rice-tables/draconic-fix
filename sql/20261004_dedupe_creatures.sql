-- =====================================================================
-- Odstranenie presnych duplicitnych spawnov (rovnake NPC, miesto <1 yd,
-- rovnaka faza/phasegroup/difficulty). Ponechava sa nizsie guid.
-- Vynechane: game eventy, spawn_group, pooly, formacie.
-- Zmazane riadky sa najprv ulozia do world.custom_removed_creature.
-- Undo: 20261004_dedupe_creatures_undo.sql. Zaloha: Backup/DB/daily_20261004_013247.7z
-- =====================================================================

CREATE TABLE IF NOT EXISTS `world`.`custom_removed_creature` LIKE `world`.`creature`;

DROP TEMPORARY TABLE IF EXISTS `world`.`tmp_dupe`;
CREATE TEMPORARY TABLE `world`.`tmp_dupe` (`guid` bigint unsigned PRIMARY KEY)
SELECT DISTINCT b.guid
  FROM `world`.`creature` a
  JOIN `world`.`creature` b ON a.id = b.id AND a.guid < b.guid AND a.map = b.map
   AND a.PhaseId = b.PhaseId AND a.PhaseGroup = b.PhaseGroup AND a.phaseUseFlags = b.phaseUseFlags
   AND a.spawnDifficulties = b.spawnDifficulties
   AND ABS(a.position_x - b.position_x) < 1 AND ABS(a.position_y - b.position_y) < 1
   AND ABS(a.position_z - b.position_z) < 2
 WHERE b.guid NOT IN (SELECT guid FROM `world`.`game_event_creature`)
   AND a.guid NOT IN (SELECT guid FROM `world`.`game_event_creature`)
   AND b.guid NOT IN (SELECT spawnId FROM `world`.`spawn_group` WHERE spawnType = 0)
   AND a.guid NOT IN (SELECT spawnId FROM `world`.`spawn_group` WHERE spawnType = 0)
   AND b.guid NOT IN (SELECT spawnId FROM `world`.`pool_members` WHERE type = 0)
   AND b.guid NOT IN (SELECT memberGUID FROM `world`.`creature_formations`);

INSERT IGNORE INTO `world`.`custom_removed_creature`
SELECT c.* FROM `world`.`creature` c JOIN `world`.`tmp_dupe` d ON d.guid = c.guid;

DELETE c FROM `world`.`creature` c JOIN `world`.`tmp_dupe` d ON d.guid = c.guid;

SELECT COUNT(*) AS removed FROM `world`.`tmp_dupe`;
SELECT COUNT(*) AS saved_for_undo FROM `world`.`custom_removed_creature`;
DROP TEMPORARY TABLE `world`.`tmp_dupe`;
