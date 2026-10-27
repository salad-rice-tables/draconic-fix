-- 90571 The Lay of the Beast v1 (Wiki + TDB restore).
-- Objektivy: navrat k TDB (zruseny prazdny riadok, posunute indexy, duplicitny Listen).
-- Arator 235469 menu 912046930 (Listen button + SAI zaloha -> 240725).
-- Progress text (TDB ''). Odmeny: choice 260858/260859 (ItemSparse, live daval len prvy).
-- Eluna: scry proximity kredity + area says + accept/completion says (speakri overeni).
-- Vehicle Ciphus + Terminas-catch = follow-up (treba spelly).
-- Undo: 20261016_abyss0571_undo.sql. Restart + .reload eluna.
UPDATE `quest_objectives` SET `Type`=0, `StorageIndex`=2, `ObjectID`=239740, `Amount`=3, `Description`='Scout the Devouring Citadel' WHERE `ID`=461130;
UPDATE `quest_objectives` SET `StorageIndex`=3 WHERE `ID`=461131;
UPDATE `quest_objectives` SET `StorageIndex`=4 WHERE `ID`=461132;
UPDATE `quest_objectives` SET `StorageIndex`=5 WHERE `ID`=461133;
DELETE FROM `quest_objectives` WHERE `ID`=461134;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (912046930,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
UPDATE `gossip_menu` SET `TextID`=912046930 WHERE `MenuID`=912046930;
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (912046930,905711,0,0,'Stay Awhile and Listen.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235469,0,101,0,62,100,905711,0,33,240725,7,'90571 Arator 235469 - listen credit (wiki)');
UPDATE `quest_template` SET `AreaDescription`='Go on. Ciphus won''t mind.' WHERE `ID`=90571;
UPDATE `quest_template` SET `RewardItem1`=0, `RewardChoiceItemID1`=260858, `RewardChoiceItemID2`=260859 WHERE `ID`=90571;
