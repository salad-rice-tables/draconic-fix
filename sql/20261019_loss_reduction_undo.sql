-- Undo k 20261019_loss_reduction.sql (Loss Reduction, quest 25179, Durotar)
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25179 AND `PrevQuestID` = 25173;
DELETE FROM `creature_queststarter` WHERE `id` = 39270 AND `quest` = 25179;
