-- Undo pre spellscript_cleanup.sql (vrati odpojene C++ scripty spat).
INSERT IGNORE INTO `world`.`spell_script_names` (`spell_id`, `ScriptName`) VALUES
(21562, 'spell_pri_power_word_fortitude'),
(204834, 'spell_dh_demon_muzzle'),
(389860, 'spell_dh_demon_muzzle');
