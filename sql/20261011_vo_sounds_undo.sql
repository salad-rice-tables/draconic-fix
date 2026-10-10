-- UNDO: 20261011_vo_sounds.sql.
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 0 WHERE (`CreatureID`, `GroupID`) IN ((235787,0),(235787,1),(235787,2),(235787,4),(250580,0),(250580,1),(239944,0),(249272,0),(250590,0));
