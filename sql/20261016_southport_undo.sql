-- UNDO: missing quest_objectives for Southport quests (20261016_southport.sql).
-- Reverts all 2 INSERTs (IDs 3374950610-3374950611, quests 35713/35719). Nothing else touched.
DELETE FROM `world`.`quest_objectives` WHERE `ID` IN (3374950610, 3374950611);
