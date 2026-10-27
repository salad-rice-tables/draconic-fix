-- 20261016_vashjir_duarn_undo.sql
-- UNDO for 20261016_vashjir_duarn.sql.
-- The main file performs ZERO DML (audit SELECTs only): retail has no quest_objectives rows
-- for these quests, so no rows were inserted, no starter links added, no IDs consumed.
-- Nothing to revert. Statement below is a no-op placeholder to keep the file valid SQL.

SELECT 1 AS nothing_to_undo;
