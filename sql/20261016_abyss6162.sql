-- 86561 A Strange, Different World + 86562 Dancing with Death v1 (Wiki verbatim).
-- NASLEDUJUCI CUSTOM-PHASING BUG: 45757 vyzadovala 86562-hotovy (nikdy neaktivna pocas
-- 86561) a 45758 vyzadovala 86561-hotovy (turn-in neviditelny) -> opravene na
-- walkable logiku (45757: 86561 NOT-66 + 86562 NOT-64; 45758: 86561/74 + 86565 NOT-66).
-- Scytheryp 243142 mal PhaseId=243142 (neexistujuca faza!) -> 45756.
-- 86561: Alleria unlink (default quest UI), Progress text (TDB ''), accept scena (Eluna).
-- 86565 NIeriesene (live objektivy != TDB - treba Wiki No_Prayer_for_the_Wicked, nabuduce).
-- Undo: 20261016_abyss6162_undo.sql. Aktivacia: restart + .reload eluna.
UPDATE `conditions` SET `ConditionValue2`=64, `NegativeCondition`=1 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45757 AND `ConditionValue1`=86562 AND `ConditionValue2`=66 AND `NegativeCondition`=0;
UPDATE `conditions` SET `ConditionValue2`=74 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45758 AND `ConditionValue1`=86561 AND `ConditionValue2`=66 AND `NegativeCondition`=0;
UPDATE `creature` SET `PhaseId`=45756 WHERE `id`=243142 AND `PhaseId`=243142;
UPDATE `quest_template` SET `AreaDescription`='The metal on these creatures... it seems particularly conductive to magical energies. Interesting.' WHERE `ID`=86561;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235532 AND `MenuID`=999999999;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235535 AND `MenuID`=38425;
