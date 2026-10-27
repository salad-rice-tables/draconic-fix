-- Erunak hub (Kelp'thar, questline 539): 5 talk objektivov, Wiki verbatim.
-- 25405 (A Rest): "Speak with Captain Taylor." -> 39887 (spawned x2)
-- 25941 (H Rest): "Speak with Legionnaire Nazgrim." -> 41711 (UNSPAWNED -> GM sheet)
-- 25812 (A Spelunking): "Speak to Private Pollard in Deepmist Grotto." -> 41324 (UNSPAWNED [64.0,59.8] -> GM)
-- 26000 (H Spelunking): "Speak to Gurrok in Deepmist Grotto." -> 41863 (UNSPAWNED [64.0,59.8] -> GM)
-- 25638 (Desperate Plea): "Take the Soggy Note to Erunak at Shallow's End." -> 41618 (spawned)
-- Type 0 (retail TDB konvencia). UNDO: _undo.sql.
INSERT INTO `world`.`quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(3374950612, 25405, 0, 0, 0, 39887, 1, 0, 0, 0, 0, 0, 1, 'Speak with Captain Taylor.', 0),
(3374950613, 25941, 0, 0, 0, 41711, 1, 0, 0, 0, 0, 0, 1, 'Speak with Legionnaire Nazgrim.', 0),
(3374950614, 25812, 0, 0, 0, 41324, 1, 0, 0, 0, 0, 0, 1, 'Speak to Private Pollard in Deepmist Grotto.', 0),
(3374950615, 26000, 0, 0, 0, 41863, 1, 0, 0, 0, 0, 0, 1, 'Speak to Gurrok in Deepmist Grotto.', 0),
(3374950616, 25638, 0, 0, 0, 41618, 1, 0, 0, 0, 0, 0, 1, 'Take the Soggy Note to Erunak at Shallow''s End.', 0);
