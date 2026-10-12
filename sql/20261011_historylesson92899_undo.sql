-- UNDO: Quest 92899 History Lesson (20261011_historylesson92899.sql).
-- Obnovi povodny stav: CompletionLog '', npcflag 0, starter/ender prec, custom texty/menu/linky/podmienky/SmartAI/spawny prec.
-- POZOR: retail broadcast 9120472xx NEMAZAT (povodne retail data).
UPDATE `world`.`quest_template` SET `QuestCompletionLog` = '' WHERE `ID` = 92899;
UPDATE `world`.`creature_template` SET `npcflag` = 0 WHERE `entry` IN (253654, 253651, 253657, 253658, 253659, 253660, 253661, 257934, 258035);
DELETE FROM `world`.`creature_queststarter` WHERE `quest` = 92899;
DELETE FROM `world`.`creature_questender` WHERE `quest` = 92899;
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (40419, 40420, 40421, 40423, 40424, 40425, 40426);
DELETE FROM `world`.`creature_template_gossip` WHERE `CreatureID` IN (253654, 253659, 253657, 257934, 258035, 253661, 253660, 253658) AND `MenuID` BETWEEN 40419 AND 40426;
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` BETWEEN 40419 AND 40426;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` BETWEEN 40419 AND 40426;
DELETE FROM `world`.`npc_text` WHERE `ID` BETWEEN 9500136 AND 9500143;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` BETWEEN 9900136 AND 9900143;
DELETE FROM `world`.`creature_text` WHERE `CreatureID` = 253654 AND `GroupID` = 5;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253654 AND `source_type` = 0 AND `id` IN (5, 6);
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (253659, 253657, 258035, 253661, 253660, 253658) AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62 AND `event_param1` IN (404200, 404210, 404230, 404240, 404250, 404260);
DELETE FROM `world`.`creature` WHERE `guid` IN (3001001201, 3001001202);
