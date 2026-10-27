-- Blackjack 16114 -> Awaken Peon 19938 (item_effect 2400 existuje, ale ziadny item ho nepouziva).
-- Bez toho use-item nic nerobi a peons.lua kredit nikdy nepride. UNDO: _undo.sql. Prejav po RESTARTE.
INSERT INTO `item_x_item_effect` (`ID`,`ItemEffectID`,`ItemID`,`VerifiedBuild`) VALUES (9750011,2400,16114,69933);
