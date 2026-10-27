-- 2026-10-25 Suramar: An Elven Problem scene phases were Normal|Cosmetic (Flags=20).
-- PhasingHandler::GetPhaseFlags checks Cosmetic first, so the server never granted these
-- phases and Khadgar/Tyrande/Rommath/Liadrin/scouts were not interactable.
-- Normal = 8 (DBCEnums.h:2155 PhaseEntryFlags).

UPDATE hotfixes.phase SET Flags = 8 WHERE ID IN (45536,45537,45538,45544,45546);
