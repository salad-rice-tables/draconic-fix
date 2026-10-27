-- 86643 v2 (user-described retail flow): Arator kneels at entrance totem; Shrouding Totem 'Destroying' castbar; Grimfire/Stranglemist are 'Destroying' spellclick; scripted by Custom/lua/following_the_root.lua
UPDATE gameobject_template SET IconName='questinteract',castBarCaption='Destroying' WHERE entry=574602;
UPDATE creature SET orientation=1.12 WHERE guid=3000209544;
REPLACE INTO creature_addon (guid,PathId,mount,MountCreatureID,StandState,AnimTier,VisFlags,SheathState,PvPFlags,emote,aiAnimKit,movementAnimKit,meleeAnimKit,visibilityDistanceType,auras) VALUES (3000209544,0,0,0,8,0,0,1,0,0,0,0,0,0,NULL);
UPDATE creature_template SET npcflag=npcflag|16777216 WHERE entry IN (251863,251866);
DELETE FROM npc_spellclick_spells WHERE npc_entry IN (251863,251866);
INSERT INTO npc_spellclick_spells (npc_entry,spell_id,cast_flags,user_type) VALUES (251863,1254243,1,0),(251866,1254243,1,0);
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=236610 AND id IN (102,104,105,110);
DELETE FROM smart_scripts WHERE source_type=9 AND entryorguid=23661000;
DELETE FROM smart_scripts WHERE source_type=12 AND entryorguid=9108403 AND id=4;
CREATE TEMPORARY TABLE t_ss SELECT * FROM smart_scripts WHERE entryorguid=9108403 AND source_type=12 AND id=3;
UPDATE t_ss SET id=4,action_type=1,action_param1=0,action_param2=0,action_param3=0,target_type=9,target_param1=236610,target_param2=0,target_param3=40,comment='Areatrigger: Arator says retail line (This is the place)';
INSERT INTO smart_scripts SELECT * FROM t_ss;
DROP TEMPORARY TABLE t_ss;
