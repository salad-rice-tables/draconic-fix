-- The Light's Summons (questline 5811) after Severing the Void had no prerequisites: Turalyon offered Ethereal Eradication and
-- Wrath Unleashed, Liadrin offered Light's Arsenal, all before Severing the Void was handed in.
-- Gate each quest on the previous storyline step (Wowhead storyline order 11-17). Strict order; loosen if retail allows parallels.
CREATE TABLE IF NOT EXISTS bak_20261021_qta_ls LIKE quest_template_addon;
INSERT INTO bak_20261021_qta_ls SELECT * FROM quest_template_addon WHERE ID IN (86834,86811,86848,86849,86850,86852) AND ID NOT IN (SELECT ID FROM bak_20261021_qta_ls);
INSERT INTO quest_template_addon (ID, PrevQuestID) VALUES
 (86834, 91274), (86811, 86834), (86848, 86811), (86849, 86848), (86850, 86849), (86852, 86850)
ON DUPLICATE KEY UPDATE PrevQuestID = VALUES(PrevQuestID);
