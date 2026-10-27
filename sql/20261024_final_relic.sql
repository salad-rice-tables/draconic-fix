-- 86822 One Final Relic: Faol (Hammerfall) / Faol, Eitrigg, Arator, Kurdran (Burning Steppes) talk via Eluna gossip
DELETE FROM smart_scripts WHERE source_type=0 AND event_type=64 AND action_type=33 AND entryorguid IN (240747,248263,237224,237508);
UPDATE creature_template SET AIName='' WHERE entry IN (240747,248263,237224,237508);
UPDATE creature_template SET npcflag=npcflag|1 WHERE entry IN (248082);
DELETE FROM creature_template_gossip WHERE CreatureID IN (240747,248263,237224,237508,248082);
INSERT INTO creature_template_gossip (CreatureID,MenuID,VerifiedBuild) VALUES (240747,999999999,0),(248263,999999999,0),(237224,999999999,0),(237508,999999999,0),(248082,999999999,0);
