UPDATE creature_template_gossip t JOIN bak_20261021_ct_gossip_237278 b ON b.CreatureID=t.CreatureID SET t.MenuID=b.MenuID;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=237278 AND id=102;
INSERT INTO smart_scripts SELECT * FROM bak_20261021_sai_237278 WHERE id=101 AND NOT EXISTS (SELECT 1 FROM smart_scripts s WHERE s.entryorguid=237278 AND s.source_type=0 AND s.id=101);
DELETE FROM gossip_menu_option WHERE MenuID=912046810; DELETE FROM gossip_menu WHERE MenuID=912046810;
