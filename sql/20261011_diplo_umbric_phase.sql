-- Diplomacy 86734: Umbric is a Void projection that is there only WHILE the quest is incomplete (the scene), and he disappears for that player only
-- when the objective is credited (retail does this with phases; resets when the quest is taken again).
--   P2 9600002: new phase, active while 86734 is incomplete (state 8)  -> new Umbric spawn guid 3001001200 (projection aura 166452 + purple hologram 261627)
--   P3 9600003: the existing Umbric 3000207639 (phase 45584, "86733 complete/rewarded") now needs also NOT(86734 incomplete|complete)
--   P4 9600004: the existing Umbric 3001001106 (phase 46726, "92895 NOT complete/rewarded") now needs also NOT(86734 incomplete|complete)
DELETE FROM `world`.`phase_area` WHERE `PhaseId` IN (9600002, 9600003, 9600004);
DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId` = 26 AND `SourceGroup` IN (9600002, 9600003, 9600004);
DELETE FROM `world`.`phase_name` WHERE `ID` IN (9600002, 9600003, 9600004);
INSERT INTO `world`.`phase_name` (`ID`,`Name`) VALUES (9600002,'Diplomacy 86734: Umbric projection'),(9600003,'Umbric (86733 done) not during Diplomacy'),(9600004,'Umbric (12.0.7) not during Diplomacy');
INSERT INTO `world`.`phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES (15969,9600002,'Diplomacy scene'),(15969,9600003,'Umbric normal'),(15969,9600004,'Umbric normal 12.0.7');
INSERT INTO `world`.`conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`ConditionStringValue1`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
 (26,9600002,15969,0,0,47,0,86734,8,0,'',0,0,0,'','86734 incomplete'),
 (26,9600003,15969,0,0,47,0,86733,66,0,'',0,0,0,'','86733 complete or rewarded'),
 (26,9600003,15969,0,0,47,0,86734,10,0,'',1,0,0,'','NOT 86734 incomplete/complete'),
 (26,9600004,15969,0,0,47,0,92895,66,0,'',1,0,0,'','NOT 92895 complete or rewarded'),
 (26,9600004,15969,0,0,47,0,86734,10,0,'',1,0,0,'','NOT 86734 incomplete/complete');
UPDATE `world`.`creature` SET `PhaseId` = 9600003 WHERE `guid` = 3000207639;
UPDATE `world`.`creature` SET `PhaseId` = 9600004 WHERE `guid` = 3001001106;
DELETE FROM `world`.`creature` WHERE `guid` = 3001001200;
INSERT INTO `world`.`creature` SELECT 3001001200,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,9600002,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`,`size` FROM `world`.`creature` WHERE `guid` = 3000207639;
DELETE FROM `world`.`creature_addon` WHERE `guid` = 3001001200;
INSERT INTO `world`.`creature_addon` (`guid`,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`)
SELECT 3001001200,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,'166452 261627' FROM `world`.`creature_addon` WHERE `guid` = 3000207639;
