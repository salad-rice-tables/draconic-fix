-- UNDO: 20261019_harandar_chain_rewards.sql
-- Navrat do stavu pred aplikaciou (stav 2026-10-19 pred fixom):
--   - vsetky odmeny: 0 poloziek, RewardBonusMoney=0
--   - retazec: len 90958.Prev=90957, ostatne 0 (ziadne Next)
--   - Song header npc_text zmazany

UPDATE quest_template SET
  RewardItem1=0, RewardAmount1=0,
  RewardItem2=0, RewardAmount2=0,
  RewardItem3=0, RewardAmount3=0,
  RewardItem4=0, RewardAmount4=0,
  RewardBonusMoney=0
WHERE ID IN (90957, 90958, 90959, 90960, 90961);

UPDATE quest_template_addon SET PrevQuestID=90957, NextQuestID=0
WHERE ID=90958;
-- riadky 90957/90959/90960/90961 pred fixom NEEXISTOVALI -> zmazat
DELETE FROM quest_template_addon WHERE ID IN (90957, 90959, 90960, 90961);

DELETE FROM npc_text WHERE ID=1000000011;
