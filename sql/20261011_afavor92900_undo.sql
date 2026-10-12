-- UNDO: Quest 92900 A Favor for Kinduru (20261011_afavor92900.sql).
UPDATE `world`.`quest_template` SET `QuestCompletionLog` = '' WHERE `ID` = 92900;
UPDATE `world`.`creature_template` SET `npcflag` = 0 WHERE `entry` IN (253790, 253840, 253653, 253656, 253655);
DELETE FROM `world`.`creature_queststarter` WHERE `quest` = 92900;
DELETE FROM `world`.`creature_questender` WHERE `quest` = 92900;
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 15 AND ((`SourceGroup` = 40427 AND `SourceEntry` = 0) OR (`SourceGroup` = 40429 AND `SourceEntry` = 0) OR (`SourceGroup` = 40424 AND `SourceEntry` = 1));
DELETE FROM `world`.`creature_template_gossip` WHERE `CreatureID` IN (253656, 253655, 253653, 253790) AND `MenuID` BETWEEN 40427 AND 40430;
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` BETWEEN 40427 AND 40430;
DELETE FROM `world`.`gossip_menu_option` WHERE `MenuID` = 40424 AND `OptionID` = 1;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` BETWEEN 40427 AND 40430;
DELETE FROM `world`.`npc_text` WHERE `ID` BETWEEN 9500144 AND 9500147;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` BETWEEN 9900144 AND 9900149;
DELETE FROM `world`.`creature_text` WHERE `CreatureID` IN (253651, 253790) AND `GroupID` = 6;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (253651, 253790) AND `source_type` = 0 AND `id` = 6;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253653 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62 AND `event_param1` = 404290;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253656 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62 AND `event_param1` = 404270;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 253661 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62 AND `event_param1` = 404241;
DELETE FROM `world`.`creature` WHERE `guid` IN (3001001203);
