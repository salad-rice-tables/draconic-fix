-- Midnight "The Light's Summons" gating (retail order from QuestLine/Wowhead series): The Gate requires Luminous Wings, Severing the Void requires The Gate.
-- Arator offered The Gate before Luminous Wings was done because these quests had no quest_template_addon row.
INSERT INTO quest_template_addon (ID, PrevQuestID) VALUES (86807, 86806), (91274, 86807)
  ON DUPLICATE KEY UPDATE PrevQuestID = VALUES(PrevQuestID);
