-- 20261016_vashjir_duarn.sql
-- Vashj'ir questline research: Earthmender Duarn hub (25890,25900,25916,25917,25990,25991),
-- Sambino/Valoren/Tulra chain (25222,25216,25456,25535,25747,26005,25958,26006),
-- no-starter reports (25583,25956,25863).
--
-- FINDING: retail has NO quest_objectives rows for 15 of these 17 quests (verified in
--   tdbfull1210.quest_objectives AND hotfixes.quest_objectives (Blizzard QuestObjective DBC mirror)
--   AND Warcraft Wiki quest mechanics). These are turn-in / gossip-event / script-completed quests.
--   Inserting fabricated objectives would risk UNCOMPLETABLE quests. Therefore: ZERO DML by design.
--   New IDs from MAX(ID)+1 were NOT consumed. MAX(world.quest_objectives.ID) = 3374950602 (checked 2026-10-16).
--
-- Per-quest evidence (TDB objectives / Wiki objectives section / completion mechanic):
--   25890 Nespirah ............ TDB:0 DBC:0 | Wiki: "Find a way to communicate with Nespirah" | completes via in-shell script event (Duarn+Erunak), turn-in to Duarn. NO-ACTION.
--   25900 Making Contact ....... TDB:0 DBC:0 | Wiki: "Observe as Duarn attempts to communicate" | gossip event ("Whenever you're ready, Duarn."), no counters. NO-ACTION. NOTE: no SmartAI on 39875/41531 in world DB -> event script likely missing (C++/script task, not data).
--   25916/25990 Breaking Through  TDB:0 DBC:0 | Wiki: "Observe as Duarn attempts to speak" | gossip event ("Let's speak with Nespirah."), Voice of Nespirah yells. NO-ACTION.
--   25917/25991 We Are Not Alone  TDB:0 DBC:0 | Wiki: "Find the Alliance/Horde survivors" | completes by speaking to turn-in (Taylor/Nazgrim). NO-ACTION.
--   25222 Silver Tide Hollow .... TDB:0 DBC:0 | Wiki: "Seek out Felora Firewreath" | pure find-NPC turn-in. NO-ACTION.
--   25216 The Great Sambino .... TDB:0 DBC:0 | Wiki: "Find Sam at western Silver Tide Trench" | turn-in to Sambino. NO-ACTION.
--   25456 Back in One Piece .... TDB:0 DBC:0 | Wiki: "Return to Felora Firewreath" | pure return turn-in. NO-ACTION.
--   25535 A Powerful Need To Eat  TDB:0 DBC:0 | Wiki: "Speak to Divemaster Birmingham" | turn-in. NO-ACTION.
--   25747/25958 Looking Forward   TDB:0 DBC:0 | Wiki: "Find and speak to Dvorek/Vilethorn (seahorse ride)" | turn-in. NO-ACTION.
--   26005/26006 A Breath of Fresh Air TDB:0 DBC:0 | Wiki: "Find Taylor/Nazgrim aboard ship + Boom Boots (provided)" | turn-in. NO-ACTION.
--   25863 Chosen Burden ........ TDB:0 DBC:0 | Wiki: "Return to western Biel'aran Ridge w/ Crucible news (vision quest)" | GO starter 203305 present+spawned, ender 40586 spawned. NO-ACTION. (Wiki ext-link quest=25755 is a Wiki error: 25755 = "Visions of the Past: The Slaughter of Biel'aran Ridge".)
--   25583/25956 Upon the Scene of Battle: objective ALREADY present in world+tdb+dbc (ID 266219/266955, Type 1=item, ObjectID 59358 Broken Shard, Amount 1; StartItem 59358 in quest_template). GO starters 202714/203140 present+spawned. NO-ACTION.
--
-- Premise corrections vs task brief:
--   * Group C DOES have starters: gameobject_queststarter 25583->202714 (Enormous Skull), 25956->203140 (Broken Prong), 25863->203305 (Crucible of Nazsharin) in BOTH world and TDB; all three GOs spawned in world.
--   * World intentionally diverges from TDB on givers (clones): Duarn 39875 (not TDB 41531), Valoren 45514 (not 39881), Taylor 39887 (not 41540/42411), Naz'jar 40586 (not 42076). All clones verified SPAWNED except flagged below.
--
-- REAL BLOCKERS (not quest_objectives): unspawned enders/starters in world DB -> reported for GM placement, NO coords invented:
--   * 40643 Admiral Dvorek ... ender of 25583, 25747 (Shimmering Expanse: Tranquil Wash camp). 0 spawns; no spawned clone (41541/43986 also 0).
--   * 40916 Captain Vilethorn . ender of 25956, 25958 + starter of 25958 (Legion's Rest / forward post N of Quel'Dormir Gardens). 0 spawns; clones 41811/43985 also 0.
--   * 40919 Wavespeaker Tulra . starter of 25958, 26006 (Horde Shimmering Expanse camp). 0 spawns; clones 41813/41639 also 0.
--   * 41810 Legionnaire Nazgrim  ender (+extra starter) of 25991 (survivor ledge inside Nespirah). 0 spawns; era clones 40917/41711/41748/41750/41769/41793/41636/43100 also 0.
--   * 42410 Legionnaire Nazgrim  ender of 26006 (aboard Stygian Bounty, surface). 0 spawns.
--   * VERIFY: 40586 Lady Naz'jar (ender 25863) has 1 spawn but on MAP 643 (unknown to modern map DBC; all other Vashj'ir spawns are map 0) at (191.8, 802.4, 807.7). Confirm in-game reachability inside the Battlemaiden vision.
-- Wowhead/WoWDB page fetches were blocked (403/404/empty); verification rests on TDB + Blizzard DBC mirror + 14 Wiki quest pages (see report).
-- DO NOT APPLY narrative: this file is audit-only (SELECTs below are read-only verification).

-- Audit 1: objective coverage for the 17 quests (expect: 2 rows, 25583 + 25956 only)
SELECT QuestID, COUNT(*) AS obj_count
FROM world.quest_objectives
WHERE QuestID IN (25890,25900,25916,25917,25990,25991,25222,25216,25456,25535,25747,26005,25958,26006,25583,25956,25863)
GROUP BY QuestID;

-- Audit 2: starter coverage (creature + gameobject)
SELECT Quest, id AS starter_npc FROM world.creature_queststarter
WHERE Quest IN (25890,25900,25916,25917,25990,25991,25222,25216,25456,25535,25747,26005,25958,26006,25583,25956,25863)
ORDER BY Quest, id;
SELECT Quest, id AS starter_go FROM world.gameobject_queststarter
WHERE Quest IN (25890,25900,25916,25917,25990,25991,25222,25216,25456,25535,25747,26005,25958,26006,25583,25956,25863)
ORDER BY Quest, id;

-- Audit 3: ender NPCs with zero world.creature spawns (GM placement list)
SELECT e.Quest, e.id AS ender_npc, COUNT(c.guid) AS spawns
FROM world.creature_questender e
LEFT JOIN world.creature c ON c.id = e.id
WHERE e.Quest IN (25890,25900,25916,25917,25990,25991,25222,25216,25456,25535,25747,26005,25958,26006,25583,25956,25863)
GROUP BY e.Quest, e.id
ORDER BY spawns ASC, e.Quest;
