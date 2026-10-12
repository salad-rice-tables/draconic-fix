-- UNDO: 20261011_eversong_86733.sql.
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 31900, `RewardNextQuest` = 0, `QuestCompletionLog` = 'Meet Lor''themar in the Sanctum of Light in Silvermoon City.' WHERE `ID` = 86733;
UPDATE `world`.`creature_template_gossip` SET `MenuID` = 912046808 WHERE `CreatureID` = 241068 AND `MenuID` = 40416;
DELETE FROM `world`.`gossip_menu` WHERE `MenuID` = 40416;
DELETE FROM `world`.`npc_text` WHERE `ID` = 9500134;
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID` = 9900134;
