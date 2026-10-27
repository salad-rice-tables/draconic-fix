-- =====================================================================
-- 20261019_harandar_90960.sql
-- My Story, My Legacy (90960): doplnenie SQL casti.
--   1) Odstrani bug-class SAI "Oathstone Chat" (event 64 = credit na
--      gossip OPEN) na 245096/245097/246456/246486 — kredity sa
--      namiesto toho davaju v Eluna harandar_90960.lua na gossip SELECT.
--   2) Vytvori prazdnu npc_text (1000000010) pre dynamicky gossip header.
--   3) Forgotten Melody 246546: npcflag 0 -> 3 (potrebuje gossip "reach out").
--   4) Shandris vision 246486: npcflag 3 -> 0 (len vision, neinteraktivna).
-- Reload: .reload creature_template + .reload smart_scripts + .reload npc_text
--         + .reload eluna   (bez restartu)
-- =====================================================================

-- 1) Odstran bug-class SAI (credit na gossip OPEN)
DELETE FROM world.smart_scripts
WHERE source_type=0 AND event_type=64 AND action_type=33
  AND entryorguid IN (245096, 245097, 246456, 246486);

-- 2) Prazdna npc_text pre gossip header (ziadny text, option nesie flavor)
INSERT INTO world.npc_text
  (ID, Probability0, Probability1, Probability2, Probability3,
   Probability4, Probability5, Probability6, Probability7,
   BroadcastTextID0, BroadcastTextID1, BroadcastTextID2, BroadcastTextID3,
   BroadcastTextID4, BroadcastTextID5, BroadcastTextID6, BroadcastTextID7,
   VerifiedBuild)
VALUES
  (1000000010, 1.0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0, 0);

-- 3) Forgotten Melody: potrebuje gossip
UPDATE world.creature_template SET npcflag=3 WHERE entry=246546;

-- 4) Shandris vision: neinteraktivna
UPDATE world.creature_template SET npcflag=0 WHERE entry=246486;
