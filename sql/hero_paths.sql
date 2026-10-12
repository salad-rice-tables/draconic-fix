-- =====================================================================
-- Classless + Wildcard (Descend Hero): cesta postavy a Classless nakupy.
-- Logika: Custom/lua/wildcard.lua. Undo: hero_paths_undo.sql
-- path: 0 = este nevybrata, 1 = Classless (kupuje za Ability Essence),
--       2 = Wildcard (nahodne rolly). Vyber je natrvalo.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `characters`.`wildcard_path` (
  `name` varchar(24) NOT NULL,
  `path` tinyint unsigned NOT NULL DEFAULT '0',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `characters`.`wildcard_classless` (
  `name` varchar(24) NOT NULL,
  `spell` int unsigned NOT NULL,
  `cost` tinyint unsigned NOT NULL,
  PRIMARY KEY (`name`, `spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
