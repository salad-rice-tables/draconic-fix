"""Necromancer initiation walker: plays Q1..Q4 on paper against the live DBs, step by step, and reports PASS/FAIL per step (reports/necro_chain.md).
It checks everything a real player needs at each step: NPC / object exists and is spawned where locations.json says, quest rows + objective + map marker,
gossip text exists, the loot / items exist, the phase rows are cosmetic, both portals exist. Also scans the newest Eluna log for [ni] errors.
usage: python tools/necro_chain_check.py"""
import glob, json, os, pymysql
R = r'C:\WowServer\Custom'
L = json.load(open(f'{R}\\data\\necro_init\\locations.json', encoding='utf-8'))
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world').cursor()
H = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes').cursor()
res = []


def q(cur, sql, a=()):
    cur.execute(sql, a); return cur.fetchall()


def check(step, name, ok, detail=''): res.append((step, name, bool(ok), detail))


def spawn_ok(step, key, table, idcol):
    p = L[key]; rows = q(W, f'select guid,map,position_x,position_y,position_z,PhaseId from {table} where {idcol}=%s and map=%s', (p['entry'], p['map']))
    near = [r for r in rows if abs(r[2] - p['x']) < 3 and abs(r[3] - p['y']) < 3]
    check(step, f'{key}: {table} {p["entry"]} spawned at the configured spot', near, f'{len(rows)} spawn(s) on map {p["map"]}')
    if near and p.get('phase') in ('valley', 'maldraxxus', 'portal'):
        want = L['phase'][p['phase']]
        check(step, f'{key}: spawn is in phase {want}', near[0][5] == want, f'PhaseId={near[0][5]}')


# ---- global
for name, pid in L['phase'].items():
    r = q(H, 'select Flags from phase where ID=%s', (pid,))
    check('0 setup', f'phase {name} ({pid}) exists and is cosmetic (you keep seeing the normal world)', r and r[0][0] & 0x10, f'Flags={r}')
for qid in (9330011, 9330012, 9330013, 9330014):
    check('0 setup', f'quest {qid} row exists', q(W, 'select 1 from quest_template where ID=%s', (qid,)))
    check('0 setup', f'quest {qid} has a map marker (quest_poi)', q(W, 'select 1 from quest_poi where QuestID=%s', (qid,)))
for qid in (9330012, 9330013, 9330014):
    check('0 setup', f'quest {qid} has a scripted objective', q(W, 'select 1 from quest_objectives where QuestID=%s', (qid,)))
# ---- Q1
t = L['zalthira']
spawn_ok('Q1', 'zalthira', 'creature', 'id')
check('Q1', "Zal'thira gives quest 9330011", q(W, 'select 1 from creature_queststarter where id=%s and quest=9330011', (t['entry'],)))
check('Q1', "Zal'thira is friendly + quest giver", q(W, 'select 1 from creature_template where entry=%s and faction=35 and npcflag&2', (t['entry'],)))
spawn_ok('Q1', 'tome', 'gameobject', 'id')
check('Q1', 'Tome of Oblivion template is a goober with a model', q(W, 'select 1 from gameobject_template where entry=322354 and type=10 and displayId>0'))
for k in ('tome_intro', 'tome_locked', 'day1', 'day2', 'day3', 'tome_done'):
    nid = None
    try:
        import re; nid = int(re.search(rf'{k}\s*=\s*(\d+)', open(f'{R}\\lua\\coa_init_texts.lua', encoding='utf-8').read()).group(1))
    except Exception: pass
    check('Q1', f'Tome gossip text "{k}" exists server + client side', nid and q(W, 'select 1 from npc_text where ID=%s', (nid,)) and q(H, 'select 1 from broadcast_text where ID=%s', (nid,)), f'npc_text {nid}')
# ---- Q2
spawn_ok('Q2', 'vexthal_corpse', 'creature', 'id')
loot = {r[0] for r in q(W, 'select Item from creature_loot_template where Entry=161180')}
check('Q2', 'corpse drops all 10 Maldraxxi Initiate items', loot >= set(range(9330101, 9330111)), f'{len(loot)} loot rows')
for iid in range(9330101, 9330111):
    ok = q(H, 'select Flags4 from item_sparse where ID=%s', (iid,))
    check('Q2', f'item {iid} exists and is not cosmetic-flagged', ok and not ok[0][0] & 0x10000 and q(H, 'select 1 from item where ID=%s', (iid,)), str(ok))
# ---- Q3
spawn_ok('Q3', 'anima_crystal', 'gameobject', 'id')
spawn_ok('Q3', 'valley_portal', 'gameobject', 'id')
spawn_ok('Q3', 'maldraxxus_return_portal', 'gameobject', 'id')
check('Q3', 'portal template 376885 is a goober', q(W, 'select 1 from gameobject_template where entry=376885 and type=10'))
spawn_ok('Q3', 'korthaz', 'creature', 'id')
check('Q3', 'Korthaz takes quest 9330013', q(W, 'select 1 from creature_questender where id=163243 and quest=9330013'))
check('Q3', 'Korthaz gives quest 9330014', q(W, 'select 1 from creature_queststarter where id=163243 and quest=9330014'))
check('Q3', 'Korthaz is friendly + quest giver + not feign-death', q(W, 'select 1 from creature_template where entry=163243 and faction=35 and npcflag&2 and unit_flags2&1=0'))
# ---- Q4
spawn_ok('Q4', 'archon', 'creature', 'id')
check('Q4', 'Archon takes quest 9330014', q(W, 'select 1 from creature_questender where id=9330301 and quest=9330014'))
check('Q4', 'Archon is friendly + quest giver', q(W, 'select 1 from creature_template where entry=9330301 and faction=35 and npcflag&2'))
# ---- runtime
logs = sorted(glob.glob(r'C:\WowServer\MyServer\69587Precompiled\69587Precompiled\bin\RelWithDebInfo\Eluna_*.log'), key=os.path.getmtime)
errs = [l for l in open(logs[-1], encoding='utf-8', errors='replace') if 'ERROR' in l and ('coa_init' in l or '[ni]' in l)] if logs else []
check('runtime', 'no [ni] / coa_initiation errors in the newest Eluna log', not errs, errs[-1][:150] if errs else '')

fails = [r for r in res if not r[2]]
os.makedirs(f'{R}\\reports', exist_ok=True)
with open(f'{R}\\reports\\necro_chain.md', 'w', encoding='utf-8') as f:
    f.write(f'# Necromancer chain check\n\n{len(res) - len(fails)}/{len(res)} checks pass\n\n| Step | Check | Result | Detail |\n|---|---|---|---|\n')
    for s, n, ok, d in res: f.write(f'| {s} | {n} | {"PASS" if ok else "**FAIL**"} | {d} |\n')
print(f'{len(res) - len(fails)}/{len(res)} pass')
for s, n, ok, d in fails: print('FAIL', s, n, d)
