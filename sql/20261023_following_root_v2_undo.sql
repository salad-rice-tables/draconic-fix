UPDATE gameobject_template SET IconName='',castBarCaption='' WHERE entry=574602;
DELETE FROM creature_addon WHERE guid=3000209544;
UPDATE creature_template SET npcflag=npcflag&~16777216 WHERE entry IN (251863,251866);
DELETE FROM npc_spellclick_spells WHERE npc_entry IN (251863,251866);
DELETE FROM smart_scripts WHERE source_type=12 AND entryorguid=9108403 AND id=4;
