-- =====================================================================
-- Hero's Codex: item 9730003 (use = open Character Advancement), dummy spell 1402301,
-- ItemEffect/ItemXItemEffect 9730003. Hotfix push 1900210. Undo: dice_item_undo.sql
-- =====================================================================
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900210;
DELETE FROM `hotfixes`.`item` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_effect` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`item_x_item_effect` WHERE `ID` = 9730003;
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` = 1402301;
DELETE FROM `hotfixes`.`spell` WHERE `ID` = 1402301;
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` = 1402301;
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` = 1402301;
INSERT INTO `hotfixes`.`item` (`ID`, `ClassID`, `SubclassID`, `Material`, `InventoryType`, `SheatheType`, `SoundOverrideSubclassID`, `IconFileDataID`, `ItemGroupSoundsID`, `ContentTuningID`, `ModifiedCraftingReagentItemID`, `Unknown1200`, `CraftingQualityID`, `ItemSquishEraID`, `RecraftReagentCountPercentage`, `OrderSource`, `VerifiedBuild`) VALUES (9730003, 15, 0, 0, 0, 0, -1, 136039, 24, 0, 0, 0, 0, 0, 0, 0, 69933);
INSERT INTO `hotfixes`.`item_sparse` (`ID`, `Description`, `Display3`, `Display2`, `Display1`, `Display`, `ExpansionID`, `DmgVariance`, `LimitCategory`, `DurationInInventory`, `QualityModifier`, `BagFamily`, `StartQuestID`, `LanguageID`, `ItemRange`, `StatPercentageOfSocket1`, `StatPercentageOfSocket2`, `StatPercentageOfSocket3`, `StatPercentageOfSocket4`, `StatPercentageOfSocket5`, `StatPercentageOfSocket6`, `StatPercentageOfSocket7`, `StatPercentageOfSocket8`, `StatPercentageOfSocket9`, `StatPercentageOfSocket10`, `StatPercentEditor1`, `StatPercentEditor2`, `StatPercentEditor3`, `StatPercentEditor4`, `StatPercentEditor5`, `StatPercentEditor6`, `StatPercentEditor7`, `StatPercentEditor8`, `StatPercentEditor9`, `StatPercentEditor10`, `StatModifierBonusStat1`, `StatModifierBonusStat2`, `StatModifierBonusStat3`, `StatModifierBonusStat4`, `StatModifierBonusStat5`, `StatModifierBonusStat6`, `StatModifierBonusStat7`, `StatModifierBonusStat8`, `StatModifierBonusStat9`, `StatModifierBonusStat10`, `Stackable`, `MaxCount`, `MinReputation`, `RequiredAbility`, `AllowableRace1`, `AllowableRace2`, `SellPrice`, `BuyPrice`, `VendorStackCount`, `PriceVariance`, `PriceRandomValue`, `Flags1`, `Flags2`, `Flags3`, `Flags4`, `Flags5`, `FactionRelated`, `ModifiedCraftingReagentItemID`, `ContentTuningID`, `PlayerLevelToItemLevelCurveID`, `ItemLevelOffsetCurveID`, `ItemLevelOffsetItemLevel`, `ItemSquishEraID`, `ItemNameDescriptionID`, `RequiredTransmogHoliday`, `RequiredHoliday`, `GemProperties`, `SocketMatchEnchantmentId`, `TotemCategoryID`, `InstanceBound`, `ZoneBound1`, `ZoneBound2`, `ItemSet`, `LockID`, `PageID`, `ItemDelay`, `MinFactionID`, `RequiredSkillRank`, `RequiredSkill`, `ItemLevel`, `AllowableClass`, `ArtifactID`, `SpellWeight`, `SpellWeightCategory`, `SocketType1`, `SocketType2`, `SocketType3`, `SheatheType`, `Material`, `PageMaterialID`, `Bonding`, `DamageDamageType`, `ContainerSlots`, `RequiredPVPMedal`, `RequiredPVPRank`, `RequiredLevel`, `InventoryType`, `OverallQualityID`, `VerifiedBuild`) VALUES (9730003, 'You can reroll your starter spells through Character Advancement (Hotkey N) before reaching level 10.', '', '', '', 'Dice of Destiny', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1, 1, 0, 0, -1, -1, 0, 0, 1, 1, 0.98799997568, 64, 40960, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 4, 69933);
INSERT INTO `hotfixes`.`item_effect` (`ID`, `LegacySlotIndex`, `TriggerType`, `Charges`, `CoolDownMSec`, `CategoryCoolDownMSec`, `SpellCategoryID`, `SpellID`, `ChrSpecializationID`, `PlayerConditionID`, `VerifiedBuild`) VALUES (9730003, 0, 0, 0, 2000, 0, 0, 1402301, 0, 0, 69933);
INSERT INTO `hotfixes`.`item_x_item_effect` (`ID`, `ItemEffectID`, `ItemID`, `VerifiedBuild`) VALUES (9730003, 9730003, 9730003, 69933);
INSERT INTO `hotfixes`.`spell_name` (`ID`, `Name`, `VerifiedBuild`) VALUES (1402301, 'Dice of Destiny', 69933);
INSERT INTO `hotfixes`.`spell` (`ID`, `NameSubtext`, `Description`, `AuraDescription`, `VerifiedBuild`) VALUES (1402301, '', 'Enables Wildcard Mode.', '', 69933);
INSERT INTO `hotfixes`.`spell_misc` (`ID`, `Attributes1`, `Attributes2`, `Attributes3`, `Attributes4`, `Attributes5`, `Attributes6`, `Attributes7`, `Attributes8`,
  `Attributes9`, `Attributes10`, `Attributes11`, `Attributes12`, `Attributes13`, `Attributes14`, `Attributes15`, `Attributes16`, `Attributes17`,
  `DifficultyID`, `CastingTimeIndex`, `DurationIndex`, `PvPDurationIndex`, `RangeIndex`, `SchoolMask`, `Speed`, `LaunchDelay`, `MinDuration`,
  `SpellIconFileDataID`, `ActiveIconFileDataID`, `ContentTuningID`, `ShowFutureSpellPlayerConditionID`, `SpellVisualScript`, `ActiveSpellVisualScript`, `SpellID`, `VerifiedBuild`) VALUES
