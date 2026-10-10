-- Duplicate givers: Lor'themar offered Diplomacy 86734 and Fair Breeze, Light Bloom 86737 twice
-- (two identical starter rows, one with a bogus build 150895). The correct one stays (build 0).
-- The DB holds 494 rows with build 150895 total (systematic bad import) - only these 2 fixed on request.
-- Do NOT apply while players are testing; deploy before restart.
DELETE FROM `world`.`creature_queststarter` WHERE `quest` IN (86734, 86737) AND `id` = 235787 AND `VerifiedBuild` = 150895;
