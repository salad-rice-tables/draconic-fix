-- =====================================================================
-- Living World: hlavna faza 9600 pre cely Eastern Kingdoms (mapa 0)
-- a Kalimdor (mapa 1). Hrac v tychto zonach vzdy vidi retail svet
-- (faza 169) + nasu fazu 9600. Vsetko nase (NPC, hliadky, karavany,
-- tabory...) bude stat vo faze 9600 - da sa to naraz vypnut zmazanim
-- phase_area riadkov a retail obsah ostane nedotknuty.
-- phase_area na ZONU plati aj pre vsetky jej podoblasti (parent area).
-- Undo: lw_main_phase_undo.sql
-- =====================================================================

DELETE FROM `world`.`phase_name` WHERE `ID` = 9600;
INSERT INTO `world`.`phase_name` (`ID`, `Name`) VALUES (9600, 'Living World Main Phase');

DELETE FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
INSERT INTO `world`.`phase_area` (`AreaId`, `PhaseId`, `Comment`)
SELECT DISTINCT c.zoneId, 9600, 'Living World main phase'
  FROM `world`.`creature` c
 WHERE c.map IN (0, 1) AND c.zoneId <> 0;

-- nase living world NPC (Hero Master, obcania, trolovia, robotnici) do fazy 9600
UPDATE `world`.`creature` SET `PhaseId` = 9600, `PhaseGroup` = 0
 WHERE `guid` BETWEEN 3001000900 AND 3001000960 AND `PhaseId` = 0;

SELECT COUNT(*) AS zones_with_main_phase FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
SELECT COUNT(*) AS our_spawns_in_main_phase FROM `world`.`creature` WHERE `PhaseId` = 9600;
