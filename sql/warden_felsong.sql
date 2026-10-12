-- =====================================================================
-- Felsong rework: Duskwatch Renegades (95114) look like Cordana Felsong
-- (display 66480, fel-corrupted warden) and Quest 1 is rewritten around
-- destroying the fel-infected. Idempotent. Needs restart (models).
-- =====================================================================

UPDATE `world`.`creature_template` SET `name` = 'Felsong Renegade', `subname` = 'Fel-corrupted Warden' WHERE `entry` = 95114;
UPDATE `world`.`creature_template_model` SET `CreatureDisplayID` = 66480 WHERE `CreatureID` = 95114 AND `Idx` = 0;

UPDATE `world`.`quest_template` SET
`LogTitle` = 'The Fel Within',
`LogDescription` = 'Destroy 6 Felsong Renegades in the woods around Dolanaar for Warden Velarys.',
`QuestDescription` = '$C! Another hunter of demons beneath the boughs of Teldrassil. Good. You know the tale of Cordana Felsong, aye? A warden, one of ours - until fel magic hollowed her out and wore her like a cloak.$b$bIt has happened again. Wardens of my own watch drank fel from a cracked shard and now stalk these woods, their glaives turned on the night they swore to keep. They cannot be saved, hunter. Only destroyed. Put six of them down and return.',
`QuestCompletionLog` = 'The fel cannot hold them anymore. Return to Velarys in Dolanaar.'
WHERE `ID` = 95000;
