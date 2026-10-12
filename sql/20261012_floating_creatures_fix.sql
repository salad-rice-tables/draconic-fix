-- Ground creatures wrongly flagged FLOATING (0x20000000, "don't use": disables gravity) get CAN_SWIM (0x10000000) instead; other bits are kept.
-- Westfall: Goretusk 157, Young Goretusk 454, Coyote 834; Stormwind/Orgrimmar: Chromie 167032, Lorewalker Cho 230246, General Nazgrim 55054.
UPDATE world.creature_template_difficulty SET StaticFlags1 = (StaticFlags1 & ~536870912) | 268435456
 WHERE Entry IN (157, 454, 834, 167032, 230246, 55054) AND DifficultyID = 0;
