-- ============================================================================
-- 20261019_harandar_grovewarden_fix_undo.sql
-- Undo pre 20261019_harandar_grovewarden_fix.sql
-- ============================================================================

-- Vratit spawn-y naspat (odstranit obnovene riadky)
DELETE FROM world.creature WHERE guid IN (11000748, 11000749, 11000750) AND id = 248905;

-- Vratit povodnu (bugovu) world faction 14
UPDATE world.creature_template SET faction = 14 WHERE entry = 248905;
