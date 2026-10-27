-- Undo 20261016_abyss86559.sql.
DELETE FROM `smart_scripts` WHERE `comment` LIKE '86559%';
DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (38425,38431,38432);
DELETE FROM `gossip_menu` WHERE `MenuID` IN (38425,38431,38432);
DELETE FROM `npc_text` WHERE `ID`=38432;
UPDATE `npc_text` SET `BroadcastTextID0`=177707 WHERE `ID`=38425;
UPDATE `npc_text` SET `BroadcastTextID0`=178163 WHERE `ID`=38431;
UPDATE `npc_text` SET `BroadcastTextID0`=9900151 WHERE `ID`=40203;
UPDATE `npc_text` SET `BroadcastTextID0`=9900152 WHERE `ID`=40204;
INSERT INTO `hotfixes`.`broadcast_text` (`Text`,`Text1`,`ID`,`LanguageID`,`ConditionID`,`EmotesID`,`Flags`,`ChatBubbleDurationMs`,`VoiceOverPriorityID`,`SoundKitID1`,`SoundKitID2`,`EmoteID1`,`EmoteID2`,`EmoteID3`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`VerifiedBuild`) VALUES ('I have seen hundreds, no, thousands, of worlds across the Great Dark Beyond.\n\nWe fought the Legion. These were worlds plunged into war and darkness.\n\nAnd yet, still, none were like this. This foul taste in the mouth, this chill.\n\nThere is something ever darker here. Xal''atath.', '', 9900151, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),('<Arator winces.>\n\nThere is a pressure on my mind, a fear in my heart like I''ve never known...', '', 9900152, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235530,999999999,47936);
