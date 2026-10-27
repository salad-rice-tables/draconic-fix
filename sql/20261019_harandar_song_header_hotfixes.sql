-- =====================================================================
-- Harandar 90960: broadcast text pre Song gossip header (hotfixes DB)
-- Wiki verbatim (Rooted in Traditions / My Story, My Legacy):
--   header: "You feel a silent song in your heart..."
--   option: "Reach out and touch the song."
-- npc_text 1000000011 (world) referencuje tento ID.
-- Ak jadro custom ID v hotfixes nenačíta, header zostane prázdny
-- (žiadna regresia - doteraz bol header prázdny tiež).
-- =====================================================================
INSERT INTO broadcast_text
  (Text, Text1, ID, LanguageID, ConditionID, EmotesID, Flags,
   ChatBubbleDurationMs, VoiceOverPriorityID,
   SoundKitID1, SoundKitID2, EmoteID1, EmoteID2, EmoteID3,
   EmoteDelay1, EmoteDelay2, EmoteDelay3, VerifiedBuild)
VALUES
  ('You feel a silent song in your heart...', NULL, 1000000011,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
