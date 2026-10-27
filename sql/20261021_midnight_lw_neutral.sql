-- 86806 (user request): Void Invaders neutral (yellow, faction 7 "Creature"): never aggro, still attackable for Spiraling Light.
UPDATE creature_template SET faction = 7 WHERE entry IN (240263, 241807);
