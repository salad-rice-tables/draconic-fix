-- 20261026_suramar_npc_questgiver_flags.sql
-- NPC quest-giver flagy z čerstvého oc_suramar_audit (BLOCK NPC_NOQUESTFLAG):
--   110565 (41111 Rain Death Upon Them): npcflag 0 -> QUESTGIVER(2)  [Gossip=1, QUESTGIVER=2, enuminfo_UnitDefines.cpp]
--   132029 (40949 Not Their Last Stand): npcflag 1 -> GOSSIP|QUESTGIVER (3)
UPDATE creature_template SET npcflag = 2 WHERE entry = 110565;
UPDATE creature_template SET npcflag = 3 WHERE entry = 132029;
