-- Undo for 20261014_pen_extras.sql.
DELETE FROM `world`.`creature` WHERE `guid`=3510000169;
DELETE FROM `world`.`creature` WHERE `guid`=3510000170;
DELETE FROM `world`.`creature_text` WHERE `CreatureID`=259692 AND `GroupID`=0;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid`=259692 AND `source_type`=0 AND `id`=90;
DELETE FROM `world`.`creature_text` WHERE `CreatureID`=259412 AND `GroupID`=0;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid`=259412 AND `source_type`=0 AND `id`=90;
DELETE FROM `world`.`creature_text` WHERE `CreatureID`=253829 AND `GroupID`=0;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid`=253829 AND `source_type`=0 AND `id`=90;
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid`=259164 AND `source_type`=0 AND `id`=80;
