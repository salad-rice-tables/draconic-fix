-- Harandar achievement rewards: title "Chronicler of the Haranir" (achievement 61344).
-- Title row source: CharTitles 12.1.5.70391 (wago.tools), ID 1049, MaskID 680.
-- Achievement 61344 reward text: Reward: Title: "Chronicler of the Haranir".
-- 61263 mount reward (item 263579) intentionally omitted: item template/spell not present
-- server-side yet, see In Progress notes.

-- hotfixes DB
INSERT INTO `char_titles` (`ID`, `Name`, `Name1`, `MaskID`, `Flags`, `VerifiedBuild`)
VALUES (1049, '%s, Chronicler of the Haranir', '%s, Chronicler of the Haranir', 680, 0, 70391)
ON DUPLICATE KEY UPDATE `Name`=VALUES(`Name`), `Name1`=VALUES(`Name1`),
  `MaskID`=VALUES(`MaskID`), `Flags`=VALUES(`Flags`);

-- world DB
INSERT INTO `achievement_reward` (`ID`, `TitleA`, `TitleH`, `ItemID`, `Sender`, `Subject`, `Body`, `MailTemplateID`)
VALUES (61344, 1049, 1049, 0, 0, NULL, NULL, 0)
ON DUPLICATE KEY UPDATE `TitleA`=VALUES(`TitleA`), `TitleH`=VALUES(`TitleH`);
