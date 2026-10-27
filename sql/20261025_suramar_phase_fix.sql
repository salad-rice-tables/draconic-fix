-- Fix for quest 42230 "The Valewalker's Burden" turn-in
-- Issue: Ancient Seed Holder (GO 265435) is in phase 41089 which is cosmetic (Flags=20) and not active for players with quest in progress
-- Fix: Make phase 41089 non-cosmetic (Flags=8) and add condition for quest 42230 in progress

USE hotfixes;

-- 1. Change phase 41089 from cosmetic (20) to normal (8)
DELETE FROM `phase` WHERE `ID` = 41089;
INSERT INTO `phase` (`ID`, `Flags`) VALUES (41089, 8);

-- 2. Update condition: change mask from 64 (rewarded only) to 74 (in progress | complete | rewarded)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` = 41089 AND `SourceEntry` = 7637 AND `ElseGroup` = 1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`)
VALUES (26, 41089, 7637, 0, 1, 47, 0, 42230, 74, 0, 0, '', 'HumanTree#1 - 42230 in progress or complete or rewarded');

-- 3. Clean up test GOs (990000000101201236, 990000000101201238) on map 1220
USE world;
DELETE FROM `gameobject` WHERE `guid` IN (990000000101201236, 990000000101201238);