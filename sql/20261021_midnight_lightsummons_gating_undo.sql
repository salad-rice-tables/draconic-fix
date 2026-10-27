DELETE FROM quest_template_addon WHERE ID IN (86834,86811,86848,86849,86850,86852) AND ID NOT IN (SELECT ID FROM bak_20261021_qta_ls);
UPDATE quest_template_addon a JOIN bak_20261021_qta_ls b ON b.ID=a.ID SET a.PrevQuestID=b.PrevQuestID;
