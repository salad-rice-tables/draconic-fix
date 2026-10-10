-- Report-button says now go only through Eluna (rising_storm_chatter.lua, verified path).
-- SmartAI TALK rows are deleted so a (currently dead, possibly future-live) SmartAI match cannot double-speak.
-- Credit rows (links) stay as backup - duplicate credit is harmless (objective max 1).
-- Do NOT apply while players are testing; deploy before restart.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = -250580 AND `source_type` = 0 AND `id` = 1 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = -9100622 AND `source_type` = 0 AND `id` = 3 AND `comment` LIKE '%(wiki)';
