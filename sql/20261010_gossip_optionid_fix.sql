-- Gossip buttons 40410/40411 finally working: with GossipOptionID=0 the core auto-generates negative IDs
-- (-(MenuID*100+OrderIndex), GossipDef.cpp), the client echoes them back and SmartAI (sender,action) never matches
-- (40410,0). Explicit GossipOptionID=MenuID => client returns 40410/40411 and smart event 62 (menu,0) fires.
-- Do NOT apply while players are testing; deploy before restart.
UPDATE `world`.`gossip_menu_option` SET `GossipOptionID` = `MenuID` WHERE `MenuID` IN (40410, 40411) AND `GossipOptionID` = 0;
