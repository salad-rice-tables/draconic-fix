-- 66579 Sounds of Healing: RewardItem1 372788 neexistuje ani na wowheade (404).
-- Odmena zrusena (gold/XP cez difficulty ostavaju). Idempotentne.
UPDATE `world`.`quest_template` SET `RewardItem1` = 0 WHERE `ID` = 66579 AND `RewardItem1` = 372788;
