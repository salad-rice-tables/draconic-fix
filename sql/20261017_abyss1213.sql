-- 86512 The Harvest + 86513 Face the Tide v1 (Wiki Notes + hotovy custom set 91204693x).
-- 86512: bar = 5 % za kill (20 killov = 100 %) na 8 trench moboch (wiki zoznam:
--        Voidwraith/Voidwalker/Shredclaw/Scrabbling Voidspawn/Marrowmouth + spawn varianty).
--        Dvojity bar (456995 + 86512000) PONECHANY - rovnaky pattern ako 86531/86685/86641/86840.
-- 86513: Arator 236944 prepnuty z mrtveho retail menu 39123 na hotove custom menu 912046936
--        (npc_text 236944 -> 912047128, option 912047129, sub 912046937 -> 912047130).
-- Eluna: the_harvest.lua (accept scena + Torentia yell), face_the_tide.lua (captives + meet-up).
-- Undo: 20261017_abyss1213_undo.sql. Restart + .reload eluna.
UPDATE `quest_objectives` SET `Amount`=20, `ProgressBarWeight`=5.0 WHERE `ID` IN (86512001,86512002,86512003,86512004,86512005);
DELETE FROM `quest_objectives` WHERE `ID` IN (86512006,86512007,86512008);
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
 (86512006,86512,0,6,6,235639,20,0,92,0,5.0,0,1,'Attract Torentia''s attention',0),
 (86512007,86512,0,7,7,235640,20,0,92,0,5.0,0,1,'Attract Torentia''s attention',0),
 (86512008,86512,0,8,8,242750,20,0,92,0,5.0,0,1,'Attract Torentia''s attention',0);
INSERT INTO `creature_template_gossip` (`CreatureID`,`MenuID`,`VerifiedBuild`) VALUES (236944,912046936,0);
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=236944 AND `MenuID`=39123;
