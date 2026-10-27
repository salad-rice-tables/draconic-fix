-- =====================================================================
-- 86514 Lady of the Pit — UNDO pre 20261017_abyss14.sql
-- =====================================================================
USE world;

DELETE FROM `creature_loot_template` WHERE `Entry` = 235708 AND `Item` = 238779;

UPDATE `quest_objectives` SET `StorageIndex` = 2 WHERE `ID` = 459697;
UPDATE `quest_objectives` SET `Order` = 3, `StorageIndex` = 3, `Flags` = 6 WHERE `ID` = 457939;
