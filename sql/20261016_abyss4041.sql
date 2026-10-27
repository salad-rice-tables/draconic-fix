-- 86540 Third, Blow It Up + 86541 Just In Case... v1 (Wiki verbatim).
-- 86540: Progress text (TDB ''); ender 235649 unlink (default quest UI);
-- GO-use counter + meet-kredit 240494 cez Eluna (marker nema ziadny trigger!);
-- accept scena s dabingom (Lothraxion 282995/300857).
-- 86541: starter/ender unlink (default UI); fragment-combine cez Eluna poll
-- (8x 237895 -> -8 +1x 242254, ziadny loot-zdroj pre 242254 neexistuje).
-- Undo: 20261016_abyss4041_undo.sql. Restart + .reload eluna.
UPDATE `quest_template` SET `AreaDescription`='What are you doing here? Place the manacells, now!' WHERE `ID`=86540;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235649 AND `MenuID`=999999999;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235652 AND `MenuID`=999999999;
