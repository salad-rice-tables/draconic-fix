-- Undo pre descend_extra.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900170;
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` IN (1407, 1408);
DROP TABLE IF EXISTS `characters`.`hero_collection`;
DROP TABLE IF EXISTS `characters`.`hero_saga`;
