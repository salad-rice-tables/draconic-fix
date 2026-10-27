-- Zuljarra buried (GetHeight glitch 121.2 vs user ground 149.9, 2026-10-14).
-- Undo: 20261014_zuljarra_zfix_undo.sql -- NEEDS restart
UPDATE `world`.`creature` SET `position_z`=149.5 WHERE `guid`=3510000010;
