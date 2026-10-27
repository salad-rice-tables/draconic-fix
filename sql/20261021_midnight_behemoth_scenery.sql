-- 12.0 harbor: Voidwake Behemoth 236684 is scenery in the harbor backdrop of Wrath Unleashed. Live spawned it hostile (faction 14, phase 0, always)
-- and it killed the player. Scenery giant: never attacks, cannot be attacked, no damage.
CREATE TABLE IF NOT EXISTS bak_20261021_behemoth_ct LIKE creature_template;
INSERT INTO bak_20261021_behemoth_ct SELECT * FROM creature_template WHERE entry=236684 AND entry NOT IN (SELECT entry FROM bak_20261021_behemoth_ct);
CREATE TABLE IF NOT EXISTS bak_20261021_behemoth_ctd LIKE creature_template_difficulty;
INSERT INTO bak_20261021_behemoth_ctd SELECT * FROM creature_template_difficulty WHERE Entry=236684 AND Entry NOT IN (SELECT Entry FROM bak_20261021_behemoth_ctd);
UPDATE creature_template SET faction = 35, unit_flags = unit_flags | 0x00020002 WHERE entry = 236684;   -- friendly, pacified, non-attackable
UPDATE creature_template_difficulty SET DamageModifier = 0 WHERE Entry = 236684;
