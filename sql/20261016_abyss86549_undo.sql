-- Undo 20261016_abyss86549.sql (86549 No Fear of the Dark v1).
DELETE FROM `gossip_menu_option` WHERE `MenuID`=40202 AND `GossipOptionID`=402020;
DELETE FROM `smart_scripts` WHERE `entryorguid`=235481 AND `id`=101 AND `comment` LIKE '86549%';
UPDATE `creature_template_gossip` SET `MenuID`=912046886 WHERE `CreatureID`=235481 AND `MenuID`=40202;
UPDATE `creature_template_gossip` SET `MenuID`=912046888 WHERE `CreatureID`=235477 AND `MenuID`=40203;
DELETE FROM `gossip_menu` WHERE `MenuID` IN (40202,40203);
DELETE FROM `npc_text` WHERE `ID` IN (40202,40203);
DELETE FROM `hotfixes`.`broadcast_text` WHERE `ID`=9900151;
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235405,999999999,47936),(243071,999999999,47936);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES (243071,0,101,0,64,0,100,0,0,0,0,0,0,'',33,239477,0,0,0,0,'',7,0,0,0,0,0,0,0,'On player opened gossip - Gossip player: Give kill credit Kill Credit - Oathstone Chat (190899)');
