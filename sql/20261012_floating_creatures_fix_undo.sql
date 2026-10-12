-- original values before the fix
UPDATE world.creature_template_difficulty SET StaticFlags1 = 536870912 WHERE Entry IN (157, 454, 834, 55054) AND DifficultyID = 0;
UPDATE world.creature_template_difficulty SET StaticFlags1 = 805306368 WHERE Entry = 167032 AND DifficultyID = 0;
UPDATE world.creature_template_difficulty SET StaticFlags1 = 805306624 WHERE Entry = 230246 AND DifficultyID = 0;
