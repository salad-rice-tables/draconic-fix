-- Undo pre lw_engine.sql
DELETE FROM `world`.`creature` WHERE `id` IN (9900110, 9900111, 9900112);
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` IN (9900110, 9900111, 9900112);
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` IN (9900110, 9900111, 9900112);
DELETE FROM `world`.`creature_template` WHERE `entry` IN (9900110, 9900111, 9900112);
DROP TABLE IF EXISTS `world`.`lw_caravan`;
DROP TABLE IF EXISTS `world`.`lw_route_node`;
