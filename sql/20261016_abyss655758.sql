-- 86557 A Matter of Strife and Death + 86558 Save a Piece of Mind v1 (Wiki verbatim).
-- 86557: Progress text (TDB ''), kill-hook kredity 239684 cez Eluna (objekt dava marker,
--   nie mob-entry ako fungujuce kill questy) + accept scena (Lothraxion, Everdawn).
-- 86558: Arator gossip (custom broadcast 9900152, menu 40204 pre 235523+235608),
--   loci GO-use kredity 240244/49/52 (guid->marker) + Darkglen say, accept scena (Everdawn).
-- Oathstone riadky 235411/235486/235522 SAHANE (86559 obj0 = 235522, mechanika!).
-- Follow-up: Maella/Astre says (chybaju speakri - treba sniff), scout split-up pohyb.
-- Undo: 20261016_abyss655758_undo.sql. Aktivacia: restart + .reload eluna.
UPDATE `quest_template` SET `AreaDescription`='I will not deny, I still thrive in the rush of battle. So long as it is of righteous cause.' WHERE `ID`=86557;
INSERT INTO `hotfixes`.`broadcast_text` (`Text`,`Text1`,`ID`,`LanguageID`,`ConditionID`,`EmotesID`,`Flags`,`ChatBubbleDurationMs`,`VoiceOverPriorityID`,`SoundKitID1`,`SoundKitID2`,`EmoteID1`,`EmoteID2`,`EmoteID3`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`VerifiedBuild`) VALUES ('<Arator winces.>\n\nThere is a pressure on my mind, a fear in my heart like I''ve never known...', '', 9900152, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (40204,1,0,0,0,0,0,0,0,9900152,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (40204,40204,0);
UPDATE `creature_template_gossip` SET `MenuID`=40204 WHERE `CreatureID`=235523 AND `MenuID`=912046900;
UPDATE `creature_template_gossip` SET `MenuID`=40204 WHERE `CreatureID`=235608 AND `MenuID`=912046898;
