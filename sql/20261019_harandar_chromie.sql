-- Choose a Path (94444/94445): objective "Talk to Chromie" is Type 3 (TALKTO) -> needs SMART_ACTION_CREDIT_QUEST_OBJECTIVE_TALK_TO (153).
-- The existing Chromie SAI rows only give kill credit (action 33), which never completes a TALKTO objective.
DELETE FROM smart_scripts WHERE source_type = 0 AND entryorguid = 167032 AND id = 110;
CREATE TEMPORARY TABLE tmp_chromie AS SELECT * FROM smart_scripts WHERE source_type = 0 AND entryorguid = 167032 AND id = 100;
UPDATE tmp_chromie SET id = 110, link = 0, action_type = 153, action_param1 = 0, action_param2 = 0, action_param3 = 0, action_param4 = 0, action_param5 = 0, action_param6 = 0,
  comment = 'On player opened gossip - Credit quest objective Talk To (Choose a Path)';
INSERT INTO smart_scripts SELECT * FROM tmp_chromie;
DROP TEMPORARY TABLE tmp_chromie;
