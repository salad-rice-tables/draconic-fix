-- Odmeny podla wowheadu/warcraft.wiki (NEPOUZIVAT pocas testu hraca).
-- 84684 Ratts' Race: Peculiar Gem (item 228938, existuje) + 46g80s = 468000.
UPDATE `world`.`quest_template` SET `RewardItem1` = 228938, `RewardBonusMoney` = 468000 WHERE `ID` = 84684;
