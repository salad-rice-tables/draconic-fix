-- Nazvy podla wowheadu (najdene exhaustive checkom).
-- 35202: TDB vtip "Xuk Me, Right?" -> retail "Shells for Xuk".
-- 40115: preklep "Prephoof" -> "Prepfoot".
-- 41168: "Mac'Aree" -> retail nazov knihy "Eredath".
UPDATE `world`.`quest_template` SET `LogTitle` = 'Shells for Xuk' WHERE `ID` = 35202;
UPDATE `world`.`quest_template` SET `LogTitle` = 'Prepfoot Compound Treasure' WHERE `ID` = 40115;
UPDATE `world`.`quest_template` SET `LogTitle` = 'The Purple Hills of Eredath' WHERE `ID` = 41168;
