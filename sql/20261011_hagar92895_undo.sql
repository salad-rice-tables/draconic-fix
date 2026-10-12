-- UNDO: Quest 92895 Hagar's Invitation (20261011_hagar92895.sql).
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 0, `QuestCompletionLog` = 'Speak to Orweyna at the Den in Harandar.' WHERE `ID` = 92895;
UPDATE `world`.`creature_template` SET `npcflag` = 0 WHERE `entry` IN (253640, 257917, 241792);
DELETE FROM `world`.`creature_questender` WHERE `quest` = 92895;
DELETE FROM `world`.`creature_template_gossip` WHERE `CreatureID` = 257917 AND `MenuID` = 40431;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` = 40431;
DELETE FROM `world`.`npc_text` WHERE `ID` = 9500148;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900150;
DELETE FROM `world`.`creature` WHERE `guid` IN (3001001204);
