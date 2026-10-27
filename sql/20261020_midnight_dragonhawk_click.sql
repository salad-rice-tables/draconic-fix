-- 86806 Luminous Wings (verified part only, wago 12.1.5.70391): clicking the static Empowered Dragonhawk 237221 casts "Summon Sunwell Dragonhawk" 1224696
-- (effect 90 = credit 237221 "Mount Empowered Dragonhawk"; aura 428 links 1224705 which summons vehicle creature 240226).
-- NOT included (no retail source): VehicleId and bar spells of 240226, civilian/soarling credit scripts.
CREATE TABLE IF NOT EXISTS bak_20261020_ct_dragonhawk LIKE creature_template;
INSERT INTO bak_20261020_ct_dragonhawk SELECT * FROM creature_template WHERE entry=237221 AND NOT EXISTS (SELECT 1 FROM bak_20261020_ct_dragonhawk b WHERE b.entry=237221);
UPDATE creature_template SET npcflag = npcflag | 16777216 WHERE entry = 237221;
DELETE FROM npc_spellclick_spells WHERE npc_entry = 237221 AND spell_id = 1224696;
INSERT INTO npc_spellclick_spells (npc_entry, spell_id, cast_flags, user_type) VALUES (237221, 1224696, 1, 0);
