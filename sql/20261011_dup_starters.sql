-- Duplicitni giveri: Diplomacy 86734 a Fair Breeze, Light Bloom 86737 ponukal Lorthemar 2x
-- (dva rovnake starter riadky, jeden s nezmyselnym buildom 150895). Spravny ostava (build 0).
-- V DB je celkovo 494 riadkov s buildom 150895 (systemovy zly import) - riesene LEN tieto 2 na poziadanie.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
DELETE FROM `world`.`creature_queststarter` WHERE `quest` IN (86734, 86737) AND `id` = 235787 AND `VerifiedBuild` = 150895;
