-- Replaces 20261021_midnight_behemoth_scenery.sql (user: the Behemoth must appear only in its quest phase, not always).
-- Voidwake Behemoth 236684 is the target of the Wrath Unleashed objective "Aid Turalyon in attacking the Voidwake Behemoth" (credit 242871)
-- -> belongs to the Wrath Unleashed phase 45580 ("Heroes on the way": condition quest 86849 in progress), together with Turalyon, Liadrin and the Vanguard.
-- Stays hostile (faction 14) but pacified so it does not kill the rider; template damage restored from backup.
UPDATE creature_template t JOIN bak_20261021_behemoth_ct b ON b.entry=t.entry SET t.faction=b.faction, t.unit_flags=b.unit_flags | 0x00020000 WHERE t.entry=236684;
UPDATE creature_template_difficulty d JOIN bak_20261021_behemoth_ctd b ON b.Entry=d.Entry AND b.DifficultyID=d.DifficultyID SET d.DamageModifier=b.DamageModifier WHERE d.Entry=236684;
CREATE TABLE IF NOT EXISTS bak_20261021_behemoth_cr LIKE creature;
INSERT INTO bak_20261021_behemoth_cr SELECT * FROM creature WHERE guid=3000202217 AND guid NOT IN (SELECT guid FROM bak_20261021_behemoth_cr);
UPDATE creature SET PhaseId = 45580 WHERE guid = 3000202217;
