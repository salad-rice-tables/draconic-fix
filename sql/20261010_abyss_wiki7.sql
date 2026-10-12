-- Say po report buttone idu uz len cez Elunu (rising_storm_chatter.lua, overena cesta).
-- SmartAI TALK riadky sa mazú, aby pri prípadnom zapálení SmartAI nedošlo k dvojitej replike.
-- Kreditové riadky (linky) ostávajú ako záloha - duplicitný kredit je neškodný (objektív max 1).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom.
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = -250580 AND `source_type` = 0 AND `id` = 1 AND `comment` LIKE '%(wiki)';
DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` = -9100622 AND `source_type` = 0 AND `id` = 3 AND `comment` LIKE '%(wiki)';
