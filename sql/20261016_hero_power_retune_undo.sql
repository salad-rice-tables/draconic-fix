-- UNDO hero power retune
UPDATE `spell_effect` SET `EffectBasePoints`=5, `EffectRealPointsPerLevel`=5.0 WHERE `SpellID`=1409020 AND `EffectIndex`=0;
UPDATE `spell_effect` SET `EffectBasePoints`=5, `EffectRealPointsPerLevel`=5.0 WHERE `SpellID`=1409020 AND `EffectIndex`=1;
UPDATE `spell_effect` SET `EffectBasePoints`=10, `EffectRealPointsPerLevel`=12.0 WHERE `SpellID`=1409020 AND `EffectIndex`=2;
UPDATE `spell_effect` SET `EffectBasePoints`=10, `EffectRealPointsPerLevel`=12.0 WHERE `SpellID`=1409020 AND `EffectIndex`=3;
UPDATE `spell_effect` SET `EffectBasePoints`=25 WHERE `SpellID`=1409020 AND `EffectIndex`=4;
UPDATE `spell_effect` SET `EffectBasePoints`=25 WHERE `SpellID`=1409020 AND `EffectIndex`=5;
