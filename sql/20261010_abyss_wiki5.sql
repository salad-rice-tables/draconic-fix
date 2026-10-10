-- Rising Storm 92061: kredit az po kliknuti na report button (nie pri otvoreni gossipu).
-- Mazu sa len 3 Oathstone auto-credit riadky pre objektivy 92061 (250580, 2x 250587).
-- Kredit ostava cez buttony: Turalyon menu 40410/opt0 (smart -250580 id0), Bellamy menu 40411/opt0 (smart -9100622 id2).
-- Ostatne Oathstone riadky (Lorthemar 235787, Umbricovia - ine questy) nemenene.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 250580 AND `source_type` = 0 AND `id` = 100 AND `event_type` = 64 AND `action_type` = 33 AND `action_param1` = 250580;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = 9100622 AND `source_type` = 0 AND `id` IN (100, 101) AND `event_type` = 64 AND `action_type` = 33 AND `action_param1` = 250587;
