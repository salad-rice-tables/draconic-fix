-- Multistate helpers (lua/aaa_perf.lua): work queue from world state to map states, shared state values
CREATE TABLE IF NOT EXISTS `world`.`lw_queue` (`id` int unsigned NOT NULL AUTO_INCREMENT, `kind` varchar(16) NOT NULL, `name` varchar(12) NOT NULL DEFAULT '', `arg` varchar(255) NOT NULL DEFAULT '', `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`), KEY (`name`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `world`.`lw_state` (`k` varchar(32) NOT NULL, `v` varchar(255) NOT NULL, PRIMARY KEY (`k`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
