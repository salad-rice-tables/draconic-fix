-- Undo for 20261011_offers94871_89388.sql: removes the two added offer texts.
-- Original state: no rows for IDs 94871, 89388 in world.quest_offer_reward (verified 2026-10-11).
DELETE FROM `world`.`quest_offer_reward` WHERE `ID` IN (94871, 89388);
