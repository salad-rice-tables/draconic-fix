-- Harandar odmeny podla wowheadu (overene strany questov).
-- 90534 The Home of the Haranir: 31g90s = 319000 (malo 0; vzor 90474/91588 rovnaka uroven).
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 319000 WHERE `ID` = 90534 AND `RewardBonusMoney` = 0;
