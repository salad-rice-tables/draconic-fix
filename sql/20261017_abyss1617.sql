-- =====================================================================
-- 86516 All Become Prey + 86517 Vanished in the Void v1 (2026-10-17)
-- A) 86516: zmazany stray custom objektiv 457942000; 457942 -> Order 1
-- B) 86517 parita vs tdb1210_world: novy 461134 (Maella Approached, Order 0, SI 4),
--    457972 -> Order 1, SI 1 + trim popisu, 457973 -> Order 2, SI 2,
--    457974 -> Order 4, SI 3, 460907 -> Order 5, SI 0 (464326 uz sedi Order 3, SI 5)
-- C) Carrion Essence (237807): loot do 3 chybajucich entry 235639, 238163, 243797
--    (world aj hotfixes creature_loot_template; QuestRequired, 100 %)
-- D) Gossip menu 38407 (Maella) / 38408 (Darkglen) / 38410 (Hieron): telo okna = npc_text
--    238531/241170/238530 (bts 912047135/137/139) + option "(Quest) ..." (bts 912047136/138/140)
--    + SAI zaloha (event 62, kredit pri kliknuti na option)
-- E) Zmazany Oathstone auto-kredit (SAI id100, event 64) na 238530/238531/241170 -
--    kredit 457972/457973/457974 ma prist az po kliknuti na button (rovnaka bug class ako 86518)
-- F) Import spell 1218405 "Marked as Prey" + 1263233 "[DNT] Void Bait Blocker Aura"
--    (hotfixes.spell_name/spell/spell_misc/spell_effect; realna wago data 12.1.0.69933,
--    bez hotfix_data - klient spell zna, server ho potrebuje len pre item-use gate)
-- Eluna: Custom/lua/all_become_prey_vanished.lua
-- Undo: 20261017_abyss1617_undo.sql
-- =====================================================================

-- A) 86516
DELETE FROM `quest_objectives` WHERE `ID`=457942000 AND `QuestID`=86516;
UPDATE `quest_objectives` SET `Order`=1, `Description`='' WHERE `ID`=457942 AND `QuestID`=86516;

-- B) 86517
DELETE FROM `quest_objectives` WHERE `ID`=461134 AND `QuestID`=86517;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (461134,86517,0,0,4,242933,1,0,28,0,0.0,0,1,'Maella Approached',69497);
UPDATE `quest_objectives` SET `Order`=1, `StorageIndex`=1, `Description`='Riftblade Maella found' WHERE `ID`=457972 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=2, `StorageIndex`=2 WHERE `ID`=457973 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=4, `StorageIndex`=3 WHERE `ID`=457974 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=5, `StorageIndex`=0, `Description`='' WHERE `ID`=460907 AND `QuestID`=86517;

-- C) Carrion Essence loot (3 chybajuce entry)
DELETE FROM `world`.`creature_loot_template` WHERE `Item`=237807 AND `Entry` IN (235639,238163,243797);
INSERT INTO `world`.`creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(235639,0,237807,100.0,1,1,0,1,1,NULL),
(238163,0,237807,100.0,1,1,0,1,1,NULL),
(243797,0,237807,100.0,1,1,0,1,1,NULL);
DELETE FROM `hotfixes`.`creature_loot_template` WHERE `Item`=237807 AND `Entry` IN (235639,238163,243797);
INSERT INTO `hotfixes`.`creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(235639,0,237807,100.0,1,1,0,1,1,NULL),
(238163,0,237807,100.0,1,1,0,1,1,NULL),
(243797,0,237807,100.0,1,1,0,1,1,NULL);

