-- Rising Storm 92061: prelinkovanie gossip menu na Wiki menu (oprava turn-in blockera).
-- Stav: creature_template_gossip linkuje 250580 Turalyon -> 40363 (placeholder menu, ZMAZANE vo wiki-fixe)
-- a 250587 Bellamy -> 40367 (retail TAXI menu!). Spravne Wiki menu 40410/40411 z 20261010_rising_storm_wiki.sql
-- preto hrac nikdy nevidel button "Lor'themar requires a report.", kredity nepadali, quest nesiel odovzdat.
-- Lor'themar 235787 -> 38452 (retail) nemenit.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40410 WHERE `CreatureID` = 250580 AND `MenuID` = 40363;
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 40411 WHERE `CreatureID` = 250587 AND `MenuID` = 40367;
