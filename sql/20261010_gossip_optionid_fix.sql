-- Gossip buttony 40410/40411 konecne funkcne: jadro pri GossipOptionID=0 autogeneruje zaporne ID
-- (-(MenuID*100+OrderIndex), GossipDef.cpp), klient ho vrati a SmartAI (sender,action) sa nikdy nezhoduje
-- s (40410,0). Explicitne GossipOptionID=MenuID => klient vrati 40410/40411 a smart event 62 (menu,0) zapaľuje.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `world`.`gossip_menu_option` SET `GossipOptionID` = `MenuID` WHERE `MenuID` IN (40410, 40411) AND `GossipOptionID` = 0;
