-- UNDO: 20261011_evil_optionid.sql.
UPDATE `world`.`gossip_menu_option` SET `GossipOptionID` = `MenuID` WHERE `MenuID` IN (40158, 40154, 40147, 40163);
UPDATE `world`.`smart_scripts` SET `event_param1` = 40158 WHERE `entryorguid` = 249268 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 40154 WHERE `entryorguid` = 248628 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 40147 WHERE `entryorguid` = 249270 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 40163 WHERE `entryorguid` = 249289 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
