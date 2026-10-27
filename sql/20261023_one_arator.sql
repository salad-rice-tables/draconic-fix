-- 86643: only ONE Arator at a time. Remove the fixed stage-2 / stage-3 guide spawns; the entrance Arator (3000209544, phase 45629) is moved by Lua/SAI.
DELETE FROM creature WHERE guid=3000209807;
DELETE FROM creature_addon WHERE guid=3000209807;
