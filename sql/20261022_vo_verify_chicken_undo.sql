-- Chicken (620) g1/0 pointed at BroadcastText 5140 ("Skinning"); TDB 12.1.0 has the
-- retail chicken emote text. Clear the link, restore the text.

UPDATE world.creature_text SET Text='Skinning', BroadcastTextId=5140, Sound=0 WHERE CreatureID=620 AND GroupID=1 AND ID=0;
