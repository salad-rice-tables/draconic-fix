-- 86538 Second, The Fuel + 86537 Network Insecurity v1 (Wiki verbatim + retail broadcast).
-- Progress texty (TDB ''). Alleria 38434 + Lothraxion 38396: post-quest gossip stromy
-- (naaru/Salhadaar/movie, submenu pattern). Loot/GO/turn-in nativne.
-- Konzoly + Tempest Keeper + Echo-Missive says cez Eluna (temp-summony).
-- Follow-up: videa (movie buttony), meet-back says, gear-choice odmeny (len 6 slotov).
-- Undo: 20261016_abyss3837_undo.sql. Restart + .reload eluna.
UPDATE `quest_template` SET `AreaDescription`='Go. Collect the catalyst.' WHERE `ID`=86538;
UPDATE `quest_template` SET `AreaDescription`='What have you found?' WHERE `ID`=86537;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38435,1,0,0,0,0,0,0,0,912047095,0,0,0,0,0,0,0,0);
UPDATE `npc_text` SET `BroadcastTextID0`=912047098 WHERE `ID`=38436;
UPDATE `npc_text` SET `BroadcastTextID0`=912047100 WHERE `ID`=38437;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38435,38435,0),(38436,38436,0),(38437,38437,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES
 (38434,384340,1,0,'Tell me about the naaru.',0,0,0,38435,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38434,384341,2,0,'Tell me more about Nexus-King Salhadaar.',0,0,0,38436,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38434,384342,3,0,'(Play Movie) <See how Alleria absorbed the naaru L''ura.>',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0),
 (38396,383961,1,0,'Tell me about the naaru.',0,0,0,38437,0,NULL,0,0,NULL,0,NULL,NULL,0);
