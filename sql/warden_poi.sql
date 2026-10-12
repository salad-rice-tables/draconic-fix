-- =====================================================================
-- Warden campaign map markers (quest POI): general area blob + per-kill
-- objective blob with points at the custom spawn coords.
-- Teldrassil UiMap 57, Ashenvale UiMap 63 (from shipped TDB quests).
-- Idempotent (DELETE + INSERT). Needs restart (or `reload quest_poi`).
-- =====================================================================

DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (95000, 95001, 95002, 95003, 95004, 95005);
DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (95000, 95001, 95002, 95003, 95004, 95005);

-- --- Ch.1 Dolanaar (UiMap 57) ---
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95000, 0, 0, -1, 0, 0, 1, 57, 0, 1, 0, 0, 0, 0, 0, 0),
(95000, 0, 1, 0, 955000, 95114, 1, 57, 0, 7, 0, 0, 0, 0, 0, 0),
(95001, 0, 0, -1, 0, 0, 1, 57, 0, 1, 0, 0, 0, 0, 0, 0),
(95001, 0, 1, 0, 955001, 95115, 1, 57, 0, 7, 0, 0, 0, 0, 0, 0),
(95002, 0, 0, -1, 0, 0, 1, 57, 0, 1, 0, 0, 0, 0, 0, 0),
(95002, 0, 1, 0, 955002, 95116, 1, 57, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95000, 0, 0, 9800, 983, 1314, 0),
(95000, 1, 0, 10600.6, 633.2, 1329.7, 0),
(95000, 1, 1, 10651.3, 684.2, 1329.3, 0),
(95000, 1, 2, 10681.2, 848.7, 1322.0, 0),
(95000, 1, 3, 10633.6, 933.4, 1320.2, 0),
(95001, 0, 0, 9800, 983, 1314, 0),
(95001, 1, 0, 10531.5, 1065.1, 1321.4, 0),
(95001, 1, 1, 10508.0, 1064.5, 1326.1, 0),
(95001, 1, 2, 10482.6, 1065.9, 1327.5, 0),
(95001, 1, 3, 10516.4, 1048.0, 1323.0, 0),
(95002, 0, 0, 9800, 983, 1314, 0),
(95002, 1, 0, 10426.0, 546.9, 1333.5, 0),
(95002, 1, 1, 10432.0, 551.0, 1333.5, 0),
(95002, 1, 2, 10420.0, 542.5, 1333.5, 0),
(95002, 1, 3, 10436.0, 540.0, 1333.5, 0);

-- --- Ch.2 Ashenvale (UiMap 63) ---
INSERT INTO `world`.`quest_poi` (`QuestID`, `BlobIndex`, `Idx1`, `ObjectiveIndex`, `QuestObjectiveID`, `QuestObjectID`, `MapID`, `UiMapID`, `Priority`, `Flags`, `WorldEffectID`, `PlayerConditionID`, `NavigationPlayerConditionID`, `SpawnTrackingID`, `AlwaysAllowMergingBlobs`, `VerifiedBuild`) VALUES
(95003, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95003, 0, 1, 0, 955003, 95124, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95004, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95004, 0, 1, 0, 955004, 95125, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0),
(95005, 0, 0, -1, 0, 0, 1, 63, 0, 1, 0, 0, 0, 0, 0, 0),
(95005, 0, 1, 0, 955005, 95126, 1, 63, 0, 7, 0, 0, 0, 0, 0, 0);

INSERT INTO `world`.`quest_poi_points` (`QuestID`, `Idx1`, `Idx2`, `X`, `Y`, `Z`, `VerifiedBuild`) VALUES
(95003, 0, 0, 3420, -380, 140, 0),
(95003, 1, 0, 3439.3, -365.0, 133.9, 0),
(95003, 1, 1, 3412.7, -462.5, 160.5, 0),
(95003, 1, 2, 3408.6, -328.1, 134.0, 0),
(95003, 1, 3, 3387.5, -248.7, 120.9, 0),
(95004, 0, 0, 3420, -380, 140, 0),
(95004, 1, 0, 3369.1, -476.6, 154.3, 0),
(95004, 1, 1, 3360.7, -462.6, 154.2, 0),
(95004, 1, 2, 3354.4, -303.9, 131.6, 0),
(95004, 1, 3, 3341.9, -443.7, 151.5, 0),
(95005, 0, 0, 3420, -380, 140, 0),
(95005, 1, 0, 3445.0, -360.0, 133.9, 0),
(95005, 1, 1, 3433.0, -370.0, 133.9, 0),
(95005, 1, 2, 3442.0, -358.0, 134.0, 0),
(95005, 1, 3, 3436.0, -372.0, 134.0, 0),
(95005, 1, 4, 3450.0, -368.0, 134.0, 0);
