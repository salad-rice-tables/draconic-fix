-- Mystic Altar 9900130: DB trigger menu (rovnaky problem ako Challenge Master - Eluna hello nefireuje).
-- UNDO: _undo.sql. Prejav po RESTARTE.
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (9900130,1,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`) VALUES (9900130,9900130,0,0,'Use the Mystic Altar.',0,0,0,0,0,0,0,0,'');
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (9900130,9900130,0);
