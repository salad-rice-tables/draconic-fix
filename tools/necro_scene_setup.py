"""Necromancer initiation v2 data: Tome/crystal models, achievement, Q4 rename, Archon position, Initiate/Veteran templates. Idempotent. Needs ONE worldserver restart + client DBCache delete (hotfix rows).
Undo: sql/20261113_necro_scene_undo.sql"""
import pymysql, os
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
H = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
PUSH, UID, B = 1960012, 4100150000, 69933
H_GDI, H_ACH = 1829768651, 3538824359
# 1. model displays (FileDataIDs from the spec): book 5076647, active crystal 354682
for did, fdid in ((9011001, 5076647), (9011002, 354682)):
    H.execute('delete from gameobject_display_info where ID=%s', (did,))
    H.execute('insert into gameobject_display_info select %s,GeoBoxMinX,GeoBoxMinY,GeoBoxMinZ,GeoBoxMaxX,GeoBoxMaxY,GeoBoxMaxZ,%s,ObjectEffectPackageID,OverrideLootEffectScale,OverrideNameScale,AlternateDisplayType,ClientCreatureDisplayInfoID,ClientItemID,Unknown1100,%s from gameobject_display_info where ID=517085', (did, fdid, B))
# 2. achievement 9011001 (clone of 62406 so every column is valid)
H.execute('delete from achievement where ID=9011001')
H.execute('insert into achievement select %s,%s,Reward,9011001,InstanceID,Faction,Supercedes,Category,MinimumCriteria,10,0,UiOrder,IconFileID,0,0,0,CovenantID,0,0,%s from achievement where ID=62406',
          ('You touched the Maldraxxian Anima Crystal and awakened the Life Force within.', 'Touched by Death', B))
H.execute('delete from hotfix_data where Id=%s', (PUSH,))
for n, (h, r) in enumerate(((H_GDI, 9011001), (H_GDI, 9011002), (H_ACH, 9011001))):
    H.execute('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', (PUSH, UID + n, h, r, B))
# 3. templates: Tome gets the new book model, active-crystal overlay object, Initiate / Veteran NPCs
W.execute('update gameobject_template set displayId=9011001 where entry=322354')
W.execute('delete from gameobject_template where entry=9330401')
W.execute('create temporary table _g select * from gameobject_template where entry=5080290'); W.execute('update _g set entry=9330401,type=5,displayId=9011002'); W.execute('insert into gameobject_template select * from _g'); W.execute('drop temporary table _g')
for new, src, name, sub, flag in ((9330311, 161180, 'Necromancer Initiate', 'House of Plagues', 0), (9330312, 163243, 'Veteran Necromancer', 'Maldraxxian Necromancer', 0)):
    W.execute('delete from creature_template where entry=%s', (new,)); W.execute('delete from creature_template_model where CreatureID=%s', (new,))
    W.execute('create temporary table _t select * from creature_template where entry=%s', (src,))
    W.execute('update _t set entry=%s,name=%s,subname=%s,npcflag=%s', (new, name, sub, flag)); W.execute('insert into creature_template select * from _t'); W.execute('drop temporary table _t')
    W.execute('insert into creature_template_model select %s,Idx,CreatureDisplayID,DisplayScale,Probability,VerifiedBuild from creature_template_model where CreatureID=%s', (new, src))
# 4. Q4 retitle (text is mine: spec gives only the intent) + Archon at his spec'd position
W.execute('select LogTitle,LogDescription,QuestDescription,QuestCompletionLog from quest_template where ID=9330014'); old = W.fetchone()
W.execute('update quest_template set LogTitle=%s,LogDescription=%s,QuestDescription=%s,QuestCompletionLog=%s where ID=9330014',
          ('Initiation of Death', 'Report to Archon Vel\'moth in the House of Plagues academy and witness the arrival of the new students.',
           'You carry new necrotic power now, but do not mistake it for mastery: you are still an Initiate, and nothing grand awaits you.\n\nAn initiation is coming. Make your way to Archon Vel\'moth and report to him. Others will arrive at the academy as you do.',
           'Report to Archon Vel\'moth at the academy.'))
W.execute('delete from quest_template_locale where ID=9330014')
W.execute('select guid from creature where id=9330301'); g = W.fetchone()[0]
W.execute('update creature set map=2222,position_x=1035.933105,position_y=-3021.173828,position_z=3286.026611,orientation=5.410259 where id=9330301')
open(os.path.join(r'C:\WowServer\Custom\sql', '20261113_necro_scene_undo.sql'), 'w', encoding='utf-8').write(
    "DELETE FROM hotfixes.hotfix_data WHERE Id=1960012;\nDELETE FROM hotfixes.gameobject_display_info WHERE ID IN (9011001,9011002);\nDELETE FROM hotfixes.achievement WHERE ID=9011001;\nUPDATE world.gameobject_template SET displayId=928 WHERE entry=322354;\nDELETE FROM world.gameobject_template WHERE entry=9330401;\nDELETE FROM world.creature_template WHERE entry IN (9330311,9330312);\nDELETE FROM world.creature_template_model WHERE CreatureID IN (9330311,9330312);\n"
    "UPDATE world.quest_template SET LogTitle=%r,LogDescription=%r,QuestDescription=%r,QuestCompletionLog=%r WHERE ID=9330014;\nUPDATE world.creature SET position_x=1300.07,position_y=-3103.56,position_z=3295.49 WHERE id=9330301;\n" % tuple(old))
print('ok')
