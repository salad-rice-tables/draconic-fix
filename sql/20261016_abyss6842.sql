-- 88768 Agents of Darkness + 86542 Flicker in the Dark v1 (Wiki verbatim).
-- 86542 OBJECTIVE RESTORE: live riadky boli preskladane ( rovnake ID, zle Type/
-- StorageIndex/ObjectID; Type-19 meet riadok zniceny, prazdny ObjectID riadok) ->
-- navrat k TDB hodnotam (retail). 88768: starter unlink (Alleria), elite says
-- (Watcher/Unbound priblizenie+zabitie, Inventor), meet-up says, accept scena.
-- Undo: 20261016_abyss6842_undo.sql. Restart + .reload eluna.
UPDATE `quest_objectives` SET `Type`=0, `StorageIndex`=0 WHERE `ID`=459120;
UPDATE `quest_objectives` SET `StorageIndex`=1, `ObjectID`=240524, `Description`="T'era subdued" WHERE `ID`=459121;
UPDATE `quest_objectives` SET `StorageIndex`=2 WHERE `ID`=459161;
UPDATE `quest_objectives` SET `Type`=19, `StorageIndex`=3, `ObjectID`=36806, `Description`="Return to T'era" WHERE `ID`=459305;
UPDATE `quest_objectives` SET `ObjectID`=240354 WHERE `ID`=459477;
DELETE FROM `creature_template_gossip` WHERE `CreatureID`=235662 AND `MenuID`=999999999;
