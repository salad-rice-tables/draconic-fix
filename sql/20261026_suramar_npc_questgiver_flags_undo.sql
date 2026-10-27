-- 20261026_suramar_npc_questgiver_flags_undo.sql
UPDATE creature_template SET npcflag = 0 WHERE entry = 110565;
UPDATE creature_template SET npcflag = 1 WHERE entry = 132029;
