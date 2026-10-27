DELETE FROM smart_scripts WHERE (source_type=0 AND entryorguid=236610 AND id=114) OR (source_type=9 AND entryorguid=23661010);
DELETE FROM conversation_actors WHERE ConversationId=9108610;
DELETE FROM conversation_template WHERE Id=9108610;
DELETE FROM conversation_line_template WHERE Id BETWEEN 64890 AND 64895;
DELETE FROM creature_text WHERE CreatureID=236610 AND GroupID IN (5,6,7);
UPDATE gameobject SET PhaseId=0 WHERE guid IN (990000000101167824,990000000101167825,990000000101167826);
