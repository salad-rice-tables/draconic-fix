-- Vashj'ir Captain Taylor hub: missing quest_objectives (questline 539)
-- Quests 25547 (On Our Own Terms), 25893 (Desperate Plan), 25911 (Welcome News, Alliance)
-- had live starters/enders + texts but ZERO rows in world.quest_objectives (verified 2026-10-16).
-- tdbfull1210 staging also has 0 rows for these quests -> objectives reconstructed, not cloned.
-- All three are single Type=0 talk objectives per retail TDB data (TDB 'Speak with...'
-- rows are Type 0; core enum 3=TALKTO is NOT used by retail rows) + live chain precedent.
-- Format follows live Type-3 rows (Amount=1, Flags=0, Visible=1, VerifiedBuild=0 = custom/unverified,
-- cf. Custom/sql/20261009_quest_92897_objective.sql). New IDs = MAX(world.quest_objectives.ID)+1 upward
-- (MAX was 3374950602 at write time).
--
-- SOURCES / EVIDENCE (all verified, no invented IDs):
-- Wiki objectives (verbatim Description):
--   25547: "Speak to Captain Taylor in the Briny Cutter."
--     https://warcraft.wiki.gg/wiki/Quest:On_Our_Own_Terms
--   25893: "Meet with Engineer Hexascrub on Biel'aran Ridge."
--     https://warcraft.wiki.gg/wiki/Quest:Desperate_Plan (Alliance section)
--   25911: "Return to Captain Taylor at the Tranquil Wash."
--     https://warcraft.wiki.gg/wiki/Quest:Welcome_News (Alliance section, quest=25911)
-- Live enders (world.creature_questender): 25547->39887, 25893->40639+41666, 25911->39887.
--   Objective target = live ender spawned in quest zone:
--   39887 Captain Taylor, spawned world.creature x2, zone 4815 (Vashj'ir hub waters, seahorse/shark area)
--   41666 Engineer Hexascrub, spawned world.creature zone 5144/area 4969 AND zone 5145/area 4976
--     (2nd spawn co-located with live 25911 starter Jorlan Trueblade 41665 = Biel'aran Ridge group;
--      chosen over alternate ender 40639 @5144/4963 per retail "on Biel'aran Ridge").
-- Name verification via Wowhead tooltip API (nether.wowhead.com/tooltip/npc/<id>):
--   39887="Captain Taylor" (map zone 4815), 41666="Engineer Hexascrub" (zone 5145),
--   40639="Engineer Hexascrub" (zone 5144), 40917="Legionnaire Nazgrim".
-- NOT INCLUDED: 25973 Welcome News (Horde) "Return to Legionnaire Nazgrim at Legion's Rest."
--   Live ender 40917 exists in creature_template but has ZERO spawns in world.creature
--   (checked all 15 Legionnaire Nazgrim entries) -> UNRESOLVED, no row written (needs spawn fix first).
-- Retail-only enders 40690/40737 (25547, Briny Cutter phases), 41535 (25893), 40642 (25911, Tranquil Wash)
--   per tdbfull1210.creature_questender are NOT spawned in world -> live uses custom-clone enders above.
-- DO NOT APPLY directly to live DB without review (test on staging first).
-- TALKTO objectives use Type 0 per retail TDB data (TDB 'Speak with...' rows are all
-- Type 0, e.g. 251646; core enum value 3 is NOT used by retail rows) + live chain
-- precedent (25963 row 267050). VerifiedBuild 0 = reconstructed (TDB has 0 rows).
INSERT INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES
 (3374950603, 25547, 0, 0, 0, 39887, 1, 0, 0, 0, 0, 0, 1, 'Speak to Captain Taylor in the Briny Cutter.', 0),
 (3374950604, 25893, 0, 0, 0, 41666, 1, 0, 0, 0, 0, 0, 1, 'Meet with Engineer Hexascrub on Biel''aran Ridge.', 0),
 (3374950605, 25911, 0, 0, 0, 39887, 1, 0, 0, 0, 0, 0, 1, 'Return to Captain Taylor at the Tranquil Wash.', 0);
