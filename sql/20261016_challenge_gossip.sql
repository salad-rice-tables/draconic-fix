-- Challenge Master 9900133: DB trigger menu (Eluna hello nechodi - core short-circuit bez DB menu).
-- Po kliku core otvori toto menu; Eluna select-hook (sender=9900133, overeny select path) otvori Show().
-- Text 1 = 'Greetings, $n.' (existujuci neutral). Undo: _undo.sql. Prejav az po RESTARTe (gossip nacitanie pri boote).
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (9900133,1,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`) VALUES (9900133,9900133,0,0,'Ask about the challenges.',0,0,0,0,0,0,0,0,'');
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (9900133,9900133,0);
