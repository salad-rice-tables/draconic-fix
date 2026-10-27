-- 86839 Relics of Light's Hope: Lua drives Faol gossip (relics_lights_hope.lua); no auto-credit on hello
DELETE FROM smart_scripts WHERE entryorguid=240240 AND source_type=0 AND id=100;
UPDATE creature_template SET AIName='' WHERE entry=240240;
-- gossip menus that did not exist (client then refuses interaction)
UPDATE creature_template_gossip SET MenuID=999999999 WHERE CreatureID IN (237594,241255) AND MenuID IN (39376,41060);
