-- =====================================================================
-- 86514 Lady of the Pit (Dawn of Reckoning) — v1
--  1) Torentia 235708 loot: Torentia's Sigil (238779) — objektiv 459697
--     (Type 1 item) nemal ziaden loot zdroj; TDB loot pre 235708 nema
--     ziadne riadky. QuestRequired=1, 100 %, 1x.
--  2) quest_objectives align na TDB (retail snapshot):
--     - nase: 457939 (order 3, SI 3) + 458807 (order 3, SI 3) = SI kolizia
--     - TDB:  459697 SI 4; 458807 (order 3, SI 3); 457939 (order 4, SI 2, flags 2)
-- Undo: 20261017_abyss14_undo.sql. Reload: quest_template + creature_loot_template.
-- =====================================================================
USE world;

INSERT INTO `creature_loot_template`
  (`Entry`, `ItemType`, `Item`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`, `Reference`)
VALUES
  (235708, 0, 238779, 100.0, 1, 1, 0, 1, 1, 'Torentia''s Sigil (86514 obj 459697)', NULL);

UPDATE `quest_objectives` SET `StorageIndex` = 4 WHERE `ID` = 459697;
UPDATE `quest_objectives` SET `Order` = 4, `StorageIndex` = 2, `Flags` = 2 WHERE `ID` = 457939;
