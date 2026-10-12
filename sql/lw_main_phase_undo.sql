-- Undo pre lw_main_phase.sql
UPDATE `world`.`creature` SET `PhaseId` = 0 WHERE `PhaseId` = 9600;
DELETE FROM `world`.`phase_area` WHERE `PhaseId` = 9600;
DELETE FROM `world`.`phase_name` WHERE `ID` = 9600;
