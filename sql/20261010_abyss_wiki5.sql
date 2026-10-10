-- Rising Storm 92061: credit only after clicking the report button (not on gossip open).
-- Deletes only the 3 Oathstone auto-credit rows for 92061 objectives (250580, 2x 250587).
-- Credit stays on buttons: Turalyon menu 40410/opt0 (Eluna primary, smart backup), Bellamy menu 40411/opt0 (same).
-- Other Oathstone rows (Lorthemar 235787, Umbrics - other quests) untouched.
-- Do NOT apply while players are testing; deploy before restart.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 250580 AND `source_type` = 0 AND `id` = 100 AND `event_type` = 64 AND `action_type` = 33 AND `action_param1` = 250580;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 9100622 AND `source_type` = 0 AND `id` IN (100, 101) AND `event_type` = 64 AND `action_type` = 33 AND `action_param1` = 250587;
