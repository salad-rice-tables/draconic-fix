-- 86559 The Far, Far Frontier v1 (Wiki The_Far,_Far_Frontier + retail broadcast 91204706x).
-- Lothraxion 235522 menu 38425 (body 912047066 + Play-Movie button 912047069);
-- Alleria 235521 menu 38431 (body 912047073 + 2 quest buttony + submenu 38432 s movie
-- buttonom 912046903 = existujuci SAI PlayMovie riadok!). Customs 9900151/52 nahradene
-- retail riadkami (duplikaty). 235530 unlink (ender, default quest UI).
-- Cutscene "Reunion" + Antius stretnutie = follow-up (ziadne videa lokalne; 45757 je
-- mimo 86559: Arator post-movie chain + Antius says az s C++ autoplay).
-- Undo: 20261016_abyss86559_undo.sql. Aktivacia: restart + .reload eluna.
UPDATE `npc_text` SET `BroadcastTextID0`=912047066 WHERE `ID`=40203;
UPDATE `npc_text` SET `BroadcastTextID0`=912047067 WHERE `ID`=40204;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` IN (9900151,9900152);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235530 AND `MenuID`=999999999;
-- (npc_text 38425/38431 existuju ako siroty s cudzim obsahom (177707/178163) - prepiseme)
UPDATE `npc_text` SET `BroadcastTextID0`=912047066 WHERE `ID`=38425;
UPDATE `npc_text` SET `BroadcastTextID0`=912047073 WHERE `ID`=38431;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (38432,1,0,0,0,0,0,0,0,912047076,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38425,38425,0),(38431,38431,0),(38432,38432,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38425,384250,0,0,'(Quest) (Play Movie) <Tell Lothraxion you are ready to survey Voidstorm.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38431,384310,0,0,'(Quest) <Ask Alleria how you can help.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38431,384311,1,0,'<Ask Alleria how she got here.>',0,0,0,38432,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38432,912046903,0,0,'(Play Movie) <Ask to hear more.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235522,0,101,0,62,100,384250,0,33,235522,7,'86559 Lothraxion 235522 - survey btn (wiki)'),
 (235521,0,102,0,62,100,384310,0,33,235521,7,'86559 Alleria 235521 - help btn (wiki)'),
 (235521,0,103,0,62,100,384311,1,33,235521,7,'86559 Alleria 235521 - got-here btn (wiki)');
