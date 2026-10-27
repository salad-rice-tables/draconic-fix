-- UNDO valley miniboss (Yarrog only; Sarkoth riadok bol zruseny pred nasadenim)
DELETE FROM `smart_scripts` WHERE `entryorguid`=3183 AND `source_type`=0 AND `id` IN (0,1,2,3);
