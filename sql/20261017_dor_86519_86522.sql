-- =====================================================================
-- Midnight campaign - Dawn of Reckoning: dokoncenie 86519/86520/86521/86522
-- + 95276 "The Last Push" (Reach level 90 - bez zmeny, overene v core)
--  86519 Abyssus, Abyssum / 86520 Hunt the Light /
--  86521 Nexus-Point Xenas: Eclipse / 86522 Daylight is Breaking
--
-- Zdroj pravdy: retail TDB quest_objectives + klientske DB2 (build 70077,
-- wago 70391) - LabelId 4597 / CriteriaTree 222779/223655/207939 a vsetky
-- trigger miesta overene lokalne v klient suboroch a v core kodu.
--
-- Autor: agent (draconic-fix), 2026-10-17
-- =====================================================================

-- 86519 "Abyssus, Abyssum"
-- ---------------------------------------------------------------------
-- 457034 "Enemies slaughtered" (30): kill counter cez CreatureLabel 4597.
-- Label 4597 je na vsetkych 7 arénovych moboch (238399, 239374, 239380,
-- 239409, 240463, 240519, 243378); checkpointy 458789 (10) a 458790 (20)
-- uz LabelId pouzivaju (Flags 28 = optional+hidden).
UPDATE `quest_objectives` SET `Type` = 21, `ObjectID` = 4597
 WHERE `ID` = 457034 AND `QuestID` = 86519;

-- 457035 "Fight Alleria Windrunner": tracked + sequenced (az po 30 killoch).
-- Kredit je NATIVNY: hostilna Alleria (238386, faction 14) sa spawnuje vo
-- faze 45789 ("Alleria Aggro", area 15458) hned po prvom kille (condition
-- 48/label 457034 progress > 0) a mizne az dokoncenim objektivu; smrt
-- creature 238386 -> Type 0 kill credit. Ziadny KillCredit hack netreba.
UPDATE `quest_objectives` SET `Order` = 3, `Flags` = 3
 WHERE `ID` = 457035 AND `QuestID` = 86519;

-- 86521 "Nexus-Point Xenas: Eclipse"
-- ---------------------------------------------------------------------
-- 457036 "Enter Nexus-Point Xenas and stop Lothraxion": poradie/storage ako
-- v TDB. Kredit nativne zabitim Lothraxiona (241546, faction 14, spawn
-- v mape 2915) - fork repoint z DefeatDungeonEncounter 3333 je spravny:
-- instance_template pre map 2915 nema script, takze Type 14 by sa nikdy
-- nedokoncil. (Retail TDB: Type 14 / CriteriaTree 222779.)
UPDATE `quest_objectives` SET `Order` = 2, `StorageIndex` = 0, `Flags` = 0
 WHERE `ID` = 457036 AND `QuestID` = 86521;

-- 459367 "Talk to Alleria to queue for follower dungeon": volitelny (Flags 4),
-- poradie 1. Kredit na otvorenie gossipu Allerie (235763) existuje v SAI
-- (id 101 -> credit 259194). Nemenia sa ostatne hodnoty.
UPDATE `quest_objectives` SET `Order` = 1, `StorageIndex` = 1, `Flags` = 4
 WHERE `ID` = 459367 AND `QuestID` = 86521;

-- 459218 "Weaken the storm": doplneny retail popis + poradie 3 (sequenced
-- Flags 2 uz je). Kredit: SAI gossip 235764 (Magister Umbric) id 100 ->
-- credit 235764; POI (1278,129,-266) ukazuje na Umbríka, popis v DB je
-- retail verbatim ("Speak with Decimus to weaken the storm").
UPDATE `quest_objectives` SET `Order` = 3, `Description` = 'Speak with Decimus to weaken the storm'
 WHERE `ID` = 459218 AND `QuestID` = 86521;

-- 86522 "Daylight is Breaking"
-- ---------------------------------------------------------------------
-- 459272 "Travel to Silvermoon City": Type 14 (EnterTopLevelArea) +
-- CriteriaTree 207939 (asset 15969 = Silvermoon). Mrtvy fake-kredit
-- 9100612 (creature "Travel to Silvermoon City" bez spawnu) sa nahradza.
UPDATE `quest_objectives` SET `Type` = 14, `ObjectID` = 207939
 WHERE `ID` = 459272 AND `QuestID` = 86522;

-- Lor'themar Theron (guid 11000754, map 0) je spawntovany vo faze 27428,
-- ktora NEBOLA nikde registrovana (phase_area prazdne, ziadne conditions) ->
-- NPC bol pre vsetkych hracov neviditelny. Faza existuje v klientskych
-- datach (Flags 20 = Cosmetic; "Cosmetic - Lor'themar Theron at the
-- Sanctum of Light" je aj v phase_name). Registrujeme ju pre Silvermoon
-- (area 15969) bez podmienok - rovnaky vzor ako 9600/9600003.
INSERT INTO `phase_area` (`AreaId`, `PhaseId`, `Comment`)
 SELECT 15969, 27428, 'Lor''themar Theron at the Sanctum of Light (DoR turn-in)'
 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM (SELECT `AreaId`, `PhaseId` FROM `phase_area`) AS x
                    WHERE x.`AreaId` = 15969 AND x.`PhaseId` = 27428);
