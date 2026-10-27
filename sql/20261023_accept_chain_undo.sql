DELETE FROM conversation_actors WHERE ConversationId=9108604;
DELETE FROM conversation_template WHERE Id=9108604;
DELETE FROM conversation_line_template WHERE Id IN (82094,82371);
UPDATE conversation_line_template SET ActorIdx=0 WHERE Id BETWEEN 87529 AND 87534;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=241205 AND id=112;
