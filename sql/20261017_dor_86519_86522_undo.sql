-- =====================================================================
-- UNDO k 20261017_dor_86519_86522.sql (Midnight DoR 86519-86522)
-- Vrati presne hodnoty pred aplikaciou (dump 2026-10-17).
-- =====================================================================

UPDATE `quest_objectives` SET `Type` = 0, `ObjectID` = 238399
 WHERE `ID` = 457034 AND `QuestID` = 86519;

UPDATE `quest_objectives` SET `Order` = 1, `Flags` = 2
 WHERE `ID` = 457035 AND `QuestID` = 86519;

UPDATE `quest_objectives` SET `Order` = 1, `StorageIndex` = 1, `Flags` = 2
 WHERE `ID` = 457036 AND `QuestID` = 86521;

UPDATE `quest_objectives` SET `Order` = 0, `StorageIndex` = 0, `Flags` = 0
 WHERE `ID` = 459367 AND `QuestID` = 86521;

UPDATE `quest_objectives` SET `Order` = 2, `Description` = 'Weaken the storm'
 WHERE `ID` = 459218 AND `QuestID` = 86521;

UPDATE `quest_objectives` SET `Type` = 0, `ObjectID` = 9100612
 WHERE `ID` = 459272 AND `QuestID` = 86522;

DELETE FROM `phase_area` WHERE `AreaId` = 15969 AND `PhaseId` = 27428;
