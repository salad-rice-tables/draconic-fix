-- 86806: civilians stand on ship decks / in rowboats (gameobjects). The server has no collision for those models, so gravity
-- dropped the civilians into the water and they drifted off the boats. FLOATING (disable gravity) keeps them at their spawn height.
CREATE TABLE IF NOT EXISTS bak_20261021_civ_ctd LIKE creature_template_difficulty;
INSERT INTO bak_20261021_civ_ctd SELECT * FROM creature_template_difficulty WHERE Entry IN (241790,241810,241817,241818,241819) AND NOT EXISTS (SELECT 1 FROM bak_20261021_civ_ctd b WHERE b.Entry=creature_template_difficulty.Entry AND b.DifficultyID=creature_template_difficulty.DifficultyID);
UPDATE creature_template_difficulty SET StaticFlags1 = StaticFlags1 | 0x20000000 WHERE Entry IN (241790,241810,241817,241818,241819);
