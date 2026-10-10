-- 91967: unique GossipOptionID per button (MenuID*10+OptionID) - otherwise the client only sends the first button.
-- SmartAI backups target the new IDs (param1), param2 = OptionID unchanged.
-- Do NOT apply while players are testing; deploy before restart.
UPDATE `world`.`gossip_menu_option` SET `GossipOptionID` = `MenuID`*10+`OptionID` WHERE `MenuID` IN (40158, 40154, 40147, 40163);
UPDATE `world`.`smart_scripts` SET `event_param1` = 401581 WHERE `entryorguid` = 249268 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 401541 WHERE `entryorguid` = 248628 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 401471 WHERE `entryorguid` = 249270 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
UPDATE `world`.`smart_scripts` SET `event_param1` = 401631 WHERE `entryorguid` = 249289 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 62;
