-- Ritual Vase: PlayerCondition 39344 (Data19) does not exist in our data -> remove requirement (item/objective logic is done by SAI conditions)
UPDATE gameobject_template SET Data19=0 WHERE entry=542849;
