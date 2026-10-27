-- 90958: the item objective must read "Outsider's Gear 0/1" (item name), not the stale text "Mysterious Voice investigated"
UPDATE quest_objectives SET Description = '' WHERE ID = 462388 AND QuestID = 90958;
