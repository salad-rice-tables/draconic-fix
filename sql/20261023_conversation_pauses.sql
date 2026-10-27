-- 2.5s pause between spoken lines like retail (Halduron 87529-87534, Zul'jan 89276-89291); last line of each conversation has no trailing pause
UPDATE conversation_line SET AdditionalDuration=2500 WHERE (ID BETWEEN 87529 AND 87533) OR (ID BETWEEN 89276 AND 89290);
UPDATE conversation_line SET AdditionalDuration=0 WHERE ID IN (87534,89291);
