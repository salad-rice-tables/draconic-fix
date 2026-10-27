-- 86643: personal phases (Blizzard style): 45629/45630/45631 = Normal(0x08)+Personal(0x20) => each player gets his own Arator, totems, barriers
UPDATE phase SET Flags=40 WHERE ID IN (45629,45630,45631);
-- Shrouding Totems only visible with the quest in progress (phase 45629)
UPDATE gameobject SET PhaseId=45629 WHERE id=574602 AND map=0 AND position_x BETWEEN 6030 AND 6046 AND position_y BETWEEN -5178 AND -5168;
