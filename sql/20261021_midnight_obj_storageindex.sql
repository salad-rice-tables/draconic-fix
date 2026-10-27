-- Midnight (Expansion 11) quests with duplicate quest_objectives.StorageIndex (tracker breaks; e.g. 86807 The Gate had two index-0 rows).
-- 1) retail rows (present in tdb1210_world): restore StorageIndex/Order from TDB
-- 2) synthetic rows (not in TDB) that duplicate a retail row's Type+ObjectID in the same quest: delete
-- 3) remaining synthetic rows still colliding: move to a free StorageIndex
CREATE TABLE IF NOT EXISTS bak_20261021_qo_si LIKE quest_objectives;
DROP TEMPORARY TABLE IF EXISTS dq;
CREATE TEMPORARY TABLE dq AS SELECT DISTINCT o.QuestID FROM quest_objectives o JOIN quest_template q ON q.ID=o.QuestID
  WHERE q.Expansion=11 AND o.StorageIndex>=0 GROUP BY o.QuestID,o.StorageIndex HAVING COUNT(*)>1;
INSERT INTO bak_20261021_qo_si SELECT * FROM quest_objectives WHERE QuestID IN (SELECT QuestID FROM dq) AND ID NOT IN (SELECT ID FROM bak_20261021_qo_si);
UPDATE quest_objectives l JOIN tdb1210_world.quest_objectives t ON t.ID=l.ID SET l.StorageIndex=t.StorageIndex, l.`Order`=t.`Order`
  WHERE l.QuestID IN (SELECT QuestID FROM dq);
DELETE l FROM quest_objectives l
  WHERE l.QuestID IN (SELECT QuestID FROM dq) AND l.ID NOT IN (SELECT ID FROM tdb1210_world.quest_objectives)
    AND EXISTS (SELECT 1 FROM tdb1210_world.quest_objectives t WHERE t.QuestID=l.QuestID AND t.Type=l.Type AND t.ObjectID=l.ObjectID);
-- Left on purpose (22 quests): synthetic Type-0 rows that share the StorageIndex of an unsupported retail objective (Type 21 criteria
-- tree, Type 2/3 etc.) so the retail tracker line advances; those collisions are the workaround, not the bug.
