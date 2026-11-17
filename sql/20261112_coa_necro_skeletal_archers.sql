-- =====================================================================
-- CoA Necromancer: "Animate: Skeletal Archer(s)" -> 3 armed skeletal archers
--
--   7805040 "Animate: Skeletal Archer" (the id in the level schedule)
--        effect 0 = trigger spell -> 7500330, effect 1 = empty.
--   7500330 "Animate: Skeletal Archer" = the real spell: three summon effects
--        (effect 28, SummonProperties 61 = guardian), each spawns 1 creature 7050076.
--
--   Change: the three summons spawn the new 7050130 "Skeletal Archer" instead:
--   Lesser Skeletal Warrior model (9786), bow 260391 in the main hand and
--   quiver 281244 in the ranged slot (shown on the back).
--   The arrows themselves (1308116 Arrow Barrage at most once per second,
--   1292623 Sandburst Arrow once a minute, 1239356 Blighted Arrow in between)
--   are cast by lua_scripts/coa_necro_minions.lua.
--
--   Cast visual: 7805040 gets the SpellVisual of 7500970 "Raise: Lesser Skeletal
--   Warrior" (184527) so the animation matches the raised warriors.
--
-- Undo: 20261112_coa_necro_skeletal_archers_undo.sql
-- =====================================================================
SET NAMES utf8mb4;
USE `world`;   -- temporary tables need a current database; every other statement is schema-qualified

-- 1) creature 7050130 = copy of 7050065 (Lesser Skeletal Warrior) with a ranged attack timer
DROP TEMPORARY TABLE IF EXISTS `tmp_archer_ct`;
CREATE TEMPORARY TABLE `tmp_archer_ct` AS SELECT * FROM `world`.`creature_template` WHERE `entry` = 7050065;
UPDATE `tmp_archer_ct` SET `entry` = 7050130, `name` = 'Skeletal Archer', `RangeAttackTime` = 1000 WHERE `entry` = 7050065;
DELETE FROM `world`.`creature_template` WHERE `entry` = 7050130;
INSERT INTO `world`.`creature_template` SELECT * FROM `tmp_archer_ct`;
DROP TEMPORARY TABLE `tmp_archer_ct`;

-- level / health / damage curve of the Lesser Skeletal Warrior (ContentTuning 864, HealthModifier 1.125)
DROP TEMPORARY TABLE IF EXISTS `tmp_archer_ctd`;
CREATE TEMPORARY TABLE `tmp_archer_ctd` AS SELECT * FROM `world`.`creature_template_difficulty` WHERE `Entry` = 7050065;
UPDATE `tmp_archer_ctd` SET `Entry` = 7050130;
DELETE FROM `world`.`creature_template_difficulty` WHERE `Entry` = 7050130;
INSERT INTO `world`.`creature_template_difficulty` SELECT * FROM `tmp_archer_ctd`;
DROP TEMPORARY TABLE `tmp_archer_ctd`;

-- same model as the Lesser Skeletal Warrior (9786)
DELETE FROM `world`.`creature_template_model` WHERE `CreatureID` = 7050130;
INSERT INTO `world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
SELECT 7050130, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`
FROM `world`.`creature_template_model` WHERE `CreatureID` = 7050065;

-- no creature_spell rows: the arrows are cast by the Lua minion engine, not by SmartAI
DELETE FROM `world`.`creature_template_spell` WHERE `CreatureID` = 7050130;

-- gear: bow 260391 in the main hand, quiver 281244 on the back (ranged slot = ItemID3)
DELETE FROM `world`.`creature_equip_template` WHERE `CreatureID` = 7050130;
INSERT INTO `world`.`creature_equip_template`
(`CreatureID`, `ID`, `ItemID1`, `AppearanceModID1`, `ItemVisual1`, `ItemID2`, `AppearanceModID2`, `ItemVisual2`, `ItemID3`, `AppearanceModID3`, `ItemVisual3`, `VerifiedBuild`)
VALUES (7050130, 1, 260391, 0, 0, 0, 0, 0, 281244, 0, 0, 69933);

-- 2) Animate: Skeletal Archer: the three summon effects spawn the armed archer (was 7050076)
UPDATE `hotfixes`.`spell_effect`
SET `EffectMiscValue1` = 7050130
WHERE `SpellID` = 7500330 AND `Effect` = 28;

-- 3) cast visual of Animate: Skeletal Archer = Raise: Lesser Skeletal Warrior (SpellVisual 184527)
UPDATE `hotfixes`.`spell_x_spell_visual`
SET `SpellVisualID` = 184527
WHERE `ID` = 1540922 AND `SpellID` = 7805040;
