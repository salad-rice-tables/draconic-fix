-- =====================================================================
-- 86516 All Become Prey + 86517 Vanished in the Void v1 - UNDO (2026-10-17)
-- Vrati world DB do stavu pred 20261017_abyss1617.sql.
-- (npc_text 238530/238531/241170 sa necha tak - existoval uz pred fixom)
-- =====================================================================

-- F) spell import undo
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell` WHERE `ID` IN (1218405,1263233);
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` IN (1218405,1263233);

-- E) Oathstone auto-kredit (SAI id100) spat
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param7`, `action_param_string`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(238530, 0, 100, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 33, 238530, 0, 0, 0, 0, 0, NULL, 0, 7, 0, 0, 0, 0, NULL, 0.0, 0.0, 0.0, 0.0, 'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
(238531, 0, 100, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 33, 238531, 0, 0, 0, 0, 0, NULL, 0, 7, 0, 0, 0, 0, NULL, 0.0, 0.0, 0.0, 0.0, 'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)'),
(241170, 0, 100, 0, '', 64, 0, 100, 0, 0, 0, 0, 0, 0, '', 33, 241170, 0, 0, 0, 0, 0, NULL, 0, 7, 0, 0, 0, 0, NULL, 0.0, 0.0, 0.0, 0.0, 'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');

-- D) SAI zaloha + gossip menu undo
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (238530,238531,241170) AND `source_type`=0 AND `id`=101;
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (38407,38408,38410);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38407,38408,38410);

-- C) loot undo
DELETE FROM `world`.`creature_loot_template` WHERE `Item`=237807 AND `Entry` IN (235639,238163,243797);
DELETE FROM `hotfixes`.`creature_loot_template` WHERE `Item`=237807 AND `Entry` IN (235639,238163,243797);

-- B) 86517 objectives undo
UPDATE `quest_objectives` SET `Order`=0, `StorageIndex`=0, `Description`='Riftblade Maella found ' WHERE `ID`=457972 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=1, `StorageIndex`=1 WHERE `ID`=457973 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=2, `StorageIndex`=2 WHERE `ID`=457974 AND `QuestID`=86517;
UPDATE `quest_objectives` SET `Order`=3, `StorageIndex`=3, `Description`=NULL WHERE `ID`=460907 AND `QuestID`=86517;
DELETE FROM `quest_objectives` WHERE `ID`=461134 AND `QuestID`=86517;

-- A) 86516 objectives undo
UPDATE `quest_objectives` SET `Order`=0, `Description`=NULL WHERE `ID`=457942 AND `QuestID`=86516;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (457942000,86516,0,0,0,0,1,0,4,0,0.0,0,1,'Gather Carrion Essence from slain creatures to weaken ultradons',0);
