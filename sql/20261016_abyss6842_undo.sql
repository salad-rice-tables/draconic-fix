-- Undo 20261016_abyss6842.sql (obnovuje poskodene live hodnoty - NIE retail!).
UPDATE `quest_objectives` SET `StorageIndex`=2 WHERE `ID`=459120;
UPDATE `quest_objectives` SET `StorageIndex`=3, `ObjectID`=240354, `Description`=NULL WHERE `ID`=459121;
UPDATE `quest_objectives` SET `StorageIndex`=0 WHERE `ID`=459161;
UPDATE `quest_objectives` SET `Type`=0, `StorageIndex`=1, `ObjectID`=240524, `Description`="Return to T'era " WHERE `ID`=459305;
UPDATE `quest_objectives` SET `ObjectID`=0 WHERE `ID`=459477;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235662,999999999,47936);
