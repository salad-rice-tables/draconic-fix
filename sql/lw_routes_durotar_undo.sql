-- Undo pre lw_routes_durotar.sql
DELETE FROM `world`.`creature` WHERE `guid` BETWEEN 3001000961 AND 3001000963;
DELETE FROM `world`.`lw_route_node` WHERE `route` IN (1, 2);
