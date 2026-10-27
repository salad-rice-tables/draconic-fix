-- Harandar intro (90957-90959): mechanics per spec (Obsidian vault "Harandar moje info/Initiation Day.md").
-- Undo: 20261019_harandar_intro_undo.sql  (SAI rows are backed up into bak_20261019_harandar_sai)

-- 1) Pesky Sludger must be clickable (Kick); Eluna harandar_intro.lua handles the click
UPDATE creature_template SET npcflag = npcflag | 1 WHERE entry = 245117;

-- 2) Withered Plant: opening gossip must not credit/despawn it (Eluna: vine pulling cast -> Withered Lasher)
CREATE TABLE IF NOT EXISTS bak_20261019_harandar_sai LIKE smart_scripts;
INSERT INTO bak_20261019_harandar_sai
  SELECT * FROM smart_scripts WHERE source_type = 0 AND ((entryorguid = 246277 AND id IN (100,101)) OR (entryorguid = 255723 AND id IN (101,102)));
DELETE FROM smart_scripts WHERE source_type = 0 AND ((entryorguid = 246277 AND id IN (100,101)) OR (entryorguid = 255723 AND id IN (101,102)));

-- 3) Outsider's gear pickups (Eluna gives quest item 246129 on use): Alliance Shield / Horde Axe
DELETE FROM gameobject_template WHERE entry IN (9100701, 9100702);
INSERT INTO gameobject_template (entry, type, displayId, name, IconName, castBarCaption, unk1, size, Data0, Data1, Data2, Data3, Data4, Data5, Data6, AIName, ScriptName, StringId, VerifiedBuild)
VALUES (9100701, 10, 16251, 'Shield', 'Interact', 'Pick Up', '', 1, 0, 0, 0, 3000, 0, 0, 0, '', '', '', 0),
       (9100702, 10, 18305, 'Axe',    'Interact', 'Pick Up', '', 1, 0, 0, 0, 3000, 0, 0, 0, '', '', '', 0);

-- 4) Pesky Sludger uses the same (empty) dummy gossip menu as Withered Plant so the gossip cursor shows
DELETE FROM creature_template_gossip WHERE CreatureID = 245117;
INSERT INTO creature_template_gossip (CreatureID, MenuID, VerifiedBuild) VALUES (245117, 999999999, 0);
