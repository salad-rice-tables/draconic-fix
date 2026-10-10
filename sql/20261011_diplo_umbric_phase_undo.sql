UPDATE `world`.`creature` SET `PhaseId` = 45584 WHERE `guid` = 3000207639;
UPDATE `world`.`creature` SET `PhaseId` = 46726 WHERE `guid` = 3001001106;
DELETE FROM `world`.`creature_addon` WHERE `guid` = 3001001200;
DELETE FROM `world`.`creature` WHERE `guid` = 3001001200;
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` IN (9600002, 9600003, 9600004);
DELETE FROM `world`.`phase_area` WHERE `PhaseId` IN (9600002, 9600003, 9600004);
DELETE FROM `world`.`phase_name` WHERE `ID` IN (9600002, 9600003, 9600004);
