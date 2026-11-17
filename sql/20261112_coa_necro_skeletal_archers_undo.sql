-- Undo of 20261112_coa_necro_skeletal_archers.sql
SET NAMES utf8mb4;

-- Animate: Skeletal Archer summons the old 7050076 "Skeletal Archer" again
UPDATE `hotfixes`.`spell_effect`
SET `EffectMiscValue1` = 7050076
WHERE `SpellID` = 7500330 AND `Effect` = 28;

-- cast visual of 7805040 back to SpellVisual 84258
UPDATE `hotfixes`.`spell_x_spell_visual`
SET `SpellVisualID` = 84258
WHERE `ID` = 1540922 AND `SpellID` = 7805040;

-- remove the armed archer creature
DELETE FROM `world`.`creature_equip_template` WHERE `CreatureID` = 7050130;
DELETE FROM `world`.`creature_template_spell`    WHERE `CreatureID` = 7050130;
DELETE FROM `world`.`creature_template_model`    WHERE `CreatureID` = 7050130;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 7050130;
DELETE FROM `world`.`creature_template`          WHERE `entry` = 7050130;
