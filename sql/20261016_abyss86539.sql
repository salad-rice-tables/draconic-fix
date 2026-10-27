-- 86539 A Naaru! v1 (Wiki A_Naaru! + retail broadcast).
-- Decimus 235650 unlink (ziadny dokumentovany gossip, prazdne okno prec).
-- Arator 235721 menu 38438 (telo 288352 retail). Turn-in/accept nativne.
-- Accept scena (dabing 300893/300883, speakri 45763 pri starterovi).
-- Undo: 20261016_abyss86539_undo.sql. Restart + .reload eluna.
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235650 AND `MenuID`=999999999;
INSERT INTO `npc_text` (`ID`,`Probability0`,`Probability1`,`Probability2`,`Probability3`,`Probability4`,`Probability5`,`Probability6`,`Probability7`,`BroadcastTextID0`,`BroadcastTextID1`,`BroadcastTextID2`,`BroadcastTextID3`,`BroadcastTextID4`,`BroadcastTextID5`,`BroadcastTextID6`,`BroadcastTextID7`,`VerifiedBuild`) VALUES (38438,1,0,0,0,0,0,0,0,288352,0,0,0,0,0,0,0,0);
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (38438,38438,0);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (235721,38438,0);
