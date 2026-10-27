DELETE FROM creature_template WHERE entry IN (9100801, 9100802);
DELETE FROM creature_template_model WHERE CreatureID IN (9100801, 9100802);
DELETE FROM creature_template_difficulty WHERE Entry IN (9100801, 9100802);
DELETE FROM creature_template_gossip WHERE CreatureID IN (9100801, 9100802);
