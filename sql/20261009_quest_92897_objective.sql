-- 92897 The Preparations Are Complete: chyba objektiv (klient ho ukazuje,
-- server ho nema = nesplnitelny). Typ 3 = talk-to, Orweyna 255822 Silvermoon.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
INSERT IGNORE INTO `world`.`quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `ConditionalAmount`, `Flags`, `Flags2`, `ProgressBarWeight`, `ParentObjectiveID`, `Visible`, `Description`, `VerifiedBuild`) VALUES (92897001, 92897, 0, 0, 0, 255822, 1, 0, 0, 0, 0, 0, 1, 'Speak to Orweyna in Silvermoon City', 0);
