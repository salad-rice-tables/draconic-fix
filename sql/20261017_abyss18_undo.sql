-- =====================================================================
-- 86518 The Mantle of Predation v1 - UNDO (2026-10-17)
-- Vrati world DB do stavu pred 20261017_abyss18.sql
-- =====================================================================

UPDATE `quest_objectives` SET `Order`=0, `StorageIndex`=0 WHERE `ID`=459621 AND `QuestID`=86518;
UPDATE `quest_objectives` SET `Order`=1, `StorageIndex`=1, `Flags`=2 WHERE `ID`=457976 AND `QuestID`=86518;
UPDATE `quest_objectives` SET `Order`=2, `StorageIndex`=2 WHERE `ID`=457977 AND `QuestID`=86518;

DELETE FROM `gossip_menu_option` WHERE `MenuID`=38582 AND `GossipOptionID`=38582;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=912046940 AND `GossipOptionID`=912046940;
DELETE FROM `gossip_menu` WHERE `MenuID`=38582;
DELETE FROM `npc_text` WHERE `ID`=38582;

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param7`, `action_param_string`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES (235502, 0, 100, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 33, 235502, 0, 0, 0, 0, 0, NULL, 0, 7, 0, 0, 0, 0, NULL, 0.0, 0.0, 0.0, 0.0, 'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');

UPDATE `gameobject_template` SET `IconName`='', `size`=1.0 WHERE `entry`=504645;
