DELETE FROM hotfixes.hotfix_data WHERE Id=1960012;
DELETE FROM hotfixes.gameobject_display_info WHERE ID IN (9011001,9011002);
DELETE FROM hotfixes.achievement WHERE ID=9011001;
UPDATE world.gameobject_template SET displayId=928 WHERE entry=322354;
DELETE FROM world.gameobject_template WHERE entry=9330401;
DELETE FROM world.creature_template WHERE entry IN (9330311,9330312);
DELETE FROM world.creature_template_model WHERE CreatureID IN (9330311,9330312);
UPDATE world.quest_template SET LogTitle='Report to the Archon',LogDescription='Report to the Archon of the expedition what you learned from the Anima Crystal.',QuestDescription='The crystal was never delivered, and our superiors are growing impatient.\n\nGo to the Archon and report everything you learned from the Anima Crystal beneath the Valley of Trials.',QuestCompletionLog='Report to the Archon.' WHERE ID=9330014;
UPDATE world.creature SET position_x=1300.07,position_y=-3103.56,position_z=3295.49 WHERE id=9330301;
