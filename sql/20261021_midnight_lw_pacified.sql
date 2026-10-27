-- 86806: Void Invaders must never hurt the rider. React-passive did not hold (core resets it), so: pacified (cannot attack or cast)
-- and zero damage. They stay hostile (red) and attackable for Spiraling Light.
UPDATE creature_template SET unit_flags = unit_flags | 0x00020000 WHERE entry IN (240263, 241807);
UPDATE creature_template_difficulty SET DamageModifier = 0 WHERE Entry IN (240263, 241807);
