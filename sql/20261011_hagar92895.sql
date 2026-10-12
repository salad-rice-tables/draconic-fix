-- Quest 92895 Hagar's Invitation (Wiki: Warcraft Wiki Hagar's_Invitation, Wowhead quest=92895).
-- Stav: starter Orweyna-253640 OK, ender CHYBAL, RewardBonusMoney 0 (ma byt 23400 = 2g34s), CompletionLog iny text.
-- Ender: Orweyna-253654 (Den). Accept scena (Orweyna + Lor'themar) cez Eluna CREATURE_EVENT_ON_QUEST_ACCEPT (31).
-- Den Welcomer 257917: novy spawn 46727 (pozicia APPROX pri vchode), menu 40431 (text only).
-- Rootway 241792: flag 1, hello-kredit 256649 (optional).
-- Arrival kredit 254857 + says: Eluna hello-hook Orweyna-253654 (len pri aktivnom 92895).
-- MEDZERY: Orweyna "runs off" bez pohybu; Welcomer pozicia APPROX; Lor'themar linka len cez Eluna.
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
UPDATE `world`.`quest_template` SET `RewardBonusMoney` = 23400, `QuestCompletionLog` = 'It should not be long now.' WHERE `ID` = 92895;
UPDATE `world`.`creature_template` SET `npcflag` = 3 WHERE `entry` = 253640;
UPDATE `world`.`creature_template` SET `npcflag` = 1 WHERE `entry` IN (257917, 241792);
DELETE FROM `world`.`creature_questender` WHERE `quest` = 92895;
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES (253654, 92895, 0);
INSERT IGNORE INTO `hotfixes`.`broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`, `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`, `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`) VALUES ('I''m sure you have many questions. Hagar will address them once all of the delegates arrive.', '', 9900150, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`npc_text` (`ID`, `Probability0`, `Probability1`, `Probability2`, `Probability3`, `Probability4`, `Probability5`, `Probability6`, `Probability7`, `BroadcastTextID0`, `BroadcastTextID1`, `BroadcastTextID2`, `BroadcastTextID3`, `BroadcastTextID4`, `BroadcastTextID5`, `BroadcastTextID6`, `BroadcastTextID7`, `VerifiedBuild`) VALUES (9500148, 1, 0, 0, 0, 0, 0, 0, 0, 9900150, 0, 0, 0, 0, 0, 0, 0, 0);
INSERT IGNORE INTO `world`.`gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (40431, 9500148, 0);
INSERT IGNORE INTO `world`.`creature_template_gossip` (`CreatureID`, `MenuID`, `VerifiedBuild`) VALUES (257917, 40431, 0);
DELETE FROM `world`.`creature` WHERE `guid` IN (3001001204);
INSERT INTO `world`.`creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`, `size`) VALUES (3001001204, 257917, 2694, 0, 0, '0', 0, 46727, 0, -1, 0, 0, -166.0, -276.0, 903.5, 1.0, 300, 0.0, 0, NULL, 0, NULL, 32768, NULL, NULL, '', NULL, 0, -1.0);
