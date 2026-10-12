-- Undo for 20261011_adventuring94993_95008.sql.
-- Original state (verified 2026-10-11): no quest_offer_reward row for 95008;
-- no creature_queststarter/ender rows (259153, 94993).
DELETE FROM `world`.`quest_offer_reward` WHERE `ID` = 95008;
DELETE FROM `world`.`creature_queststarter` WHERE `id` = 259153 AND `quest` = 94993;
DELETE FROM `world`.`creature_questender` WHERE `id` = 259153 AND `quest` = 94993;
