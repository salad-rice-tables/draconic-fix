-- 86530 First, The Shells + 86528 A Cracked Holokey v1 (Wiki verbatim).
-- 86530: menu 38396 (prazdne) + Listen button (kredit 235713 + SAI zaloha) + scena (13 says).
-- Progress text (TDB ''). Loot nativny. Odmeny: gear-choice 9 ID z ItemSparse
-- (260848/262375/76/262672/74/75/78/262733/37) NENASAZENE - len 6 slotov, treba dizajn.
-- 86528: retail = ITEM-START (ItemSparse StartQuestID=86528, TDB bez startera/objektivov):
-- zmazany custom creature-starter + collect-objektiv (navrat k retail stavu).
-- Loot holokey 100% ponechany (= starter mechanika). Turn-in 235717 funguje.
-- Undo: 20261016_abyss3038_undo.sql. Restart + .reload eluna.
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38396,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38396,38396,0);
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (38396,383960,0,0,'Stay awhile and Listen.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235713,0,101,0,62,100,383960,0,33,235713,7,'86530 Lothraxion 235713 - listen credit (wiki)');
UPDATE `quest_template` SET `AreaDescription`='Just as before.' WHERE `ID`=86530;
DELETE FROM `creature_queststarter` WHERE `quest`=86528 AND `id`=235717;
DELETE FROM `quest_objectives` WHERE `QuestID`=86528;
