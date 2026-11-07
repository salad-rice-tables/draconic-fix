# BfA retail-parity spawn/phasing audit (read-only).
# Focus: Zuldazar + all Battle for Azeroth outdoor zones.
# Usage: python oc_bfa_audit.py [--out C:\path\prefix]
import csv, collections, json, os, re, sys
import pymysql

OUT = r'C:\WowServer\Custom\docs\bfa_audit_20261107'
for i, a in enumerate(sys.argv[1:]):
    if a == '--out' and i + 1 < len(sys.argv) - 1:
        OUT = sys.argv[i + 2]

# BfA zones (AreaTable IDs) and their continent maps.
BFA_ZONES = {
    8499: 'Zuldazar',
    8500: 'Nazmir',
    8501: "Vol'dun",
    8567: 'Tiragarde Sound',
    8721: 'Drustvar',
    9042: 'Stormsong Valley',
    10290: 'Mechagon',
    10052: 'Nazjatar',
}
BFA_MAPS = {
    1642: 'Zandalar',
    1643: 'Kul Tiras',
    1718: 'Nazjatar',
    2268: 'Mechagon',
}
BFA_ZONE_SET = set(BFA_ZONES)
MAP_CONT = {1642: {1642}, 1643: {1643}, 1718: {1718}, 2268: {2268}}

