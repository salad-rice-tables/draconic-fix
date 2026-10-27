DELETE FROM creature_text WHERE CreatureID IN (241206,241205,236610,237344);
DELETE FROM conversation_actors WHERE ConversationId=9108602;
DELETE FROM conversation_line_template WHERE Id BETWEEN 87529 AND 87534;
DELETE FROM conversation_template WHERE Id=9108602;
DELETE FROM smart_scripts WHERE source_type=0 AND ((entryorguid=241176 AND id=102) OR (entryorguid IN (241206,241205) AND id=110) OR (entryorguid=236610 AND id IN (104,110)) OR (entryorguid=237344));
UPDATE smart_scripts SET event_type=64,event_param1=0,event_param2=0 WHERE source_type=0 AND entryorguid=241176 AND id=101;
