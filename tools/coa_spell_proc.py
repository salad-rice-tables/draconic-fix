import os
"""Imports CoA's spell_proc rows (base db_world/spell_proc.sql + every pending_db_world *proc*.sql of the CoA repo) into world.spell_proc
for the +7000000 spells that exist in our data. Columns are mapped by name (AzerothCore -> Midnight: SpellFamilyMask3/ProcFlags2/DisableEffectsMask = 0).
Last definition of a spell wins (base first, then pending in file order). Own rows (1400011, 7805015) are kept.
usage: python coa_spell_proc.py [dry]      undo: python coa_spell_proc.py undo   (restores world.coa_spell_proc_bak)"""
import json, re, sys, urllib.request
import pymysql

RAW = 'https://raw.githubusercontent.com/Conquest-of-AzerothCore/azerothcore-wotlk-coa/master/'
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True); q = c.cursor()
if len(sys.argv) > 1 and sys.argv[1] == 'undo':
    q.execute("delete from spell_proc where SpellId between 7000000 and 7999999"); q.execute("insert into spell_proc select * from coa_spell_proc_bak"); print('restored'); sys.exit()
tree = json.load(open(r'C:\WowServer\Custom\data\coa\repo_tree.json'))
paths = [x['path'] if isinstance(x, dict) else x for x in (tree if isinstance(tree, list) else tree.get('tree', tree))]
files = ['data/sql/base/db_world/spell_proc.sql'] + sorted(p for p in paths if p.startswith('data/sql/updates/pending_db_world/') and 'proc' in p.lower() and p.endswith('.sql'))
COLS = ['SpellId', 'SchoolMask', 'SpellFamilyName', 'SpellFamilyMask0', 'SpellFamilyMask1', 'SpellFamilyMask2', 'SpellFamilyMask3', 'ProcFlags', 'ProcFlags2', 'SpellTypeMask',
        'SpellPhaseMask', 'HitMask', 'AttributesMask', 'DisableEffectsMask', 'ProcsPerMinute', 'Chance', 'Cooldown', 'Charges']
ins = re.compile(r"INSERT\s+INTO\s+`?spell_proc`?\s*\(([^)]*)\)\s*VALUES(.*?);", re.I | re.S)
rows = {}


def tuples(body):
    out, depth, cur, inq = [], 0, '', False
    for ch in body:
        if ch == "'" : inq = not inq
        if not inq and ch == '(':
            depth += 1
            if depth == 1: cur = ''; continue
        if not inq and ch == ')':
            depth -= 1
            if depth == 0: out.append(cur); continue
        if depth >= 1: cur += ch
    return out


for f in files:
    try:
        text = urllib.request.urlopen(RAW + f, timeout=60).read().decode('utf-8', 'ignore')
    except Exception as e:
        print('skip', f, e); continue
    text = re.sub(r'--[^\n]*', '', text)
    for m in ins.finditer(text):
        cols = [x.strip(' `') for x in m.group(1).split(',')]
        for t in tuples(m.group(2)):
            vals = [v.strip() for v in re.split(r",(?=(?:[^']*'[^']*')*[^']*$)", t)]
            if len(vals) != len(cols): continue
            d = dict(zip(cols, vals))
            try: sid = abs(int(d['SpellId']))
            except Exception: continue
            rows[sid] = {k: d.get(k, '0') for k in COLS[1:]} | {'SpellId': sid}
print('parsed spells:', len(rows), 'from', len(files), 'files')
q.execute("create table if not exists coa_spell_proc_bak like spell_proc")
q.execute("delete from coa_spell_proc_bak"); q.execute("insert into coa_spell_proc_bak select * from spell_proc where SpellId between 7000000 and 7999999")
new = 0
for sid, d in sorted(rows.items()):
    ns = 7000000 + sid
    q.execute("select 1 from hotfixes.spell_name where ID=%s", (ns,))
    if not q.fetchone() or ns in (7805015, 7805011): continue
    def f(k, cast=int):
        try: return cast(float(d.get(k) or 0))
        except Exception: return 0
    vals = (ns, f('SchoolMask'), f('SpellFamilyName'), f('SpellFamilyMask0'), f('SpellFamilyMask1'), f('SpellFamilyMask2'), 0, f('ProcFlags'), 0, f('SpellTypeMask'),
            f('SpellPhaseMask'), f('HitMask'), f('AttributesMask'), 0, float(d.get('ProcsPerMinute') or 0), float(d.get('Chance') or 0), f('Cooldown'), f('Charges'))
    if len(sys.argv) > 1 and sys.argv[1] == 'dry': new += 1; continue
    q.execute("replace into spell_proc (SpellId,SchoolMask,SpellFamilyName,SpellFamilyMask0,SpellFamilyMask1,SpellFamilyMask2,SpellFamilyMask3,ProcFlags,ProcFlags2,SpellTypeMask,SpellPhaseMask,HitMask,AttributesMask,DisableEffectsMask,ProcsPerMinute,Chance,Cooldown,Charges) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)", vals)
    new += 1
print('imported rows for existing CoA spells:', new)
