-- TALKTO objectives (Type 3) are only completed by SMART_ACTION_CREDIT_QUEST_OBJECTIVE_TALK_TO (153); these NPCs only had kill-credit SAI.
-- 86642 A Foe Unseen (Dead Amani Feller 245219), 86911 Echoes and Memories (Ancient Visionstone 243305), 90094 Echo of the Hunt (243306)
DELETE FROM smart_scripts WHERE source_type = 0 AND entryorguid IN (245219, 243305, 243306) AND id = 110;
CREATE TEMPORARY TABLE tmp_talk AS SELECT * FROM smart_scripts WHERE source_type = 0 AND entryorguid IN (245219, 243305, 243306) AND id = 100;
UPDATE tmp_talk SET id = 110, link = 0, action_type = 153, action_param1 = 0, action_param2 = 0, action_param3 = 0, action_param4 = 0, action_param5 = 0, action_param6 = 0,
  comment = 'On player opened gossip - Credit quest objective Talk To';
INSERT INTO smart_scripts SELECT * FROM tmp_talk;
DROP TEMPORARY TABLE tmp_talk;
