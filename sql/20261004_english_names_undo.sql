-- Undo pre 20261004_english_names.sql
UPDATE `world`.`creature_template` t JOIN `world`.`custom_name_backup` b ON b.tbl='creature_template' AND b.id=t.entry SET t.name=b.name, t.subname=b.subname;
UPDATE `world`.`gameobject_template` t JOIN `world`.`custom_name_backup` b ON b.tbl='gameobject_template' AND b.id=t.entry SET t.name=b.name;
UPDATE `world`.`quest_template` t JOIN `world`.`custom_name_backup` b ON b.tbl='quest_template' AND b.id=t.ID SET t.LogTitle=b.name;
DROP TABLE `world`.`custom_name_backup`;
