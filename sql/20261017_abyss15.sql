-- =====================================================================
-- 86515 Hollow Hunger (Dawn of Reckoning) - v1
--  Flow: kill Severum 235495 -> loot Severum's Sigil 236752 ->
--  consume at areatrigger 9108445 (SAI credit 238379) -> Lothraxion 235504.
--  Both objectives exist; this is retail (TDB) parity:
--    457975 sigil  : Flags 0 -> 1 (tracked on minimap), StorageIndex 0 -> 1
--    457003 credit : Flags 6 -> 2 (sequenced), StorageIndex 1 -> 0
--  (Flags 6 = sequenced + OPTIONAL => kill credit was not required;
--   Flags 1 = tracked on minimap.) Order already matches TDB.
--  Undo: 20261017_abyss15_undo.sql. Reload: quest_template.
-- =====================================================================
USE world;

UPDATE `quest_objectives` SET `StorageIndex` = 1, `Flags` = 1 WHERE `ID` = 457975;
UPDATE `quest_objectives` SET `StorageIndex` = 0, `Flags` = 2 WHERE `ID` = 457003;
