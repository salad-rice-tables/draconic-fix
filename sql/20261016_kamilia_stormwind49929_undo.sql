-- UNDO KamiliaBlow port d7831d8714 (prev values verified 2026-10-16 before apply)
UPDATE `quest_template_addon` SET `PrevQuestID` = 49929 WHERE `ID` = 50239;
UPDATE `gameobject` SET `state` = 0 WHERE `guid` = 6000625;
