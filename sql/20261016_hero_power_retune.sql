-- Hero power retune 2026-10-16: aura 1409020 prestrelena (lvl3 +20 dmg, lvl90 +455 flat).
-- Retail-like: base 1 +4/lvl dmg/heal, 5 +10/lvl AP, hit 25->5. UNDO: _undo.sql. RESTART nutny.
UPDATE `spell_effect` SET `EffectBasePoints`=1, `EffectRealPointsPerLevel`=4.0 WHERE `SpellID`=1409020 AND `EffectIndex`=0;
UPDATE `spell_effect` SET `EffectBasePoints`=1, `EffectRealPointsPerLevel`=4.0 WHERE `SpellID`=1409020 AND `EffectIndex`=1;
UPDATE `spell_effect` SET `EffectBasePoints`=5, `EffectRealPointsPerLevel`=10.0 WHERE `SpellID`=1409020 AND `EffectIndex`=2;
UPDATE `spell_effect` SET `EffectBasePoints`=5, `EffectRealPointsPerLevel`=10.0 WHERE `SpellID`=1409020 AND `EffectIndex`=3;
UPDATE `spell_effect` SET `EffectBasePoints`=5 WHERE `SpellID`=1409020 AND `EffectIndex`=4;
UPDATE `spell_effect` SET `EffectBasePoints`=5 WHERE `SpellID`=1409020 AND `EffectIndex`=5;
