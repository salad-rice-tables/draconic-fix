-- Rising Storm 92061: relink gossip menus to Wiki menus (turn-in blocker fix).
-- State: creature_template_gossip linked 250580 Turalyon -> 40363 (placeholder menu, DELETED by wiki fix)
-- and 250587 Bellamy -> 40367 (retail TAXI menu!). Correct Wiki menus 40410/40411 from 20261010_rising_storm_wiki.sql,
-- so players never saw the "Lor'themar requires a report." button, credits never landed, quest could not be turned in.
-- Lor'themar 235787 -> 38452 (retail), do not touch.
-- Do NOT apply while players are testing; deploy before restart.
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40410 WHERE `CreatureID` = 250580 AND `MenuID` = 40363;
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40411 WHERE `CreatureID` = 250587 AND `MenuID` = 40367;
