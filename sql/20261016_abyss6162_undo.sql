-- Undo 20261016_abyss6162.sql.
UPDATE `conditions` SET `ConditionValue2`=66, `NegativeCondition`=0 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45757 AND `ConditionValue1`=86562 AND `ConditionValue2`=64 AND `NegativeCondition`=1;
UPDATE `conditions` SET `ConditionValue2`=66 WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=45758 AND `ConditionValue1`=86561 AND `ConditionValue2`=74 AND `NegativeCondition`=0;
UPDATE `creature` SET `PhaseId`=243142 WHERE `id`=243142 AND `PhaseId`=45756;
UPDATE `quest_template` SET `AreaDescription`='' WHERE `ID`=86561;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235532,999999999,47936),(235535,38425,0);
