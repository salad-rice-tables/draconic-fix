-- 86545 The Light's Brand Eluna v1 (DB v 20261016_abyss4455.sql).
-- Alleria outskirts gossip (menu 38439, custom broadcast 9900153 Wiki verbatim).
-- Accept scena (Wiki, Locus speakri). Gather: proximity 9100610 -> AddItem (cap 15).
-- Deliver: Arator hello s 15+ -> -15 + 15x kredit + post-deliver says.
-- Healing button 390770: kredit 250369 + heal. Reveal: open-kredit SAI + says.
-- Find 239571: proximity outskirts. Turn-in nativny.
-- Follow-up: post-gossip okna, paladin dialog, staff/ring vizualy, presun pohyby.
-- Undo: v 20261016_abyss6545_undo.sql. Restart + .reload eluna.
INSERT INTO `hotfixes`.`broadcast_text` (`Text`,`Text1`,`ID`,`LanguageID`,`ConditionID`,`EmotesID`,`Flags`,`ChatBubbleDurationMs`,`VoiceOverPriorityID`,`SoundKitID1`,`SoundKitID2`,`EmoteID1`,`EmoteID2`,`EmoteID3`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`VerifiedBuild`) VALUES ('Go, $n! There''s no time! I''ll be...\n\nRight behind... Nghh...!\n\n<Alleria tries to rise but then falls, too exhausted.>', '', 9900153, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38439,1,0,0,0,0,0,0,0,9900153,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38439,38439,0);
UPDATE `creature_template_gossip` SET `MenuID`=38439 WHERE `CreatureID`=235726 AND `MenuID`=999999999;
