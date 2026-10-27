-- =====================================================================
-- 86518 The Mantle of Predation v1 (2026-10-17)
-- A) quest_objectives parita vs tdb1210_world (kolizia SI: 457977 SI2 vs 459168 SI2):
--    459621 -> Order 1, SI 4     457976 -> Order 2, SI 0, Flags 258     457977 -> Order 7, SI 1
-- B) Gossip buttony (kredit + scenu riesi Eluna mantle_of_predation.lua):
--    Alleria 235502 (menu 38582, faza 45783) "Tell Alleria you're ready to claim the Mantle."
--    (telo okna = bts 285505 "Are you ready? We're close, yet I feel more unease than ever.")
--    Lothraxion 235504 (menu 912046940) "Stay awhile and Listen."
-- C) Alleria 235502: zmazany Oathstone auto-kredit (SAI id100 na otvorenie gossipu) -
--    kredit objetivu 459621 "Speak to Alleria when you're ready" ma prist az po kliknuti
--    na button (rovnaka bug class ako pri predoslych objektivovych NPC).
-- D) Vault Seal GO 504645: IconName questinteract + size 0.6 (parita s TDB; Type2 objektiv
--    kredituje nativne GameObject::Use -> KillCreditGO, Eluna handler vracia false).
-- Undo: 20261017_abyss18_undo.sql
-- =====================================================================

UPDATE `quest_objectives` SET `Order`=1, `StorageIndex`=4 WHERE `ID`=459621 AND `QuestID`=86518;
UPDATE `quest_objectives` SET `Order`=2, `StorageIndex`=0, `Flags`=258 WHERE `ID`=457976 AND `QuestID`=86518;
UPDATE `quest_objectives` SET `Order`=7, `StorageIndex`=1 WHERE `ID`=457977 AND `QuestID`=86518;

INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (38582, 38582, 0);
INSERT INTO `npc_text` (`ID`, `Probability0`, `BroadcastTextID0`, `VerifiedBuild`) VALUES (38582, 1.0, 285505, 0);
INSERT INTO `gossip_menu_option` (`MenuID`, `GossipOptionID`, `OptionID`, `OptionNpc`, `OptionText`)
VALUES
  (38582, 38582, 0, 0, 'Tell Alleria you\'re ready to claim the Mantle.'),
  (912046940, 912046940, 0, 0, 'Stay awhile and Listen.');

DELETE FROM `smart_scripts` WHERE `entryorguid`=235502 AND `source_type`=0 AND `id`=100;

UPDATE `gameobject_template` SET `IconName`='questinteract', `size`=0.6 WHERE `entry`=504645;
