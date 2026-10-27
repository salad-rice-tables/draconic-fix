UPDATE creature_template t JOIN bak_20261020_ct_dragonhawk b ON b.entry=t.entry SET t.npcflag=b.npcflag WHERE t.entry=237221;
DELETE FROM npc_spellclick_spells WHERE npc_entry = 237221 AND spell_id = 1224696;
