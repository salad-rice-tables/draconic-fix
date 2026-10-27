-- 20261016_southport.sql: missing quest_objectives for Southport Trading-Post quests 35713/35719 (WoD Spires of Arak, questline 49 Securing Southport).
-- Of the 14 research quests (35915/35926/35959/36023/36029/36048/36165/35713/35716/35719/35739/35782/35835/35878),
-- the other 12 already have world.quest_objectives rows 1:1 identical to retail TDB staging (tdbfull1210, 335.26091)
-- -> clone-verified, no rows written for them (see per-quest report from research session).
-- TDB staging (tdbfull1210) has ZERO rows for 35713 AND 35719 (verified SELECT) -> reconstructed per quest:
--   Wiki Objectives + Wowhead quest tooltip text (verbatim), target = live+retail quest ender entry, Type 0 (talk).
-- Conventions match existing questline rows (e.g. 35782 ID 274073 Type 0 ObjectID 82886 Amount 1 Visible 1;
--   35915 ID 274176 Type 0 ObjectID 83551 Amount 1 Visible 1) + Custom/sql/20261016_vashjir_taylor.sql pattern.
-- New IDs = MAX(world.quest_objectives.ID)+1 upward (MAX was 3374950609 on 2026-10-16; 3374950610/611 verified free).
-- VerifiedBuild 0 = reconstructed (TDB has 0 rows), cf. Custom/sql/20261016_vashjir_taylor.sql.
-- DO NOT APPLY to live DB without review. Spawn gaps (objectives still valid, no invented spawns):
--   82759 Filbert Tinkertoss and 82788 Dilbert Tinkertoss exist in world.creature_template but have ZERO rows
--   in world.creature (also zero in tdbfull1210.creature) -> GM placement workstream, see report section.
-- No starter-link SQL: all 14 quests already have live creature_queststarter rows (= TDB except 35713, see note);
--   none of the Southport giver entries are spawned, so per rule no new starter links are added.

-- 35713 The Tinkertoss Twins | Wiki Objectives: "Speak to Filbert Tinkertoss in Murkbog."
--   https://warcraft.wiki.gg/wiki/The_Tinkertoss_Twins (Start: Milly Osworth [39.5,61.3], End: Filbert Tinkertoss [56.2,42.5]).
--   Wowhead quest tooltip 35713: same text verbatim. Live quest_template.LogDescription: same text verbatim.
--   Target 82759 Filbert Tinkertoss: live+retail (tdbfull1210) creature_questender for 35713;
--   Wowhead npc 82759 = Humanoid, zone 6722 Spires of Arak [56.2,42.4-42.6] (matches Wiki end coords).
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950610, 35713, 0, 0, 0, 82759, 1, 0, 0, 0, 0, 0, 1, 'Speak to Filbert Tinkertoss in Murkbog.', 0);

-- 35719 Back on Track | Wiki Objectives: "Speak to Dilbert Tinkertoss in Veil Zekk."
--   https://warcraft.wiki.gg/wiki/Quest:Back_on_Track (Alliance section; Start: Filbert [56.2,42.5], End: Dilbert [60.2,53.2]).
--   Wowhead quest tooltip 35719: same text verbatim. Live quest_template.LogDescription: same text verbatim.
--   Target 82788 Dilbert Tinkertoss: live+retail (tdbfull1210) creature_questender for 35719;
--   Wowhead npc 82788 = Humanoid, zone 6722 Spires of Arak [60,53.8]/[60.2,53.2] (matches Wiki end coords).
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (3374950611, 35719, 0, 0, 0, 82788, 1, 0, 0, 0, 0, 0, 1, 'Speak to Dilbert Tinkertoss in Veil Zekk.', 0);
