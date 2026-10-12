-- Undo pre lw_main_phase_v2.sql (vrati stav lw_main_phase.sql: len mapy 0 a 1, faza bez flagov)
DELETE FROM `hotfixes`.`phase` WHERE `ID` IN (9600, 9511) AND `VerifiedBuild` = 69933;
DELETE FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
INSERT INTO `world`.`phase_area` (`AreaId`, `PhaseId`, `Comment`)
SELECT DISTINCT c.zoneId, 9600, 'Living World main phase' FROM `world`.`creature` c WHERE c.map IN (0, 1) AND c.zoneId <> 0;
