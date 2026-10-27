-- Stranglemist must only cast Poison Nova: remove Firestorm-style aura 398541 (kept on Grimfire)
UPDATE creature_addon SET auras=NULL WHERE guid=3000209546;
