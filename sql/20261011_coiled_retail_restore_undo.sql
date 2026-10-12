UPDATE creature_template t JOIN coiled_camp_current b ON b.entry=t.entry SET t.faction=b.faction, t.npcflag=b.npcflag;
DELETE FROM creature WHERE guid IN (SELECT guid FROM coiled_dupes_backup);
INSERT IGNORE INTO creature SELECT * FROM coiled_custom_final_backup;
REPLACE INTO creature SELECT * FROM coiled_custom_final_backup;
INSERT IGNORE INTO creature_addon SELECT * FROM coiled_custom_final_backup_addon;