# ----------------------------- area table ---------------------------------
AREA_CSV = r'C:\WowServer\Custom\data\wago\AreaTable.csv'
parent = {0: 0}
aname = {0: '(none)'}
acont = {0: 0}
with open(AREA_CSV, encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        try:
            i = int(r['ID'])
        except ValueError:
            continue
        parent[i] = int(r['ParentAreaID'] or 0)
        acont[i] = int(r['ContinentID'] or 0)
        nm = (r.get('AreaName_lang') or r.get('ZoneName') or '').strip()
        aname[i] = nm

def ancestors(a):
    out, seen = [], set()
    while a and a not in seen:
        out.append(a)
        seen.add(a)
        a = parent.get(a, 0)
    out.append(0)
    return out

# ----------------------------- db -----------------------------------------
def conn(db):
    return pymysql.connect(host='127.0.0.1', user='root', password='admin', db=db,
                           charset='utf8mb4', autocommit=True)

W = conn('world')
wc = W.cursor()

def q(cur, sql, args=None):
    cur.execute(sql, args)
    return cur.fetchall()

def inlist(cur, sql, ids):
    ids = [int(x) for x in ids if x]
    out = []
    for i in range(0, len(ids), 800):
        ch = ids[i:i + 800]
        out += q(cur, sql % ','.join(str(x) for x in ch))
    return out

# phase_area: PhaseId -> set(AreaId)
phase_area = collections.defaultdict(set)
for aid, pid in q(wc, 'SELECT AreaId, PhaseId FROM phase_area'):
    phase_area[pid].add(aid)
phase_name = {pid: (nm or '') for pid, nm in q(wc, 'SELECT ID, Name FROM phase_name')}
phase_flags = {}
try:
    for pid, fl in q(wc, 'SELECT ID, Flags FROM hotfixes.phase'):
        phase_flags[pid] = fl
except Exception:
    pass

def phase_status(area, zone, phase, mapid=0):
    if not phase:
        return 'PHASE0'
    mapped = phase_area.get(phase)
    if not mapped:
        return 'ORPHAN_ALL'
    cand = set(ancestors(area)) | set(ancestors(zone))
    if mapped & cand:
        return 'OK'
    # A spawn's DB zone can be 0; the player's actual area still comes from
    # the map. If retail maps the phase anywhere on this continent/map, the
    # phase is reachable while the player stands near the spawn.
    ok_cont = MAP_CONT.get(mapid, set())
    if any(acont.get(a, 0) in ok_cont for a in mapped):
        return 'OK_MAP'
    return 'OTHER_MAP'

# ----------------------------- spawn summaries ----------------------------
def spawn_rows(table):
    idcol = 'id'
    rows = q(wc, f'SELECT guid,{idcol},map,zoneId,areaId,PhaseId,PhaseGroup,position_x,position_y,position_z FROM {table}')
    return rows

summary = {}
for table in ('creature', 'gameobject'):
    rows = spawn_rows(table)
    bymap = collections.defaultdict(lambda: collections.Counter())
    byphase = collections.defaultdict(lambda: collections.Counter())
    zone0 = collections.Counter()
    for guid, eid, mp, zone, area, ph, pg, x, y, z in rows:
        if mp not in BFA_MAPS:
            continue
        st = phase_status(area, zone, ph, mp)
        bymap[mp]['total'] += 1
        bymap[mp][st] += 1
        if ph:
            byphase[ph][st] += 1
            byphase[ph]['total'] += 1
        if not zone:
            zone0['total'] += 1
            if ph:
                zone0['phased'] += 1
            else:
                zone0['phase0'] += 1
    summary[table] = {'bymap': {str(k): dict(v) for k, v in bymap.items()},
                      'byphase': byphase, 'zone0': dict(zone0)}

# missing templates in BfA maps
missing_tpl = {}
for table, tpl in (('creature', 'creature_template'), ('gameobject', 'gameobject_template')):
    col = 'entry'
    rows = q(wc, f'''SELECT s.map, s.id, COUNT(*) n FROM {table} s
                     LEFT JOIN {tpl} t ON t.{col}=s.id
                     WHERE s.map IN (1642,1643,1718,2268) AND t.{col} IS NULL
                     GROUP BY s.map,s.id ORDER BY n DESC''')
    missing_tpl[table] = [[int(m), int(i), int(n)] for m, i, n in rows]

# ----------------------------- quest audit --------------------------------
QUESTS = [r[0] for r in q(wc, 'SELECT ID FROM quest_template WHERE Expansion=7 AND QuestSortID IN (%s) ORDER BY ID'
                            % ','.join(str(x) for x in BFA_ZONE_SET))]
QS = set(QUESTS)

qtpl = {}
for r in inlist(wc, 'SELECT ID,LogTitle,QuestSortID,Expansion,Flags,QuestType FROM quest_template WHERE ID IN (%s)', QS):
    qtpl[r[0]] = r
addon = {}
for r in inlist(wc, 'SELECT ID,PrevQuestID,NextQuestID,ExclusiveGroup FROM quest_template_addon WHERE ID IN (%s)', QS):
    addon[r[0]] = r

def links(table):
    d = collections.defaultdict(set)
    for r in inlist(wc, 'SELECT quest,id FROM %s WHERE quest IN (%%s)' % table, QS):
        d[r[0]].add(r[1])
    return d
stc, enc = links('creature_queststarter'), links('creature_questender')
stg, eng = links('gameobject_queststarter'), links('gameobject_questender')

obj = collections.defaultdict(list)
for r in inlist(wc, 'SELECT QuestID,Type,ObjectID,Amount FROM quest_objectives WHERE QuestID IN (%s) ORDER BY QuestID,`Order`,ID', QS):
    obj[r[0]].append(r)

# involved ids
CIDS, GIDS = set(), set()
for qid in QS:
    CIDS |= stc.get(qid, set()) | enc.get(qid, set())
    GIDS |= stg.get(qid, set()) | eng.get(qid, set())
    for _, typ, oid, _amt in obj.get(qid, []):
        if typ == 0:
            CIDS.add(oid)
        elif typ == 2:
            GIDS.add(oid)

cspawn = collections.defaultdict(list)
for r in inlist(wc, 'SELECT id,map,zoneId,areaId,PhaseId,position_x,position_y,position_z FROM creature WHERE id IN (%s)', CIDS):
    cspawn[r[0]].append(r[1:])
gspawn = collections.defaultdict(list)
for r in inlist(wc, 'SELECT id,map,zoneId,areaId,PhaseId,position_x,position_y,position_z FROM gameobject WHERE id IN (%s)', GIDS):
    gspawn[r[0]].append(r[1:])

ctpl = {r[0]: r for r in inlist(wc, 'SELECT entry,name,npcflag,RequiredExpansion,ScriptName FROM creature_template WHERE entry IN (%s)', CIDS)}
gtpl = {r[0]: r for r in inlist(wc, 'SELECT entry,name,type FROM gameobject_template WHERE entry IN (%s)', GIDS)}

# credit sources (template kill credit, SmartAI, Lua numeric mentions)
credit_tpl = set()
for r in q(wc, 'SELECT KillCredit1,KillCredit2 FROM creature_template WHERE KillCredit1<>0 OR KillCredit2<>0'):
    credit_tpl |= {int(x) for x in r if x}
try:
    credit_sai = {int(r[0]) for r in q(wc, 'SELECT DISTINCT action_param1 FROM smart_scripts WHERE action_type=33 AND action_param1>0')}
except Exception:
    credit_sai = set()
lua_nums = set()
for root in (r'C:\WowServer\Custom\lua', r'C:\WowServer\MyServer\69587Precompiled\69587Precompiled\bin\RelWithDebInfo\lua_scripts'):
    if not os.path.isdir(root):
        continue
    for fn in os.listdir(root):
        if not fn.endswith('.lua'):
            continue
        try:
            txt = open(os.path.join(root, fn), encoding='utf-8', errors='ignore').read()
        except OSError:
            continue
        lua_nums |= {int(x) for x in re.findall(r'(?<![\w.])(\d{4,})(?![\w.])', txt)}

def has_credit(entry):
    return entry in credit_tpl or entry in credit_sai or entry in lua_nums

def isbfa(m):
    return m in BFA_MAPS

def spawn_issue(sp, kind):
    if not sp:
        return None
    bfa = [s for s in sp if isbfa(s[0])]
    if not bfa:
        return ('WARN', f'{kind}_OTHERMAP', 'maps ' + ','.join(str(sorted({s[0] for s in sp}))))
    bad = []
    for m, zone, area, ph, x, y, z in bfa:
        st = phase_status(area, zone, ph, m)
        if st in ('ORPHAN_ALL', 'OTHER_MAP'):
            bad.append((m, ph, st))
    if bad and len(bad) == len(bfa):
        details = ','.join(f'{p}:{s}' for _, p, s in sorted(set(bad)))
        return ('BLOCK', f'{kind}_PHASE_ORPHAN', 'all BfA spawns phased out: ' + details)
    return None

issues = collections.defaultdict(list)
byq = collections.defaultdict(list)
def add(qid, sev, code, detail=''):
    if any(x[1] == code and x[2] == detail for x in byq[qid]):
        return
    byq[qid].append([sev, code, detail])
    issues[code].append((qid, detail))

for qid in QUESTS:
    t = qtpl.get(qid)
    if not t:
        add(qid, 'BLOCK', 'Q_MISSING', 'not in world')
        continue
    if not (t[1] or '').strip():
        add(qid, 'BLOCK', 'NO_TITLE')
    a = addon.get(qid, (qid, 0, 0, 0))
    if a[1] == 999999:
        add(qid, 'BLOCK', 'CHAIN_DISABLED', 'PrevQuestID=999999')
    # starters / enders
    if not (stc.get(qid) or stg.get(qid)) and not a[1]:
        add(qid, 'BLOCK', 'NO_STARTER')
    if not (enc.get(qid) or eng.get(qid)):
        add(qid, 'BLOCK', 'NO_ENDER')
    # objectives
    for _, typ, oid, _amt in obj.get(qid, []):
        if typ == 0 and not cspawn.get(oid) and not has_credit(oid):
            add(qid, 'WARN', 'OBJ_NO_CREDIT', 'creature %d: no spawn, no credit' % oid)
        elif typ == 2 and not gspawn.get(oid) and oid not in lua_nums:
            add(qid, 'BLOCK', 'OBJ_GO_NOSPAWN', 'GO %d: no spawn' % oid)
    # creature links
    for eid in sorted(stc.get(qid, set()) | enc.get(qid, set())):
        sp = cspawn.get(eid, [])
        tpl = ctpl.get(eid)
        if not sp:
            if has_credit(eid) or eid in lua_nums:
                add(qid, 'WARN', 'NPC_LUA_ONLY', 'creature %d no spawn (script/credit)' % eid)
            else:
                add(qid, 'BLOCK', 'NPC_NOSPAWN', 'creature %d no spawn' % eid)
            continue
        if tpl is None:
            add(qid, 'WARN', 'NPC_NOTPL', 'creature %d spawn without template' % eid)
        else:
            if not (tpl[2] & 2):
                add(qid, 'BLOCK', 'NPC_NOQUESTFLAG', 'creature %d npcflag=%d' % (eid, tpl[2]))
        si = spawn_issue(sp, 'NPC')
        if si:
            add(qid, si[0], si[1], 'creature %d ' % eid + si[2])
    # GO links + objectives
    gset = set(stg.get(qid, set())) | set(eng.get(qid, set()))
    for _, typ, oid, _amt in obj.get(qid, []):
        if typ == 2:
            gset.add(oid)
    for eid in sorted(gset):
        sp = gspawn.get(eid, [])
        if not sp:
            if eid in lua_nums:
                add(qid, 'WARN', 'GO_LUA_ONLY', 'GO %d no spawn (Lua)' % eid)
            else:
                add(qid, 'BLOCK', 'GO_NOSPAWN', 'GO %d no spawn' % eid)
            continue
        if gtpl.get(eid) is None:
            add(qid, 'WARN', 'GO_NOTPL', 'GO %d spawn without template' % eid)
        si = spawn_issue(sp, 'GO')
        if si:
            add(qid, si[0], si[1], 'GO %d ' % eid + si[2])

# phase conditions that point at a quest but have no phase_area mapping
for pid, area, v1 in q(wc, '''SELECT SourceGroup,SourceEntry,ConditionValue1 FROM conditions
                              WHERE SourceTypeOrReferenceId=26 AND ConditionTypeOrReference=47'''):
    if v1 in QS and pid not in phase_area:
        add(v1, 'BLOCK', 'QPHASE_ORPHAN', 'phase %d (area %s) no phase_area' % (pid, area))

# ----------------------------- output -------------------------------------
def sev_rank(s):
    return {'BLOCK': 0, 'WARN': 1}.get(s, 2)

rows = []
for qid in QUESTS:
    iss = byq.get(qid, [])
    if not iss:
        continue
    iss.sort(key=lambda x: sev_rank(x[0]))
    rows.append({'quest': qid, 'title': (qtpl.get(qid, (0, ''))[1] or ''),
                 'zone': (qtpl.get(qid, (0, 0, 0))[2]),
                 'block': sum(1 for x in iss if x[0] == 'BLOCK'),
                 'warn': sum(1 for x in iss if x[0] == 'WARN'),
                 'issues': iss})
rows.sort(key=lambda r: (-r['block'], -r['warn'], r['quest']))

data = {
    'generated': '2026-11-07',
    'zones': BFA_ZONES,
    'maps': BFA_MAPS,
    'spawn_summary': summary,
    'missing_templates': missing_tpl,
    'quests_total': len(QUESTS),
    'quests_flagged': len(rows),
    'quests_block': sum(1 for r in rows if r['block']),
    'issue_counts': {k: len(v) for k, v in sorted(issues.items(), key=lambda kv: -len(kv[1]))},
    'phase_orphans': {str(ph): dict(c) for ph, c in sorted(
        ((ph, c) for ph, c in summary.get('creature', {}).get('byphase', {}).items()
         if c.get('ORPHAN_ALL') or c.get('OTHER_MAP')),
        key=lambda kv: -(kv[1].get('ORPHAN_ALL', 0) + kv[1].get('OTHER_MAP', 0)))[:120]},
    'rows': rows,
}
with open(OUT + '.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=1, default=str)

with open(OUT + '.md', 'w', encoding='utf-8') as f:
    f.write('# BfA spawn / phasing audit — %s\n\n' % data['generated'])
    f.write('Read-only audit of `world` against retail `phase_area`/`phase` DB2 and wago AreaTable.\n\n')
    f.write('## Spawn summary\n\n')
    for table, s in summary.items():
        f.write('### %s\n\n' % table)
        f.write('| map | total | phase 0 | OK | OK_MAP | ORPHAN_ALL | OTHER_MAP |\n')
        f.write('|---|---:|---:|---:|---:|---:|---:|\n')
        for mp, c in sorted(s['bymap'].items(), key=lambda kv: int(kv[0])):
            f.write('| %s %s | %d | %d | %d | %d | %d | %d |\n' % (
                mp, BFA_MAPS.get(int(mp), ''), c.get('total', 0), c.get('PHASE0', 0),
                c.get('OK', 0), c.get('OK_MAP', 0), c.get('ORPHAN_ALL', 0), c.get('OTHER_MAP', 0)))
        f.write('\nzoneId=0: total %d, phased %d, phase0 %d\n\n' % (
            s['zone0'].get('total', 0), s['zone0'].get('phased', 0), s['zone0'].get('phase0', 0)))
    f.write('## Top orphan phase IDs (creature)\n\n| phase | name | total | ORPHAN_ALL | OTHER_MAP |\n|---|---|---:|---:|---:|\n')
    for ph, c in list(data['phase_orphans'].items())[:60]:
        f.write('| %s | %s | %d | %d | %d |\n' % (ph, phase_name.get(int(ph), ''), c.get('total', 0),
                c.get('ORPHAN_ALL', 0), c.get('OTHER_MAP', 0)))
    f.write('\n## Missing templates in BfA maps\n\n')
    for table, lst in missing_tpl.items():
        f.write('- %s: %d (map, entry, spawns) rows=%s\n' % (table, len(lst), lst[:20]))
    f.write('\n## Quest audit\n\n')
    f.write('Quests: %d, flagged: %d, with BLOCK: %d\n\n' % (
        data['quests_total'], data['quests_flagged'], data['quests_block']))
    f.write('| code | count |\n|---|---:|\n')
    for code, n in data['issue_counts'].items():
        f.write('| %s | %d |\n' % (code, n))
    f.write('\n## Quests with BLOCK\n\n')
    for r in rows:
        if not r['block']:
            continue
        f.write('### %d %s (zone %s) — BLOCK %d WARN %d\n' % (r['quest'], r['title'], r['zone'], r['block'], r['warn']))
        for sev, code, detail in r['issues']:
            f.write('- %s %s %s\n' % (sev, code, detail))
        f.write('\n')

# CSV of all flagged quests
with open(OUT + '.csv', 'w', encoding='utf-8-sig', newline='') as f:
    wr = csv.writer(f)
    wr.writerow(['quest', 'title', 'zone', 'block', 'warn', 'issues'])
    for r in rows:
        wr.writerow([r['quest'], r['title'], r['zone'], r['block'], r['warn'],
                     '; '.join('%s %s %s' % (s, c, d) for s, c, d in r['issues'])])

print('quests', len(QUESTS), 'flagged', len(rows), 'block quests', data['quests_block'])
print('issue counts')
for k, n in list(data['issue_counts'].items())[:40]:
    print('%-24s %d' % (k, n))
print('spawn summary')
for table, s in summary.items():
    print(table, 'zone0', s['zone0'])
    for mp, c in sorted(s['bymap'].items(), key=lambda kv: int(kv[0])):
        print(' map', mp, BFA_MAPS.get(int(mp), ''), dict(c))
print('wrote', OUT + '.md')
