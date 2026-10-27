-- Harandar 90958: retail gear objects (Shield 553793 / Axe 553844, chests with lock 93) get their loot.
-- Replaces the placeholder templates 9100701/9100702 from 20261019_harandar_intro.sql.
DELETE FROM gameobject_template WHERE entry IN (9100701, 9100702);
UPDATE gameobject_template SET Data1 = entry WHERE entry IN (553793, 553844);
DELETE FROM gameobject_loot_template WHERE Entry IN (553793, 553844);
INSERT INTO gameobject_loot_template (Entry, ItemType, Item, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(553793, 0, 246112, 100, 0, 1, 0, 1, 1, 'Alliance Shield (Roots Above All)'),
(553844, 0, 246126, 100, 0, 1, 0, 1, 1, 'Horde Axe (Roots Above All)');
