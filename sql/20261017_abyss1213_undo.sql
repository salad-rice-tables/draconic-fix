-- Undo 20261017_abyss1213.sql.
UPDATE `quest_objectives` SET `Amount`=13, `ProgressBarWeight`=9.0 WHERE `ID` IN (86512001,86512002,86512003,86512004,86512005);
DELETE FROM `quest_objectives` WHERE `ID` IN (86512006,86512007,86512008);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (236944,39123,66527);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=236944 AND `MenuID`=912046936;
