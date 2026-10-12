-- Odpojenie C++ scriptov od spellov, ktore v Midnight klientovi stratili
-- prislusny efekt (validacia by vzdy zlyhala, hook by nikdy nebehal).
-- 21562 Fortitude: E0 uz nie je DUMMY ale priama aura (zvysne buffy DUMMY maju).
-- 204834 Sigil of Chains + 389860 Sigil of Spite: nemaju ZIADEN aura efekt,
--   OnEffectProc sa nema na co naviazat (demon_muzzle ostava na 204490/204598/207685).
-- Undo: spellscript_cleanup_undo.sql
DELETE FROM `world`.`spell_script_names` WHERE `spell_id` = 21562 AND `ScriptName` = 'spell_pri_power_word_fortitude';
DELETE FROM `world`.`spell_script_names` WHERE `spell_id` in (204834, 389860) AND `ScriptName` = 'spell_dh_demon_muzzle';
