-- =====================================================================
-- Living World: hlavna faza 9600 v2 - KOZMETICKA faza pre cely svet.
-- Preco kozmeticka: v TrinityCore hrac, ktory dostane NEkozmeticku fazu
-- bez fazy 169, prestane vidiet vsetky bezne (retail) spawny. Kozmeticka
-- faza (Phase.db2 flag 0x10) sa len prida navrch: hrac vidi retail svet
-- + vsetko vo faze 9600. Retail questove fazovanie ostane nedotknute.
-- Rovnaky problem mala prototypova faza 9511 (Dolanaar by pocas questu
-- 95017 zmizol) - aj ta je teraz kozmeticka.
-- Undo: lw_main_phase_v2_undo.sql
-- =====================================================================

DELETE FROM `hotfixes`.`phase` WHERE `ID` IN (9600, 9511);
INSERT INTO `hotfixes`.`phase` (`ID`, `Flags`, `VerifiedBuild`) VALUES
(9600, 16, 69933),   -- Cosmetic
(9511, 16, 69933);   -- Cosmetic

-- vsetky zony vsetkych map, kde stoji aspon jeden spawn
DELETE FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
INSERT INTO `world`.`phase_area` (`AreaId`, `PhaseId`, `Comment`)
SELECT DISTINCT c.zoneId, 9600, 'Living World main phase (cosmetic overlay)'
  FROM `world`.`creature` c
 WHERE c.zoneId <> 0;

SELECT COUNT(*) AS zones_with_main_phase FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
