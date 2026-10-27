-- 86838 Renewal for the Weary: rewards are "choose one" (Warcraft Wiki), not all four
UPDATE quest_template SET RewardItem1=0,RewardAmount1=0,RewardItem2=0,RewardAmount2=0,RewardItem3=0,RewardAmount3=0,RewardItem4=0,RewardAmount4=0,
 RewardChoiceItemID1=251274,RewardChoiceItemQuantity1=1,RewardChoiceItemID2=251275,RewardChoiceItemQuantity2=1,
 RewardChoiceItemID3=251276,RewardChoiceItemQuantity3=1,RewardChoiceItemID4=251277,RewardChoiceItemQuantity4=1 WHERE ID=86838;
