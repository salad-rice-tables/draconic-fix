-- Delve The Shadow Enclave (map 2952) for 86636 Void Walk With Me:
--  * Delvers' Supplies (207283) had no spawn in the delve -> objective "Open the Delvers' Supplies" (credit 220749 via existing SAI) was impossible.
--  * Valeera (242099) is the delve companion; retail objective "Select a Combat Role" is criteria tree 225238 = GainAura of one of 3 role auras
--    (1250821 / 1249646 / 1251118). Replacement for the companion UI: 3 gossip options (only on map 2952) that cast the matching aura on the player.
CREATE TEMPORARY TABLE t_c AS SELECT * FROM creature WHERE guid=3000204251;
UPDATE t_c SET guid=3000500830, map=2952, zoneId=0, areaId=0, PhaseId=0, PhaseGroup=0, phaseUseFlags=0, position_x=3, position_y=236, position_z=267, orientation=3.58;
INSERT INTO creature SELECT * FROM t_c;
UPDATE t_c SET guid=3000500831, id=207283, position_x=-3, position_y=233, position_z=267;
INSERT INTO creature SELECT * FROM t_c;
DROP TEMPORARY TABLE t_c;
INSERT INTO gossip_menu_option (MenuID,GossipOptionID,OptionID,OptionNpc,OptionText,OptionBroadcastTextID,Language,Flags,ActionMenuID,ActionPoiID,BoxCoded,BoxMoney,BoxBroadcastTextID,VerifiedBuild) VALUES
(912046759,912046811,1,0,'(Quest) Valeera, fight as a Defender.',0,0,0,0,0,0,0,0,0),
(912046759,912046812,2,0,'(Quest) Valeera, fight as a Healer.',0,0,0,0,0,0,0,0,0),
(912046759,912046813,3,0,'(Quest) Valeera, fight as a Damage Dealer.',0,0,0,0,0,0,0,0,0);
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment) VALUES
(15,912046759,1,0,0,22,0,2952,0,0,0,0,0,'','Valeera role option only inside The Shadow Enclave'),
(15,912046759,2,0,0,22,0,2952,0,0,0,0,0,'','Valeera role option only inside The Shadow Enclave'),
(15,912046759,3,0,0,22,0,2952,0,0,0,0,0,'','Valeera role option only inside The Shadow Enclave'),
(15,912046759,1,0,0,47,0,86636,10,0,0,0,0,'','only while Void Walk With Me is in progress'),
(15,912046759,2,0,0,47,0,86636,10,0,0,0,0,'','only while Void Walk With Me is in progress'),
(15,912046759,3,0,0,47,0,86636,10,0,0,0,0,'','only while Void Walk With Me is in progress');
DELETE FROM smart_scripts WHERE entryorguid=242099 AND source_type=0 AND id IN (110,111,112);
INSERT INTO smart_scripts (entryorguid,source_type,id,link,event_type,event_phase_mask,event_chance,event_flags,event_param1,event_param2,event_param3,event_param4,event_param5,event_param_string,action_type,action_param1,action_param2,action_param3,action_param4,action_param5,action_param6,action_param7,action_param_string,target_type,target_param1,target_param2,target_param3,target_param4,target_x,target_y,target_z,target_o,comment) VALUES
(242099,0,110,0,62,0,100,0,912046759,1,0,0,0,'',85,1250821,2,0,0,0,0,0,'',7,0,0,0,0,0,0,0,0,'Valeera role: Defender (aura 1250821) completes criteria tree 225238'),
(242099,0,111,0,62,0,100,0,912046759,2,0,0,0,'',85,1249646,2,0,0,0,0,0,'',7,0,0,0,0,0,0,0,0,'Valeera role: Healer (aura 1249646)'),
(242099,0,112,0,62,0,100,0,912046759,3,0,0,0,'',85,1251118,2,0,0,0,0,0,'',7,0,0,0,0,0,0,0,0,'Valeera role: Damage (aura 1251118)');
-- spawn positions corrected to the delve arena (140,-65,217) after test
UPDATE creature SET position_x=135,position_y=-58,position_z=216.7,orientation=4.4 WHERE guid=3000500830; UPDATE creature SET position_x=146,position_y=-66,position_z=216.7 WHERE guid=3000500831;
