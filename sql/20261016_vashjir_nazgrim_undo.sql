-- UNDO: missing quest_objectives for Nazgrim-hub quests (20261016_vashjir_nazgrim.sql).
-- Reverts all 4 INSERTs (IDs 3374950606-3374950609, quests 25948/25958/25968/25973). Nothing else touched.
DELETE FROM `world`.`quest_objectives` WHERE `ID` IN (3374950606, 3374950607, 3374950608, 3374950609);
