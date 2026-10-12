-- Undo pre lw_weather.sql: len 19 zon, ktore pridal (ostatne boli retail a INSERT IGNORE ich nemenil)
DELETE FROM `world`.`game_weather` WHERE `zone` IN (14,1637,17,1638,1657,331,406,400,16,361,493,616,1519,40,5287,8,4,130,25);
