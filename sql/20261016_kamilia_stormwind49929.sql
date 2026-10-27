-- KamiliaBlow port d7831d8714 (2026-10-15): DB/Stormwind fix The Call for Allies (49929) obsolete
-- Source: https://github.com/KamiliaBlow/RoleplayCore commit d7831d8714fd85f36d5e0452edcc44eb1cad15ea
-- NEEDS restart? No, world DB hot-reload on restart only for quest_addon/GO state; restart recommended.
-- A Choice of Allies (50239): prerequisite 49929 deprecated, has no starter -> unblock chain
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 50239;
-- Void Elf banner in Stormwind embassy spawned active, blocked "Learn about the Void Elves"
UPDATE `gameobject` SET `state` = 1 WHERE `guid` = 6000625;
