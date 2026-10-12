-- AUDIT FIX 2026-10-11: Oathstone auto-kredity (event 64, pri OTVORENI gossipu) obchadzali quest buttony.
-- Kredit patri az po buttone (Eluna primarne + SmartAI 62->33 zaloha). Self-kredity (talk objektivy) ponechane.
-- + Rokhan 92900 backup (id 0 kolidoval s 92899 backupom -> presun na id 1).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253653 AND `source_type` = 0 AND `id` = 101 AND `event_type` = 64;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253654 AND `source_type` = 0 AND `id` = 101 AND `event_type` = 64;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253655 AND `source_type` = 0 AND `id` = 101 AND `event_type` = 64;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (253657, 253658, 253659, 253660, 258035) AND `source_type` = 0 AND `id` = 100 AND `event_type` = 64;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253661 AND `source_type` = 0 AND `id` IN (100, 101) AND `event_type` = 64;
INSERT IGNORE INTO `world`.`smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param_string`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (253661, 0, 1, 0, '', 62, 0, 100, 0, 404241, 1, 0, 0, 0, '', 33, 260795, 0, 0, 0, 0, '', 0, 7, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Rokhan 253661 - Listen - KC 260795 backup (Eluna primary)');
