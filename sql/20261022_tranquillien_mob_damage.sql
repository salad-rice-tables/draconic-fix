-- Shadowfall (Tranquillien) hostile quest mobs must not kill the player: damage x0.1 (same rule as 20261021_whispers_mob_damage).
CREATE TABLE IF NOT EXISTS bak_20261022_ctd_damage AS SELECT Entry,DifficultyID,DamageModifier FROM creature_template_difficulty WHERE Entry IN (236631,236777,241674,241723,236627,236628,245801,245802,245803,245804,245805,246029,242143,236687);
UPDATE creature_template_difficulty SET DamageModifier=0.1 WHERE Entry IN (236631,236777,241674,241723,236627,236628,245801,245802,245803,245804,245805,246029,242143,236687) AND DamageModifier>0.1;
