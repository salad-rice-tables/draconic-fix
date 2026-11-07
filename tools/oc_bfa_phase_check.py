# Read-only BfA phase-mapping check. Finds phases used in BfA maps that retail
# phase_area does not associate with any area of the same continent/map.
import csv, collections, sys
import pymysql

AREA_CSV = r'C:\WowServer\Custom\data\wago\AreaTable.csv'
cont = {0: 0}
parent = {0: 0}
name = {0: '(none)'}
with open(AREA_CSV, encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        try: i = int(r['ID'])
        except ValueError: continue
        cont[i] = int(r['ContinentID'] or 0)
        parent[i] = int(r['ParentAreaID'] or 0)
        name[i] = (r.get('AreaName_lang') or r.get('ZoneName') or '').strip()

W = pymysql.connect(host='127.0.0.1', user='root', password='admin', database='world', charset='utf8mb4')
wc = W.cursor()
def q(sql):
    wc.execute(sql); return wc.fetchall()

phase_areas = collections.defaultdict(set)
for aid, pid in q('SELECT AreaId,PhaseId FROM phase_area'):
    phase_areas[pid].add(aid)
pname = dict(q('SELECT ID,Name FROM phase_name'))

BFA_MAPS = {1642:'Zandalar', 1643:'Kul Tiras', 1718:'Nazjatar', 2268:'Mechagon'}
# map -> acceptable continents for phase_area areas
MAP_CONT = {1642:{1642}, 1643:{1643}, 1718:{1718}, 2268:{1643}}

def phase_map_status(mp, pid):
    if not pid: return 'PHASE0'
    areas = phase_areas.get(pid)
    if not areas: return 'NO_PHASE_AREA'
    ok = MAP_CONT[mp]
    if any(cont.get(a,0) in ok for a in areas):
        return 'SAME_MAP'
    return 'OTHER_MAP'

for table in ('creature','gameobject'):
    rows = q(f'SELECT id,map,zoneId,areaId,PhaseId,COUNT(*) FROM {table} WHERE map IN (1642,1643,1718,2268) AND PhaseId<>0 GROUP BY id,map,zoneId,areaId,PhaseId')
    stats = collections.defaultdict(collections.Counter)
    byphase = collections.defaultdict(lambda: collections.Counter())
    examples = collections.defaultdict(list)
    for eid, mp, zone, area, pid, n in rows:
        st = phase_map_status(mp, pid)
        stats[mp][st] += n
        byphase[pid][st] += n
        byphase[pid]['total'] += n
        if st != 'SAME_MAP' and len(examples[pid]) < 5:
            examples[pid].append((mp, eid, zone, area, n, st))
    print('\n==', table, 'phase status by map ==')
    for mp in sorted(stats):
        print(mp, BFA_MAPS[mp], dict(stats[mp]))
    print('top problem phases')
    for pid, c in sorted(byphase.items(), key=lambda kv: -(kv[1]['NO_PHASE_AREA']+kv[1]['OTHER_MAP']))[:40]:
        if c['NO_PHASE_AREA'] or c['OTHER_MAP']:
            print(pid, pname.get(pid,''), dict(c), 'examples', examples[pid])
