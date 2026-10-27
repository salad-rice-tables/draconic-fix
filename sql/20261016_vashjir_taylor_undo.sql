-- Undo for 20261016_vashjir_taylor.sql: removes the 3 inserted quest_objectives rows.
DELETE FROM `world`.`quest_objectives` WHERE `ID` IN (3374950603, 3374950604, 3374950605);