(1402301, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 136039, 0, 0, 0, 0, 0, 1402301, 69933);
INSERT INTO `hotfixes`.`spell_effect` (`ID`, `EffectAura`, `DifficultyID`, `EffectIndex`, `Effect`, `EffectAmplitude`, `EffectAttributes`, `EffectAuraPeriod`,
  `EffectBonusCoefficient`, `EffectChainAmplitude`, `EffectChainTargets`, `EffectItemType`, `EffectMechanic`, `EffectPointsPerResource`, `EffectPosFacing`,
  `EffectRealPointsPerLevel`, `EffectTriggerSpell`, `BonusCoefficientFromAP`, `PvpMultiplier`, `Coefficient`, `Variance`, `ResourceCoefficient`,
  `GroupSizeBasePointsCoefficient`, `EffectBasePoints`, `ScalingClass`, `TargetNodeGraph`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectRadiusIndex1`,
  `EffectRadiusIndex2`, `EffectSpellClassMask1`, `EffectSpellClassMask2`, `EffectSpellClassMask3`, `EffectSpellClassMask4`, `ImplicitTarget1`, `ImplicitTarget2`, `SpellID`, `VerifiedBuild`) VALUES
(1402301, 0, 0, 0, 3, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1402301, 69933);
INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(1900210, 4100021000, 1344507586, 9730003, 1, 69933),
(1900210, 4100021001, 2442913102, 9730003, 1, 69933),
(1900210, 4100021002, 1073915313, 9730003, 1, 69933),
(1900210, 4100021003, 13330255, 9730003, 1, 69933),
(1900210, 4100021004, 1187407512, 1402301, 1, 69933),
(1900210, 4100021005, 3776013982, 1402301, 1, 69933),
(1900210, 4100021006, 3322146344, 1402301, 1, 69933),
(1900210, 4100021007, 4030871717, 1402301, 1, 69933);
