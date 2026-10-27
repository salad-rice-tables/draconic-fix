-- 86852 Light's Last Stand: retail gives Liadrin a quest gossip option "Nothing will get past me!" that starts the ritual (wiki).
-- Server had menu 999999999 (empty) and gave the objective credit on gossip OPEN (SAI 64). Now: own menu + credit on select.
CREATE TABLE IF NOT EXISTS bak_20261021_ct_gossip_237278 LIKE creature_template_gossip;
INSERT INTO bak_20261021_ct_gossip_237278 SELECT * FROM creature_template_gossip WHERE CreatureID=237278 AND CreatureID NOT IN (SELECT CreatureID FROM bak_20261021_ct_gossip_237278);
CREATE TABLE IF NOT EXISTS bak_20261021_sai_237278 LIKE smart_scripts;
INSERT INTO bak_20261021_sai_237278 SELECT * FROM smart_scripts WHERE source_type=0 AND entryorguid=237278 AND NOT EXISTS (SELECT 1 FROM bak_20261021_sai_237278 b WHERE b.entryorguid=237278 AND b.id=smart_scripts.id);
DELETE FROM gossip_menu WHERE MenuID=912046810;
INSERT INTO gossip_menu (MenuID, TextID, VerifiedBuild) VALUES (912046810, 999999999, 0);
DELETE FROM gossip_menu_option WHERE MenuID=912046810;
INSERT INTO gossip_menu_option (MenuID, GossipOptionID, OptionID, OptionNpc, OptionText, OptionBroadcastTextID, Language, Flags, ActionMenuID, ActionPoiID, GossipNpcOptionID, BoxCoded, BoxMoney, BoxText, BoxBroadcastTextID, SpellID, OverrideIconID, VerifiedBuild)
VALUES (912046810, 912046810, 0, 0, '(Quest) Nothing will get past me!', 0, 0, 0, 0, 0, NULL, 0, 0, '', 0, NULL, NULL, 0);
UPDATE creature_template_gossip SET MenuID = 912046810 WHERE CreatureID = 237278;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=237278 AND id IN (101,102);
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment)
VALUES (237278,0,102,0,62,0,100,0,912046810,0,0,0,0,33,241575,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Light''s Last Stand - gossip select "Nothing will get past me!" - credit Speak with Liadrin to begin the ritual');
