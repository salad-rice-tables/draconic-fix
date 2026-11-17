import os
"""Necromancer spell visuals = retail necrotic visuals picked by the user (Bwonsamdi / Midnight necrotic spells), chosen per spell type.
summon -> 1299466 summoning (big animates / rituals -> 1263616 ritual), teleport -> 1296477, channel -> 1270780,
ground-target damage -> 1306114 upheaval, damage around the caster -> 1283703 slam (instant: 1281422 explosion), single-target damage -> 1261326 necrotic bolt,
self buff -> 327823 boon, friendly / heal -> 1260746 necrotic vigor, anything else -> 286671 Seal of Bwonsamdi.
Existing spell_x_spell_visual rows of a spell are updated in place; spells without one get a new row (push 1951800).
usage: python coa_necro_visuals.py"""
import json, re, pymysql
ROOT = r'C:\WowServer\Custom'
PUSH, BUILD, H, ROW0 = 1951800, 69933, 666345498, 72900000 + 80000
V = {'frost': 64829, 'fire': 182402, 'arcane': 68226, 'summon': 184527, 'ritual': 171792, 'teleport': 183079, 'channel': 173772, 'ground': 187215, 'slam': 177495, 'explosion': 176346,
     'bolt': 145064, 'boon': 97677, 'vigor': 170811, 'seal': 84258}
SCHOOL_VIS = {16: 'frost', 4: 'fire', 64: 'arcane'}
BIG = ('Tomb King', 'Plaguefather', 'Frost Wyrm', 'Summoning Ritual', 'Colossus')
sp = json.load(open(ROOT + r'\data\coa\all_spells_raw.json', encoding='utf-8'))
sched = open(ROOT + r'\lua\coa_class_schedule.lua', encoding='utf-8').read()
blk = sched[sched.index('  necromancer = {'):]
nec = {int(x) for x in re.findall(r'\{(\d+), "', blk[:blk.index('  },')])}
nec |= {7000000 + r for ns in json.load(open(ROOT + r'\data\coa\ca_trees.json'))['classes']['necromancer'].values() for n in ns for r in n['ranks']}


def kind(s):
    effs = json.loads(s['effects']) if isinstance(s['effects'], str) else s['effects']
    ids = {e['id'] for e in effs}
    a = [int(x or 0) for x in s['attributes'].strip('{}').split(',')] + [0] * 8
    if a[0] & 0x40:
        return None   # passive: no visual
    tgt = {(e['implicit_target_a'], e['implicit_target_b']) for e in effs}
    cast = int(s['cast_time_ms'] or 0)
    if 28 in ids:
        return 'ritual' if any(b in s['name'] for b in BIG) else 'summon'
    if ids & {5, 29, 145, 252}:
        return 'teleport'
    if a[1] & 0x44:
        return 'channel'
    dmg = bool(ids & {2, 9}) or any(e['id'] == 6 and e['aura'] in (3, 89, 53) for e in effs)
    school = int(s['school_mask'] or 1)
    if school in SCHOOL_VIS and (dmg or cast):   # frost / fire / arcane damage keeps its own element and projectile (Lichfrost = frost bolt-like)
        return SCHOOL_VIS[school]
    if dmg:
        if any(ta == 87 or tb in (16, 28) and ta not in (1, 22) for ta, tb in tgt):
            return 'ground'
        if any(ta in (1, 22) and tb in (15, 16, 30) for ta, tb in tgt):
            return 'slam' if cast else 'explosion'
        return 'bolt'
    if any(e['id'] == 6 for e in effs) and all(ta in (1, 0) for ta, tb in tgt):
        return 'boon'
    if ids & {10, 3}:
        return 'vigor'
    return 'seal'


plan = {}
for k, s in sp.items():
    new = 7000000 + int(k)
    if new in nec:
        t = kind(s)
        if t:
            plan[new] = V[t]
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
c.execute('delete from spell_x_spell_visual where ID>=%s and ID<%s', (ROW0, ROW0 + 5000))
c.execute('select ID, SpellID from spell_x_spell_visual where SpellID in (%s)' % ','.join(map(str, plan)))
have = {}
for rid, sid in c.fetchall():
    have.setdefault(sid, []).append(rid)
for sid, rids in have.items():
    c.execute('update spell_x_spell_visual set SpellVisualID=%s where ID in (%s)' % (plan[sid], ','.join(map(str, rids))))
todo = [s for s in plan if s not in have]
rows = [(ROW0 + n, 0, plan[s], 1, 0, 0, 0, 0, 0, 0, 0, 0, s, BUILD) for n, s in enumerate(todo)]
c.executemany('insert into spell_x_spell_visual (ID,DifficultyID,SpellVisualID,Probability,Flags,Priority,SpellIconFileID,ActiveIconFileID,ViewerUnitConditionID,ViewerPlayerConditionID,CasterUnitConditionID,CasterPlayerConditionID,SpellID,VerifiedBuild) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)', rows)
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3970000000 + i, H, r[0], BUILD) for i, r in enumerate(rows)])
from collections import Counter
# projectile visuals only travel when the spell has a missile speed (converted spells have 0 = instant hit)
MISSILE = {V['frost'], V['fire'], V['arcane'], V['bolt']}
fast = [sid for sid, vis in plan.items() if vis in MISSILE]
if fast:
    c.execute('update spell_misc set Speed=28 where Speed=0 and SpellID in (%s)' % ','.join(map(str, fast)))
    print('missile speed set on', c.rowcount, 'spells')
print('spells', len(plan), 'updated', len(have), 'added', len(rows), Counter({v: k for k, v in V.items()}[x] for x in plan.values()))
