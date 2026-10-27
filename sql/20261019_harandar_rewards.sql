-- Harandar intro rewards per the user's spec (Initiation Day.md):
--   90957 Initiation Day:    20s + 1470 XP + Hardened Haranir Cowl (257530)
--   90959 Traditional Duties: 20s + 1470 XP + Hardened Haranir Leaves (257561)
--   90958 Roots Above All:   20s + 1470 XP (no item)
-- (before: 90957 -> 257527/257528 Woven+Entwined Cowl, 90959 -> 257558/257559 Woven+Entwined Leaves, i.e. two wrong variants)
UPDATE quest_template SET RewardItem1 = 257530, RewardAmount1 = 1, RewardItem2 = 0, RewardAmount2 = 0 WHERE ID = 90957;
UPDATE quest_template SET RewardItem1 = 257561, RewardAmount1 = 1, RewardItem2 = 0, RewardAmount2 = 0 WHERE ID = 90959;
UPDATE quest_template SET RewardItem1 = 0, RewardAmount1 = 0, RewardItem2 = 0, RewardAmount2 = 0 WHERE ID = 90958;
