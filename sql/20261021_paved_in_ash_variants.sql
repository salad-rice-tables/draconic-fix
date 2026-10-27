-- 86735/86736 "Paved in Ash" are race variants (alternatives), not a sequence: both follow 86734, exclusive; 86737 follows 86734.
UPDATE quest_template_addon SET PrevQuestID=86734, ExclusiveGroup=86735 WHERE ID=86735;
UPDATE quest_template_addon SET PrevQuestID=86734, ExclusiveGroup=86735 WHERE ID=86736;
UPDATE quest_template_addon SET PrevQuestID=86734 WHERE ID=86737;
