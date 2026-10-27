-- 20261016_vashjir_nazgrim.sql: missing quest_objectives for Nazgrim-hub quests 25948/25958/25968/25973 (Vashj'ir questline 539).
-- TDB staging (tdbfull1210, retail 335.26091) has ZERO rows for all 4 quests (verified SELECT) -> reconstructed per quest:
--   Wiki Objectives + Wowhead quest tooltip text, target = live+retail quest ender entry, Type 0 (talk) per questline convention.
-- Conventions match existing questline rows (e.g. 25963 ID 267050 Type 0 ObjectID 40918 Amount 1 Visible 1 VerifiedBuild 66384).
-- New IDs = MAX(world.quest_objectives.ID)+1 upward (MAX was 3374950602 on 2026-10-16).
-- DO NOT APPLY to live DB without review. Spawn gaps (separate workstream, objectives still valid):
--   41750/40916/40917 exist in world.creature_template and are wired as enders but have no world.creature spawn row yet.
--   41669 IS spawned (guid 347122/347123 at -6556.6,6133.2 / -6557.2,6136.4 map 0, Biel'aran Ridge).

-- 25948 Bring It On! | Wiki Objectives: "Speak with Legionnaire Nazgrim aboard the Immortal Coil."
--   Wowhead quest tooltip 25948: same text. Target 41750 Legionnaire Nazgrim: live+retail (tdbfull1210) creature_questender,
--   same faction 1735 as starter 41711; Wowhead npc 41750 = Elite, zone 4815 Kelp'thar [38.8-39.6, 31-31.6] (ship).
--   Alternate wired ender 41769 (faction 1595, zone 4815 [39.4-39.6, 30.4-30.6]) NOT used as objective target.
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950606, 25948, 0, 0, 0, 41750, 1, 0, 0, 0, 0, 0, 1, 'Speak with Legionnaire Nazgrim aboard the Immortal Coil.', 66384);

-- 25958 Looking Forward (Horde) | Wiki Objectives: "Find and speak to Captain Vilethorn north of the Quel'Dormir Gardens."
--   (+ hint sentence "Use Wavespeaker Tulra's sea horse..." excluded per TDB short-form convention, cf. 25963 "Speak to Fiasco Sizzlegrin"
--   vs its full Wowhead paragraph). Wowhead quest tooltip 25958 confirms first sentence. Target 40916 Captain Vilethorn:
--   live+retail creature_questender; Wowhead npc 40916 = Elite, zone 5144 Shimmering Expanse.
--   NOTE (review 2026-10-16): IDs moved 3374950603-606 -> 3374950606-609 (collision with vashjir_taylor.sql).
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950607, 25958, 0, 0, 0, 40916, 1, 0, 0, 0, 0, 0, 1, 'Find and speak to Captain Vilethorn north of the Quel''Dormir Gardens.', 66384);

-- 25968 Desperate Plan (Horde) | Wiki Objectives: "Meet with Fiasco Sizzlegrin on Biel'aran Ridge."
--   Wowhead quest tooltip 25968: same text. Target 41669 Fiasco Sizzlegrin: live creature_questender AND spawned in zone
--   (world.creature guid 347123 map 0 -6557.19,6136.4,-671.015 Biel'aran Ridge); Wowhead npc 41669 = Elite zone 5145.
--   NOTE: retail (tdbfull1210) ender is 41770 Fiasco Sizzlegrin (also exact name match, faction 1734, but UNSPAWNED in live);
--   41669 chosen because it is the live ender + actually spawned at the quest location (completable).
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950608, 25968, 0, 0, 0, 41669, 1, 0, 0, 0, 0, 0, 1, 'Meet with Fiasco Sizzlegrin on Biel''aran Ridge.', 66384);

-- 25973 Welcome News (Horde) | Wiki Objectives: "Return to Legionnaire Nazgrim at Legion's Rest."
--   Wowhead quest tooltip 25973: same text. Target 40917 Legionnaire Nazgrim: live+retail creature_questender;
--   Wowhead npc 40917 = Elite, zone 5144 Shimmering Expanse.
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950609, 25973, 0, 0, 0, 40917, 1, 0, 0, 0, 0, 0, 1, 'Return to Legionnaire Nazgrim at Legion''s Rest.', 66384);
