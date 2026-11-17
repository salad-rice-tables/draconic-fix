UPDATE creature_template SET name="Zal'thira", subname='Necromancer Trainer', npcflag=3 WHERE entry=139829;
UPDATE creature_template SET name="Vex'thal", subname='Fallen Necromancer', npcflag=0 WHERE entry=161180;
UPDATE creature_template SET name='Korthaz', subname='Maldraxxian Necromancer', npcflag=3 WHERE entry=163243;
DELETE FROM quest_template WHERE ID BETWEEN 9330001 AND 9330099;
