-- Undo pre 20261004_english_texts.sql
UPDATE `world`.`creature_text` t JOIN `world`.`custom_text_backup` b ON b.src='ct' AND b.k=CONCAT(t.CreatureID,':',t.GroupID,':',t.ID) SET t.Text=b.old;
UPDATE `hotfixes`.`broadcast_text` t JOIN `world`.`custom_text_backup` b ON b.src='bt0' AND b.k=t.ID SET t.Text=b.old;
UPDATE `hotfixes`.`broadcast_text` t JOIN `world`.`custom_text_backup` b ON b.src='bt1' AND b.k=t.ID SET t.Text1=b.old;
UPDATE `world`.`gossip_menu_option` t JOIN `world`.`custom_text_backup` b ON b.src='gmo' AND b.k=CONCAT(t.MenuID,':',t.OptionID) SET t.OptionText=b.old;
UPDATE `world`.`quest_template` t JOIN `world`.`custom_text_backup` b ON b.src='qld' AND b.k=t.ID SET t.LogDescription=b.old;
UPDATE `world`.`quest_template` t JOIN `world`.`custom_text_backup` b ON b.src='qqd' AND b.k=t.ID SET t.QuestDescription=b.old;
DROP TABLE `world`.`custom_text_backup`;
