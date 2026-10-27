-- 86549 No Fear of the Dark v1 (Wiki No_Fear_of_the_Dark verbatim).
-- Foci-linking cez Eluna proximity (3x Shadow Focus 243071 -> kredity 243066/67/68 + 239477),
-- portal GO 504395 (Eluna use -> kredity 239600/239643 + Ingress says),
-- Lor'themar 235481 Listen button (-> kredit 260106 + Rommath scena),
-- Lothraxion 235477 Ingress gossip (custom broadcast Wiki verbatim),
-- Umbric 235405 unlink (default quest UI) + Foci Oathstone auto-kredit prec (obchadzal linking).
-- Follow-up (treba sniff/spell ID): beam vizualy, Overcome ability, dungeon queue 238157/1116,
-- Tehd walk-off ekvivalent (Rommath prichod - Rommath 240532 uz na mieste, len says).
-- Undo: 20261016_abyss86549_undo.sql. Aktivacia: restart + .reload eluna.

-- 1. unlinky + Oathstone prec
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235405 AND `MenuID`=999999999;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=243071 AND `MenuID`=999999999;
DELETE FROM `smart_scripts` WHERE `entryorguid`=243071 AND `id`=101 AND `event_type`=64 AND `action_type`=33;

-- 2. Lothraxion Ingress gossip (Wiki verbatim, custom broadcast 91967-vzor)
INSERT INTO `hotfixes`.`broadcast_text` (`Text`,`Text1`,`ID`,`LanguageID`,`ConditionID`,`EmotesID`,`Flags`,`ChatBubbleDurationMs`,`VoiceOverPriorityID`,`SoundKitID1`,`SoundKitID2`,`EmoteID1`,`EmoteID2`,`EmoteID3`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`VerifiedBuild`) VALUES ('I have seen hundreds, no, thousands, of worlds across the Great Dark Beyond.\n\nWe fought the Legion. These were worlds plunged into war and darkness.\n\nAnd yet, still, none were like this. This foul taste in the mouth, this chill.\n\nThere is something ever darker here. Xal''atath.', '', 9900151, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES
 (40202,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
 (40203,1,0,0,0,0,0,0,0,9900151,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40202,40202,0),(40203,40203,0);
UPDATE `creature_template_gossip` SET `MenuID`=40202 WHERE `CreatureID`=235481 AND `MenuID`=912046886;
UPDATE `creature_template_gossip` SET `MenuID`=40203 WHERE `CreatureID`=235477 AND `MenuID`=912046888;

-- 3. Listen button (Wiki presny text) + SAI zaloha
INSERT INTO `gossip_menu_option` (`MenuID`,`GossipOptionID`,`OptionID`,`OptionNpc`,`OptionText`,`OptionBroadcastTextID`,`Language`,`Flags`,`ActionMenuID`,`ActionPoiID`,`GossipNpcOptionID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`SpellID`,`OverrideIconID`,`VerifiedBuild`) VALUES (40202,402020,0,0,'Stay awhile and Listen.',0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_chance`,`event_param1`,`event_param2`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
 (235481,0,101,0,62,100,402020,0,33,260106,7,'86549 Lor-th 235481 - listen credit (wiki)');
