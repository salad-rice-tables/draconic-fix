-- Conquest of Azeroth path: chosen CoA class per character (lua/wildcard.lua + coa_kits.lua)
CREATE TABLE IF NOT EXISTS `characters`.`wildcard_coa` (
  `name` varchar(12) NOT NULL, `class` varchar(20) NOT NULL, PRIMARY KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
