-- =====================================================================
-- 86515 Hollow Hunger - UNDO for 20261017_abyss15.sql (original values)
-- =====================================================================
USE world;

UPDATE `quest_objectives` SET `StorageIndex` = 0, `Flags` = 0 WHERE `ID` = 457975;
UPDATE `quest_objectives` SET `StorageIndex` = 1, `Flags` = 6 WHERE `ID` = 457003;
