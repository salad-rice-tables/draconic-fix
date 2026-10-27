-- An Ancient Gift (QuestLine 158) part 1: Arcane Communion (40324) + Scenes from a Memory (40325)
-- remove the shortcut credits (custom area triggers that gave "Theryn fed" when walking past Thalyssra/Theryn)
DELETE FROM smart_scripts WHERE source_type=12 AND entryorguid IN (9106439,9106440) AND id=3;
-- Theryn: Eluna gossip (feed option from menu 19687), no oathstone auto credit
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=104618;
UPDATE creature_template SET AIName='' WHERE entry=104618;
-- ghostly Memories (107631, 62 spawns in phase 41084): clickable (gossip flag) -> dismissed by Lua
UPDATE creature_template SET npcflag=npcflag|1 WHERE entry=107631;
DELETE FROM creature_template_gossip WHERE CreatureID=107631;
INSERT INTO creature_template_gossip (CreatureID,MenuID,VerifiedBuild) VALUES (107631,999999999,0);
-- Memory click text / Theryn entranced text (retail broadcast texts 111653 / 111318)
DELETE FROM npc_text WHERE ID IN (9108880,9108881);
INSERT INTO npc_text (ID,Probability0,BroadcastTextID0,VerifiedBuild) VALUES (9108880,1,111318,0),(9108881,1,111653,0);
