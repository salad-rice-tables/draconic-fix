-- Forgotten Melody (246546) needs a gossip menu like the other Harandar interactables, otherwise the client shows no interaction cursor
DELETE FROM creature_template_gossip WHERE CreatureID = 246546;
INSERT INTO creature_template_gossip (CreatureID, MenuID, VerifiedBuild) VALUES (246546, 999999999, 0);
