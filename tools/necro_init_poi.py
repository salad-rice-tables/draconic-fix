import os
"""Quest map points (quest_poi / quest_poi_points) for the Necromancer initiation quests 9330011-9330014, from data/necro_init/locations.json.
Each quest gets a quest-level blob (where to go next) and, for the scripted objective, an objective blob. Re-runnable.  usage: python tools/necro_init_poi.py"""
import json, pymysql
L = json.load(open(r'C:\WowServer\Custom\data\necro_init\locations.json', encoding='utf-8'))
UI = {1: 1, 2222: 1536}   # world map id -> UiMapID shown on the map (Durotar / Maldraxxus)
R = 14                    # half size of the marked area in yards
BUILD = 69933


def at(key): return L[key]


# quest -> list of (objectiveIndex (-1 = quest level), objectiveId or 0, location key)
PLAN = {
    9330011: [(-1, 0, 'tome')],                                           # Zal'thira: go to the cave and read the Tome
    9330012: [(-1, 0, 'vexthal_corpse'), (0, 93300012, 'vexthal_corpse')],  # loot Vex'thal and equip the set
    9330013: [(-1, 0, 'anima_crystal'), (0, 93300013, 'korthaz')],         # touch the crystal, take the portal, reach Korthaz
    9330014: [(-1, 0, 'archon'), (0, 93300014, 'archon')],                 # report to the Archon
    9330015: [(-1, 0, 'korthaz'), (0, 93300015, 'korthaz')],               # placeholder: back to Korthaz
}
w = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
for q, rows in PLAN.items():
    w.execute('delete from quest_poi where QuestID=%s', (q,)); w.execute('delete from quest_poi_points where QuestID=%s', (q,))
    for idx, (obj, oid, key) in enumerate(rows):
        p = at(key); m = int(p['map'])
        w.execute('insert into quest_poi (QuestID,BlobIndex,Idx1,ObjectiveIndex,QuestObjectiveID,QuestObjectID,MapID,UiMapID,Priority,Flags,WorldEffectID,PlayerConditionID,NavigationPlayerConditionID,SpawnTrackingID,AlwaysAllowMergingBlobs,VerifiedBuild) '
                  'values (%s,0,%s,%s,%s,0,%s,%s,0,1,0,0,0,0,0,%s)', (q, idx, obj, oid, m, UI[m], BUILD))
        x, y, z = float(p['x']), float(p['y']), float(p['z'])
        for n, (dx, dy) in enumerate(((-R, -R), (R, -R), (R, R), (-R, R))):
            w.execute('insert into quest_poi_points (QuestID,Idx1,Idx2,X,Y,Z,VerifiedBuild) values (%s,%s,%s,%s,%s,%s,%s)', (q, idx, n, int(x + dx), int(y + dy), int(z), BUILD))
    print(q, len(rows), 'blobs')
