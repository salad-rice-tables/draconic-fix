-- Rootway gates for the end of "My Story, My Legacy": retail "Rootway to Azeroth" (248839) cloned twice with the faction names and the green gate
-- model (131796, scale 1.05), gossip-flagged and with the dummy gossip menu so the client shows the interaction cursor. Needs a restart to load.
DELETE FROM creature_template WHERE entry IN (9100801, 9100802);
DELETE FROM creature_template_model WHERE CreatureID IN (9100801, 9100802);
DELETE FROM creature_template_difficulty WHERE Entry IN (9100801, 9100802);
DELETE FROM creature_template_gossip WHERE CreatureID IN (9100801, 9100802);

CREATE TEMPORARY TABLE tmp_rw AS SELECT * FROM creature_template WHERE entry = 248839;
UPDATE tmp_rw SET entry = 9100801, name = 'Rootway to Stormwind', npcflag = 1, AIName = '', ScriptName = '', faction = 35, scale = 1;
INSERT INTO creature_template SELECT * FROM tmp_rw;
UPDATE tmp_rw SET entry = 9100802, name = 'Rootway to Orgrimmar';
INSERT INTO creature_template SELECT * FROM tmp_rw;
DROP TEMPORARY TABLE tmp_rw;

INSERT INTO creature_template_model (CreatureID, Idx, CreatureDisplayID, DisplayScale, Probability, VerifiedBuild)
VALUES (9100801, 0, 131796, 1.05, 1, 0), (9100802, 0, 131796, 1.05, 1, 0);

CREATE TEMPORARY TABLE tmp_rwd AS SELECT * FROM creature_template_difficulty WHERE Entry = 248839;
UPDATE tmp_rwd SET Entry = 9100801;
INSERT INTO creature_template_difficulty SELECT * FROM tmp_rwd;
UPDATE tmp_rwd SET Entry = 9100802;
INSERT INTO creature_template_difficulty SELECT * FROM tmp_rwd;
DROP TEMPORARY TABLE tmp_rwd;

INSERT INTO creature_template_gossip (CreatureID, MenuID, VerifiedBuild) VALUES (9100801, 999999999, 0), (9100802, 999999999, 0);
