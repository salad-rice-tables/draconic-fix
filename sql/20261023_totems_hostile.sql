-- 86643: Grimfire/Stranglemist Totem are hostile mobs killed for 'Warding totems destroyed' (retail video DGoB3uGnnR0), not gossip NPCs
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid IN (251863,251866);
UPDATE creature_template SET faction=14,npcflag=0,AIName='',KillCredit1=251873 WHERE entry IN (251863,251866);
