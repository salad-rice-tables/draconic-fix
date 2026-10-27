-- 86842 Scarlet Power (retail flow per Warcraft Wiki): starts at Alonsus Faol (Light's Hope), Lua drives talk/teleport/credits
DELETE FROM creature_queststarter WHERE quest=86842;
INSERT INTO creature_queststarter (id,quest,VerifiedBuild) VALUES (237601,86842,0);
-- Arator at Light's Hope: no auto-credit on hello (Lua gossip "Stay awhile and listen")
DELETE FROM smart_scripts WHERE entryorguid=241255 AND source_type=0 AND id=101;
UPDATE creature_template SET AIName='' WHERE entry=241255;
-- gossip menus that do not exist -> client refuses interaction
UPDATE creature_template_gossip SET MenuID=999999999 WHERE (CreatureID=240714 AND MenuID=38571) OR (CreatureID=237602 AND MenuID=37900);
