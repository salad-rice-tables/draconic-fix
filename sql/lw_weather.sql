-- =====================================================================
-- Living World: pocasie podla lore pre zony, ktore ho nemali.
-- Stlpce: jar dazd/sneh/burka, leto ..., jesen ..., zima ...
-- "storm" = piesocna burka (len puste). INSERT IGNORE: existujuce zony
-- (35 retail riadkov) sa nemenia. Undo: lw_weather_undo.sql
-- =====================================================================
INSERT IGNORE INTO `world`.`game_weather` (`zone`,
 `spring_rain_chance`, `spring_snow_chance`, `spring_storm_chance`,
 `summer_rain_chance`, `summer_snow_chance`, `summer_storm_chance`,
 `fall_rain_chance`, `fall_snow_chance`, `fall_storm_chance`,
 `winter_rain_chance`, `winter_snow_chance`, `winter_storm_chance`, `ScriptName`) VALUES
-- Kalimdor
(14,    5, 0, 10,   2, 0, 15,   5, 0, 10,   8, 0,  5, ''),  -- Durotar: sucho, prasne burky
(1637,  5, 0,  5,   2, 0, 10,   5, 0,  5,   8, 0,  5, ''),  -- Orgrimmar
(17,    8, 0, 10,   3, 0, 15,   8, 0, 10,  10, 0,  5, ''),  -- Northern Barrens
(215,  20, 0,  0,  10, 0,  0,  20, 0,  0,  15, 5,  0, ''),  -- Mulgore
(1638, 20, 0,  0,  10, 0,  0,  20, 0,  0,  15, 5,  0, ''),  -- Thunder Bluff
(1657, 20, 0,  0,  10, 0,  0,  20, 0,  0,  20, 0,  0, ''),  -- Darnassus
(148,  30, 0,  0,  20, 0,  0,  35, 0,  0,  30, 5,  0, ''),  -- Darkshore
(331,  25, 0,  0,  15, 0,  0,  30, 0,  0,  25, 5,  0, ''),  -- Ashenvale
(406,  15, 0,  0,  10, 0,  0,  15, 0,  0,  10, 10, 0, ''),  -- Stonetalon
(405,   3, 0, 10,   2, 0, 15,   3, 0, 10,   5, 0, 10, ''),  -- Desolace
(400,   5, 0,  5,   2, 0, 10,   5, 0,  5,   5, 0,  5, ''),  -- Thousand Needles
(15,   40, 0,  0,  45, 0,  0,  40, 0,  0,  35, 0,  0, ''),  -- Dustwallow Marsh
(357,  40, 0,  0,  35, 0,  0,  40, 0,  0,  40, 0,  0, ''),  -- Feralas
(16,   20, 0,  0,  15, 0,  0,  25, 0,  0,  20, 5,  0, ''),  -- Azshara
(361,  25, 0,  0,  20, 0,  0,  25, 0,  0,  20, 5,  0, ''),  -- Felwood
(493,  15, 0,  0,  10, 0,  0,  15, 0,  0,  10, 15, 0, ''),  -- Moonglade
(618,   0, 35, 0,   0, 20, 0,   0, 40, 0,   0, 60, 0, ''),  -- Winterspring
(490,  35, 0,  0,  40, 0,  0,  35, 0,  0,  35, 0,  0, ''),  -- Un'Goro
(440,   0, 0, 20,   0, 0, 30,   0, 0, 20,   2, 0, 15, ''),  -- Tanaris
(1377,  0, 0, 30,   0, 0, 35,   0, 0, 30,   0, 0, 25, ''),  -- Silithus
(616,  15, 5,  0,  10, 0,  0,  15, 10, 0,   5, 30, 0, ''),  -- Mount Hyjal
-- Eastern Kingdoms
(1519, 20, 0,  0,  15, 0,  0,  25, 0,  0,  20, 10, 0, ''),  -- Stormwind
(1,     0, 30, 0,   5, 15, 0,   0, 35, 0,   0, 55, 0, ''),  -- Dun Morogh
(38,   15, 5,  0,  10, 0,  0,  20, 5,  0,   5, 30, 0, ''),  -- Loch Modan
(40,   10, 0,  0,   5, 0,  0,  15, 0,  0,  15, 0,  0, ''),  -- Westfall
(44,   15, 0,  0,  10, 0,  0,  20, 0,  0,  15, 10, 0, ''),  -- Redridge
(10,   35, 0,  0,  30, 0,  0,  40, 0,  0,  35, 5,  0, ''),  -- Duskwood
(33,   35, 0,  0,  40, 0,  0,  35, 0,  0,  35, 0,  0, ''),  -- Northern Stranglethorn
(5287, 35, 0,  0,  40, 0,  0,  35, 0,  0,  35, 0,  0, ''),  -- The Cape of Stranglethorn
(8,    40, 0,  0,  40, 0,  0,  45, 0,  0,  40, 0,  0, ''),  -- Swamp of Sorrows
(4,     0, 0, 15,   0, 0, 20,   0, 0, 15,   0, 0, 15, ''),  -- Blasted Lands
(85,   30, 0,  0,  25, 0,  0,  35, 0,  0,  30, 10, 0, ''),  -- Tirisfal Glades
(130,  35, 0,  0,  30, 0,  0,  40, 0,  0,  35, 10, 0, ''),  -- Silverpine Forest
(267,  25, 0,  0,  20, 0,  0,  25, 0,  0,  20, 15, 0, ''),  -- Hillsbrad
(45,   20, 0,  0,  15, 0,  0,  25, 0,  0,  20, 10, 0, ''),  -- Arathi Highlands
(11,   50, 0,  0,  45, 0,  0,  50, 0,  0,  45, 5,  0, ''),  -- Wetlands
(47,   25, 0,  0,  20, 0,  0,  25, 0,  0,  20, 15, 0, ''),  -- The Hinterlands
(28,   20, 0,  0,  15, 0,  0,  25, 0,  0,  15, 15, 0, ''),  -- Western Plaguelands
(139,  20, 0,  0,  15, 0,  0,  25, 0,  0,  15, 15, 0, ''),  -- Eastern Plaguelands
(3,     0, 0, 15,   0, 0, 20,   0, 0, 15,   0, 0, 10, ''),  -- Badlands
(41,   30, 0,  0,  25, 0,  0,  35, 0,  0,  30, 5,  0, ''),  -- Deadwind Pass
(36,    5, 30, 0,   5, 15, 0,   5, 35, 0,   0, 55, 0, ''),  -- Alterac Mountains
(25,   15, 0,  0,  10, 0,  0,  15, 0,  0,  10, 0,  0, '');  -- Blackrock Mountain area