-- D) Gossip menu trio (38407 Maella / 38408 Darkglen / 38410 Hieron)
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38407,38408,38410);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38407,238531,0),(38408,241170,0),(38410,238530,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`BroadcastTextID0`,`VerifiedBuild`) VALUES (238531,1.0,912047135,0),(241170,1.0,912047137,0),(238530,1.0,912047139,0) ON DUPLICATE KEY UPDATE `Probability0`=VALUES(`Probability0`), `BroadcastTextID0`=VALUES(`BroadcastTextID0`);
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (38407,38408,38410);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
(38407,38407,0,0,' (Quest) Regroup with Alleria and Arator.',912047136,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
(38408,38408,0,0,' (Quest) I''ll find Hieron. Regroup with the others.',912047138,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
(38410,38410,0,0,' (Quest) Darkglen and Maella are fine.',912047140,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (238530,238531,241170) AND `source_type`=0 AND `id`=101;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
(238531,0,101,0,62,100,38407,0,33,238531,7,'86517 Maella - gossip option 0 credit (SAI backup)'),
(241170,0,101,0,62,100,38408,0,33,241170,7,'86517 Darkglen - gossip option 0 credit (SAI backup)'),
(238530,0,101,0,62,100,38410,0,33,238530,7,'86517 Hieron - gossip option 0 credit (SAI backup)');

-- E) Oathstone auto-kredit delete (kredit az po kliknuti)
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (238530,238531,241170) AND `source_type`=0 AND `id`=100;

-- F) Spell import (item 237807 on-use gate + trigger chain)
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell` WHERE `ID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` IN (1218405,1263233);
INSERT INTO `hotfixes`.`spell_name` (`ID`,`Name`,`VerifiedBuild`) VALUES (1218405,'Marked as Prey',69933),(1263233,'[DNT] Void Bait Blocker Aura',69933);
INSERT INTO `hotfixes`.`spell` (`ID`,`NameSubtext`,`Description`,`AuraDescription`,`VerifiedBuild`) VALUES (1218405,'','Mark a Slavering Ultradon with carrion essence, luring nearby beasts to attack it.','',69933),(1263233,'','','',69933);
INSERT INTO `hotfixes`.`spell_misc` (`ID`,`Attributes1`,`Attributes2`,`Attributes3`,`Attributes4`,`Attributes5`,`Attributes6`,`Attributes7`,`Attributes8`,`Attributes9`,`Attributes10`,`Attributes11`,`Attributes12`,`Attributes13`,`Attributes14`,`Attributes15`,`Attributes16`,`Attributes17`,`DifficultyID`,`CastingTimeIndex`,`DurationIndex`,`PvPDurationIndex`,`RangeIndex`,`SchoolMask`,`Speed`,`LaunchDelay`,`MinDuration`,`SpellIconFileDataID`,`ActiveIconFileDataID`,`ContentTuningID`,`ShowFutureSpellPlayerConditionID`,`SpellVisualScript`,`ActiveSpellVisualScript`,`SpellID`,`VerifiedBuild`) VALUES
(772930,536871168,34080768,128,268435456,0,128,0,0,0,0,0,0,0,0,0,0,0,0,1,21,0,4,1,25,0,0,1386551,0,3084,0,0,0,1218405,69933),
(816171,687866240,33555488,273170436,268632576,10485888,393224,12800,0,0,1048576,1,0,1048576,0,0,0,0,0,1,21,0,1,1,0,0,0,136243,0,0,0,0,0,1263233,69933);
INSERT INTO `hotfixes`.`spell_effect` (`ID`,`EffectAura`,`DifficultyID`,`EffectIndex`,`Effect`,`EffectAmplitude`,`EffectAttributes`,`EffectAuraPeriod`,`EffectBonusCoefficient`,`EffectChainAmplitude`,`EffectChainTargets`,`EffectItemType`,`EffectMechanic`,`EffectPointsPerResource`,`EffectPosFacing`,`EffectRealPointsPerLevel`,`EffectTriggerSpell`,`BonusCoefficientFromAP`,`PvpMultiplier`,`Coefficient`,`Variance`,`ResourceCoefficient`,`GroupSizeBasePointsCoefficient`,`EffectBasePoints`,`ScalingClass`,`TargetNodeGraph`,`EffectMiscValue1`,`EffectMiscValue2`,`EffectRadiusIndex1`,`EffectRadiusIndex2`,`EffectSpellClassMask1`,`EffectSpellClassMask2`,`EffectSpellClassMask3`,`EffectSpellClassMask4`,`ImplicitTarget1`,`ImplicitTarget2`,`SpellID`,`VerifiedBuild`) VALUES
(1273881,0,0,4,160,0,0,0,0,1,0,0,0,0,0,0,1263233,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,25,0,1218405,69933),
(1211853,0,0,2,2,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0.0034669356,0,0,0,0,0,0,0,0,0,0,25,0,1218405,69933),
(1215822,61,0,3,6,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,-8,0,0,0,0,0,0,0,0,0,0,25,0,1218405,69933),
(1275836,133,0,5,6,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,-60,0,0,0,0,0,0,0,0,0,0,25,0,1218405,69933),
(1203243,79,0,0,6,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,-80,0,0,127,0,0,0,0,0,0,0,25,0,1218405,69933),
(1203245,0,0,1,69,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,25,0,1218405,69933),
(1273770,4,0,0,6,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1263233,69933);
