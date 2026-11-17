DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1950300;
DELETE FROM `hotfixes`.`chr_classes` WHERE `ID` = 15;
DELETE FROM `hotfixes`.`chr_specialization` WHERE `ClassID` = 15;
DELETE FROM `hotfixes`.`chr_classes_x_power_types` WHERE `ID` = 9501;
DELETE FROM `world`.`class_expansion_requirement` WHERE `ClassID` = 15;
DELETE FROM `world`.`playercreateinfo` WHERE `class` = 15;
DELETE FROM `world`.`playercreateinfo_action` WHERE `class` = 15;
DELETE FROM `world`.`player_classlevelstats` WHERE `class` = 15;
