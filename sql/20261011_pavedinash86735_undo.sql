-- Undo for 20261011_pavedinash86735.sql: removes the added Alliance offer text.
-- Original state: no row for ID 86735 in world.quest_offer_reward (verified 2026-10-11).
DELETE FROM `world`.`quest_offer_reward` WHERE `ID` = 86735;
