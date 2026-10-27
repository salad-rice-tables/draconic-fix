-- spellclick on Grimfire/Stranglemist uses spell 147478 'Destroying' (has a castbar); 1254243 is only a 'Kill Credit [DNT]' spell (used by the Shrouding Totem GO)
DELETE FROM npc_spellclick_spells WHERE npc_entry IN (251863,251866);
INSERT INTO npc_spellclick_spells (npc_entry,spell_id,cast_flags,user_type) VALUES (251863,147478,1,0),(251866,147478,1,0);
