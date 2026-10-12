-- Coiled Isle back to retail: custom roster (9504001-9505999) leaves the world, kept in coiled_custom_final_backup (+ _addon). Retail spawns return from coiled_retail_backup / coiled_dupes_backup.
CREATE TABLE IF NOT EXISTS coiled_custom_final_backup LIKE creature;
INSERT IGNORE INTO coiled_custom_final_backup SELECT * FROM creature WHERE id BETWEEN 9504000 AND 9505999;
CREATE TABLE IF NOT EXISTS coiled_custom_final_backup_addon LIKE creature_addon;
INSERT IGNORE INTO coiled_custom_final_backup_addon SELECT a.* FROM creature_addon a JOIN coiled_custom_final_backup c ON c.guid=a.guid;
CREATE TABLE IF NOT EXISTS coiled_camp_current LIKE coiled_camp_backup;
INSERT IGNORE INTO coiled_camp_current SELECT entry,faction,npcflag FROM creature_template WHERE entry IN (SELECT entry FROM coiled_camp_backup);
DELETE a FROM creature_addon a JOIN coiled_custom_final_backup c ON c.guid=a.guid;
DELETE FROM creature WHERE id BETWEEN 9504000 AND 9505999;
REPLACE INTO creature SELECT * FROM coiled_retail_backup;
INSERT IGNORE INTO creature SELECT * FROM coiled_dupes_backup;
UPDATE creature_template t JOIN coiled_camp_backup b ON b.entry=t.entry SET t.faction=b.faction, t.npcflag=b.npcflag;
