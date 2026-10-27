-- VO sweep 2026-10-21 -- full undo of every creature_text change
-- (Text / Sound / BroadcastTextId) made by vo_sweep_fix.py passes 1..N.
-- The pre-change snapshot is the table world.bak_20261021_creature_text;
-- this statement restores exactly the three columns the sweep touched.
--
--   mysql -uroot -p world < 20261021_vo_sweep_undo_all.sql
--
UPDATE creature_text c
  JOIN bak_20261021_creature_text b
    ON b.CreatureID = c.CreatureID AND b.GroupID = c.GroupID AND b.ID = c.ID
   SET c.Text = b.Text,
       c.Sound = b.Sound,
       c.BroadcastTextId = b.BroadcastTextId;

-- hotfixes DB2 imports: restore the pre-import state
--   TRUNCATE hotfixes.sound_kit;         INSERT INTO hotfixes.sound_kit         SELECT * FROM hotfixes.bak_20261021_sound_kit;
--   TRUNCATE hotfixes.sound_kit_entry;   INSERT INTO hotfixes.sound_kit_entry   SELECT * FROM hotfixes.bak_20261021_sound_kit_entry;
--   TRUNCATE hotfixes.creature_display_info; INSERT INTO hotfixes.creature_display_info SELECT * FROM hotfixes.bak_20261021_creature_display_info;
