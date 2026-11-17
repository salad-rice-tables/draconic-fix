-- Necromancer event aura script: owner Life Force aura (1400011) and minion scaling aura (7805015) receive every damaging hit done / taken.
-- ProcFlags: DEAL melee swing/ability, ranged attack/ability, harmful ability/spell/periodic + TAKE the same (0xF33FC), damage spells, hit phase.
DELETE FROM `spell_proc` WHERE `SpellId` IN (1400011, 7805015);
INSERT INTO `spell_proc` (`SpellId`,`SchoolMask`,`SpellFamilyName`,`SpellFamilyMask0`,`SpellFamilyMask1`,`SpellFamilyMask2`,`SpellFamilyMask3`,`ProcFlags`,`ProcFlags2`,`SpellTypeMask`,`SpellPhaseMask`,`HitMask`,`AttributesMask`,`DisableEffectsMask`,`ProcsPerMinute`,`Chance`,`Cooldown`,`Charges`) VALUES
(1400011,0,0,0,0,0,0,996348,0,1,2,0,0,0,0,100,0,0),
(7805015,0,0,0,0,0,0,996348,0,1,2,0,0,0,0,100,0,0);
DELETE FROM `spell_script_names` WHERE `spell_id` IN (1400011, 7805015) AND `ScriptName` = 'aura_ascension_necromancer_event';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (1400011,'aura_ascension_necromancer_event'),(7805015,'aura_ascension_necromancer_event');

-- Cast checks: Command spells + Sacrifice Undead need minions (CoA OnSpellCheckCast)
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_ascension_necromancer_command_check';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(7504020,'spell_ascension_necromancer_command_check'),(7504489,'spell_ascension_necromancer_command_check'),(7504021,'spell_ascension_necromancer_command_check'),
(7504052,'spell_ascension_necromancer_command_check'),(7504318,'spell_ascension_necromancer_command_check'),(7504319,'spell_ascension_necromancer_command_check'),
(7504334,'spell_ascension_necromancer_command_check'),(7504905,'spell_ascension_necromancer_command_check'),(7504860,'spell_ascension_necromancer_command_check'),
(7504862,'spell_ascension_necromancer_command_check'),(7504864,'spell_ascension_necromancer_command_check'),(7504050,'spell_ascension_necromancer_command_check'),
(7504863,'spell_ascension_necromancer_command_check'),(7504316,'spell_ascension_necromancer_command_check'),(7504865,'spell_ascension_necromancer_command_check'),
(7500991,'spell_ascension_necromancer_command_check'),(7504868,'spell_ascension_necromancer_command_check'),(7504907,'spell_ascension_necromancer_command_check'),
(7504908,'spell_ascension_necromancer_command_check'),(7805871,'spell_ascension_necromancer_command_check'),
(7805027,'spell_ascension_necromancer_command_check'),(7807938,'spell_ascension_necromancer_command_check'),(7807939,'spell_ascension_necromancer_command_check'),
(7807940,'spell_ascension_necromancer_command_check'),(7807941,'spell_ascension_necromancer_command_check'),(7802121,'spell_ascension_necromancer_command_check');

-- Virulency / Infest / Expunge
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_ascension_necromancer_ability';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(7801938,'spell_ascension_necromancer_ability'),(7803781,'spell_ascension_necromancer_ability'),(7500443,'spell_ascension_necromancer_ability');

-- Shade expiry kills the owner
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'aura_ascension_necromancer_shade';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (7500730,'aura_ascension_necromancer_shade');

-- Corpse Explosion ranks
DELETE FROM `spell_script_names` WHERE `spell_id` IN (7533236,7533237,7533238,7533239) AND `ScriptName` = 'spell_ascension_necromancer_ability';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (7533236,'spell_ascension_necromancer_ability'),(7533237,'spell_ascension_necromancer_ability'),(7533238,'spell_ascension_necromancer_ability'),(7533239,'spell_ascension_necromancer_ability');

-- Ally buffs (Razorice ranks, Mandates): refuse enemy targets
INSERT IGNORE INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(7500967,'spell_ascension_necromancer_command_check'),(7501960,'spell_ascension_necromancer_command_check'),(7501961,'spell_ascension_necromancer_command_check'),
(7501962,'spell_ascension_necromancer_command_check'),(7501963,'spell_ascension_necromancer_command_check'),(7501964,'spell_ascension_necromancer_command_check'),
(7501965,'spell_ascension_necromancer_command_check'),(7501966,'spell_ascension_necromancer_command_check'),(7572214,'spell_ascension_necromancer_command_check'),
(7800199,'spell_ascension_necromancer_command_check'),(7572787,'spell_ascension_necromancer_command_check'),(7572790,'spell_ascension_necromancer_command_check'),(7680286,'spell_ascension_necromancer_command_check');
replace into spell_script_names (spell_id,ScriptName) values (7500982,'aura_ascension_necromancer_assault');
