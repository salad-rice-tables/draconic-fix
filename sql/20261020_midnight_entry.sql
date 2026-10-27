-- Midnight entry: Image of Lady Liadrin (241677), gossip menu 39008 option "Please summon me to the Isle of Quel'Danas" (OptionID 3)
-- had no SAI at all, so the intro quest 88719 "A Voice from the Light" could not take the player to Quel'Danas.
-- Same behaviour as the existing custom "Watch the movie!" menu: movie 1051 + teleport to the Isle (map 2858).
DELETE FROM smart_scripts WHERE source_type = 0 AND entryorguid = 241677 AND id IN (20, 21);
CREATE TEMPORARY TABLE tmp_liadrin AS SELECT * FROM smart_scripts WHERE source_type = 0 AND entryorguid = 241677 AND id IN (1, 2);
UPDATE tmp_liadrin SET id = id + 19, event_param1 = 39008, event_param2 = 3, comment = 'On gossip option 3 (summon me to Quel''Danas) from menu 39008 - movie / teleport';
INSERT INTO smart_scripts SELECT * FROM tmp_liadrin;
DROP TEMPORARY TABLE tmp_liadrin;
