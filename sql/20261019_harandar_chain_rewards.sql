-- =====================================================================
-- Harandar 12.1: Rooted in Traditions (90957-90961)
-- 1) Odmeny podla Wowhead g_quests (overene 2026-10-19, quest_90957-90961.html)
--    - vsetky side:3 (obe frakcie), reqrace:524288 (Haranir), xp 1400
--    - "You will receive" = garantovane polozky (nie choice)
-- 2) Retazec questov podla Warcraft Wiki Template:Rooted In Traditions:
--    90957 -> 90958 -> 90959 -> 90960 -> 90961
--    (doteraz mal PrevQuestID=90957 len 90958, zvysok 0 / bez Next)
-- 3) npc_text 1000000011 = gossip header pre Song (wiki verbatim
--    "You feel a silent song in your heart..." - viz hotfixes broadcast_text)
-- =====================================================================

-- 1) ODMENY ------------------------------------------------------------
-- 90957 A Sacred Calling: 4x Haranir cowl (257527-257530) + 34g16s
UPDATE quest_template SET
  RewardItem1=257527, RewardAmount1=1,
  RewardItem2=257528, RewardAmount2=1,
  RewardItem3=257529, RewardAmount3=1,
  RewardItem4=257530, RewardAmount4=1,
  RewardBonusMoney=341600
WHERE ID=90957;

-- 90958 Faint Song: bez poloziek + 30g98s
UPDATE quest_template SET
  RewardItem1=0, RewardAmount1=0,
  RewardItem2=0, RewardAmount2=0,
  RewardItem3=0, RewardAmount3=0,
  RewardItem4=0, RewardAmount4=0,
  RewardBonusMoney=309800
WHERE ID=90958;

-- 90959 Answering the Call: 4x Haranir leaf (257558-257561) + 30g98s
UPDATE quest_template SET
  RewardItem1=257558, RewardAmount1=1,
  RewardItem2=257559, RewardAmount2=1,
  RewardItem3=257560, RewardAmount3=1,
  RewardItem4=257561, RewardAmount4=1,
  RewardBonusMoney=309800
WHERE ID=90959;

-- 90960 My Story, My Legacy: bez poloziek + 34g16s
UPDATE quest_template SET
  RewardItem1=0, RewardAmount1=0,
  RewardItem2=0, RewardAmount2=0,
  RewardItem3=0, RewardAmount3=0,
  RewardItem4=0, RewardAmount4=0,
  RewardBonusMoney=341600
WHERE ID=90960;

-- 90961 A Path Forward: 2x Tabard of the Haranir (246740 + 246795) + 30g98s
UPDATE quest_template SET
  RewardItem1=246740, RewardAmount1=1,
  RewardItem2=246795, RewardAmount2=1,
  RewardItem3=0, RewardAmount3=0,
  RewardItem4=0, RewardAmount4=0,
  RewardBonusMoney=309800
WHERE ID=90961;

-- 2) RETAZEC (quest_template_addon) ------------------------------------
-- Pozn.: doteraz existoval v tabulke IBA riadok 90958, zvysne 4 riadky
-- sa museli najprv vytvorit (INSERT), inak UPDATE matchne 0 riadkov.
UPDATE quest_template_addon SET PrevQuestID=90957, NextQuestID=90959 WHERE ID=90958;
INSERT INTO quest_template_addon (ID, PrevQuestID, NextQuestID, ScriptName) VALUES
  (90957, 0,     90958, ''),
  (90959, 90958, 90960, ''),
  (90960, 90959, 90961, ''),
  (90961, 90960, 0,     '');

-- 3) SONG GOSSIP HEADER (world castice, broadcast text je v hotfixes) --
INSERT INTO npc_text
  (ID, Probability0, Probability1, Probability2, Probability3,
   Probability4, Probability5, Probability6, Probability7,
   BroadcastTextID0, BroadcastTextID1, BroadcastTextID2, BroadcastTextID3,
   BroadcastTextID4, BroadcastTextID5, BroadcastTextID6, BroadcastTextID7,
   VerifiedBuild)
VALUES
  (1000000011, 1.0, 0, 0, 0, 0, 0, 0, 0,
   1000000011, 0, 0, 0, 0, 0, 0, 0, 0);


