-- 20261026_suramar_all_in.sql
-- Fix for 43564 Flow Control and 43567 All In (blocking Arcan'dor campaign chapter).
-- Restores genuine retail TDB objectives for 43567 (replacing the broken 9-stage custom hack),
-- unlocks the 3 Arcway outlets for 43564, and configures wounded Arluin 113062 for the death scene.

-- 1. 43564 Flow Control outlets: remove lock 1690 and playerCondition 120364 so they can be clicked
UPDATE gameobject_template SET Data0=0, Data14=0, Data33=500 WHERE entry IN (252776, 252779, 252783);

-- 2. 43567 All In: restore retail objectives from tdb1210_world
DELETE FROM quest_objectives WHERE QuestID=43567;
INSERT INTO quest_objectives (ID, QuestID, Type, `Order`, StorageIndex, ObjectID, Amount, ConditionalAmount, Flags, Flags2, ProgressBarWeight, ParentObjectiveID, Visible, Description, VerifiedBuild) VALUES
(286332, 43567, 0, 0, 0, 113069, 1, 0, 0, 0, 0.0, 0, 1, 'Nightflow Conduit sabotaged', 69497),
(286333, 43567, 0, 1, 1, 113062, 1, 0, 2, 0, 0.0, 0, 1, 'Check on Arluin', 69497),
(286334, 43567, 0, 3, 2, 113070, 1, 0, 2, 0, 0.0, 0, 1, 'Enter Shal\'Aran', 69497),
(286567, 43567, 0, 2, 3, 113061, 1, 0, 28, 0, 0.0, 0, 1, 'Arrival event', 69497);

-- 3. Configure wounded Arluin (113062) for the scene
UPDATE creature_template SET faction=35, npcflag=1, AIName='' WHERE entry=113062;
DELETE FROM creature_template_gossip WHERE CreatureID=113062;
INSERT INTO creature_template_gossip (CreatureID, MenuID, VerifiedBuild) VALUES (113062, 999999999, 0);
