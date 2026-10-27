-- Suramar: Crafting War Horde chain (44859 Liadrin's Command -> 44860 Trolling Them -> 44862 Arming the Rebels)
-- and the two missing "Trolling Them" insult objects (266128, 266130).
--
-- Sources:
--   Warcraft Wiki quest boxes: 44859 starts at First Arcanist Thalyssra, ends at Lady Liadrin in Meredil;
--   44860 starts/ends at Lady Liadrin; 44862 starts at Lady Liadrin, ends at Victoire.
--   Previous quests: 45265 Feeding the Rebellion -> 44859 -> 44860 -> 44862.
--   Phase 45546 "Insurrection: Warcamp" currently exists only for the Alliance breadcrumb 44743;
--   the Horde equivalent is 44859, so Liadrin/Victoire/the camp were never visible to Horde.
--   Wowhead object map positions: 266128 = 40.5, 51.9; 266130 = 40.4, 52.0.
--   World coords fitted from the three existing insult objects (Wowhead percent -> world).
--
-- Live reload: conditions, quest_template, creature_queststarter, creature_questender.
-- The two new gameobject spawns need a worldserver restart (or .gobject add for testing).

-- 1) Horde quest givers / enders
DELETE FROM creature_queststarter WHERE quest IN (44859,44860,44862);

-- 97140 = First Arcanist Thalyssra, Shal'Aran
-- 114841 = Lady Liadrin, Meredil warcamp
INSERT INTO creature_queststarter (id, quest) VALUES
 (97140,44859),
 (114841,44860),
 (114841,44862);

DELETE FROM creature_questender WHERE quest IN (44859,44860,44862);

-- 114841 = Lady Liadrin, 116256 = Victoire
INSERT INTO creature_questender (id, quest) VALUES
 (114841,44859),
 (114841,44860),
 (116256,44862);

-- 2) retail prerequisites (the 999999 sentinel means "no previous quest")
UPDATE quest_template_addon SET PrevQuestID=45265 WHERE ID=44859;

UPDATE quest_template_addon SET PrevQuestID=44859 WHERE ID=44860;

UPDATE quest_template_addon SET PrevQuestID=44860 WHERE ID=44862;

-- 3) Warcamp phase must also open for Horde after accepting Liadrin's Command
DELETE FROM conditions
 WHERE SourceTypeOrReferenceId=26 AND SourceGroup=45546 AND SourceEntry=7637
   AND ElseGroup=1 AND ConditionTypeOrReference=47 AND ConditionValue1=44859;

INSERT INTO conditions
 (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,
  ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment)
VALUES
 (26,45546,7637,0,1,47,0,44859,74,0,'',0,0,0,'','Insurrection: Warcamp - Horde (44859 accepted/complete/rewarded)');

-- 4) missing insult objects in the Horde camp, beside the Silvermoon banner at (1540.5, 4408.7)
DELETE FROM gameobject WHERE guid IN (990000000101165040,990000000101165041);

INSERT INTO gameobject
 (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,
  position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,
  spawntimesecs,animprogress,state,ScriptName,StringId,VerifiedBuild,size,visibility)
VALUES
 (990000000101165040,266128,1220,0,0,'0',0,45546,0,-1,1540.80,4402.36,121.00,0,0,0,0,1,300,255,1,'',NULL,0,-1.0,256.0),
 (990000000101165041,266130,1220,0,0,'0',0,45546,0,-1,1537.11,4408.16,121.00,0,0,0,0,1,300,255,1,'',NULL,0,-1.0,256.0);
