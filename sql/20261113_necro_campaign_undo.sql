-- undo necro campaign
DELETE FROM hotfixes.hotfix_data WHERE Id=1960010;
DELETE FROM hotfixes.player_condition WHERE ID=9011002;
DELETE FROM hotfixes.campaign WHERE ID=9011;
DELETE FROM hotfixes.campaign_x_quest_line WHERE ID=9011;
DELETE FROM hotfixes.quest_line_x_quest WHERE ID BETWEEN 90110 AND 90119;
UPDATE world.quest_template SET LogTitle='A Disturbance on a Hidden Path', LogDescription='Follow the Hidden Path beyond the Valley of Trials and investigate the necromantic disturbance. Speak with the Tome of Oblivion you find there.', QuestDescription='Something has disturbed the balance of death in this region.\n\nI have sensed a strange necromantic presence along the Hidden Path, beyond the Valley of Trials. Its nature is unfamiliar, yet powerful.\n\nFollow the path and investigate. I want to know what has entered this land.', QuestCompletionLog='Follow the Hidden Path and read the Tome of Oblivion.' WHERE ID=9330011;
DELETE FROM hotfixes.quest_info WHERE ID=9011;
DELETE FROM hotfixes.hotfix_data WHERE Id=1960010 AND UniqueId=4100140020;
UPDATE world.quest_template SET QuestInfoID=0 WHERE ID BETWEEN 9330011 AND 9330015;
