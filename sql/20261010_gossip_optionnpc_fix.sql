-- Gossip buttony 40410/40411 boli neklikatne: OptionNpc=3 je Trainer (brown book) podla
-- Source/Draconic-RoleplayCore GossipDef.h (enum GossipOptionNpc). Klik posielal trainer request miesto selectu.
-- Retail report-buttony maju OptionNpc=0 (None, white bubble). Oprava na 0; smart 62 flow ostava.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `world`.`gossip_menu_option` SET `OptionNpc` = 0 WHERE `MenuID` IN (40410, 40411) AND `OptionID` = 0;
