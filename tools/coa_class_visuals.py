import os
"""Give EVERY CoA spell that has no spell visual a retail Midnight visual, chosen per spell type (same classifier as coa_necro_visuals.py, which keeps its own necrotic palette).
CoA's own visuals are WotLK models from its MPQ and do not exist in the Midnight client, so this is an approximation, not a port.
summon -> 184527, ritual -> 171792, teleport (Spirit Walk) -> 182455, channel (Drain Life) -> 74855, ground-target damage -> 187215, damage around the caster -> Thunderstorm 39844 / explosion 176346,
single-target damage: frost 64829 / fire 182402 / arcane 68226 / anything else Shadow Bolt 77979, self buff -> Bloodlust 182708, heal / friendly -> Healing Wave 64380, anything else -> Hex 182696.
Physical (school 1) damage gets no projectile (weapon swings animate themselves); passives get nothing.
usage: python coa_class_visuals.py [--dry]      undo: python coa_class_visuals.py --undo     (needs a worldserver restart + client Cache\\ClientDBCache deleted)"""
import json, sys, pymysql
from collections import Counter
ROOT = r'C:\WowServer\Custom'
PUSH, BUILD, H, ROW0 = 1951801, 69933, 666345498, 76000000
V = {'frost': 64829, 'fire': 182402, 'arcane': 68226, 'summon': 184527, 'ritual': 171792, 'teleport': 182455, 'channel': 74855, 'ground': 187215, 'slam': 39844,
     'explosion': 176346, 'bolt': 77979, 'boon': 182708, 'vigor': 64380, 'seal': 182696}
SCHOOL_VIS = {16: 'frost', 4: 'fire', 64: 'arcane'}
BIG = ('Tomb King', 'Plaguefather', 'Frost Wyrm', 'Summoning Ritual', 'Colossus')

def kind(s):
    effs = json.loads(s['effects']) if isinstance(s['effects'], str) else s['effects']
    ids = {e['id'] for e in effs}
    a = [int(x or 0) for x in s['attributes'].strip('{}').split(',')] + [0] * 8
    if a[0] & 0x40: return None   # passive
    tgt = {(e['implicit_target_a'], e['implicit_target_b']) for e in effs}
    cast = int(s['cast_time_ms'] or 0)
    if 28 in ids: return 'ritual' if any(b in s['name'] for b in BIG) else 'summon'
    if ids & {5, 29, 145, 252}: return 'teleport'
    if a[1] & 0x44: return 'channel'
    dmg = bool(ids & {2, 9}) or any(e['id'] == 6 and e['aura'] in (3, 89, 53) for e in effs)
    school = int(s['school_mask'] or 1)
    if school in SCHOOL_VIS and (dmg or cast): return SCHOOL_VIS[school]
    if dmg:
        if school == 1 and not cast: return None   # melee / weapon hit
        if any(ta == 87 or tb in (16, 28) and ta not in (1, 22) for ta, tb in tgt): return 'ground'
        if any(ta in (1, 22) and tb in (15, 16, 30) for ta, tb in tgt): return 'slam' if cast else 'explosion'
        return 'bolt'
    if any(e['id'] == 6 for e in effs) and all(ta in (1, 0) for ta, tb in tgt): return 'boon'
    if ids & {10, 3}: return 'vigor'
    return 'seal'

c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
if '--undo' in sys.argv:
    c.execute('delete from spell_x_spell_visual where ID>=%s and ID<%s', (ROW0, ROW0 + 100000)); c.execute('delete from hotfix_data where Id=%s', (PUSH,))
    print('undone'); sys.exit()
sp = json.load(open(ROOT + r'\data\coa\all_spells_raw.json', encoding='utf-8'))
c.execute('select ID from spell_name where ID between 7000000 and 7999999'); exist = {r[0] for r in c.fetchall()}
c.execute('select distinct SpellID from spell_x_spell_visual where SpellID between 7000000 and 7999999 and ID<%s', (ROW0,)); have = {r[0] for r in c.fetchall()}
plan = {}
for k, s in sp.items():
    new = 7000000 + int(k)
    if new in exist and new not in have:
        t = kind(s)
        if t: plan[new] = t
print('spells to get a visual:', len(plan), dict(Counter(plan.values())))
if '--dry' in sys.argv: sys.exit()
c.execute('delete from hotfix_data where Id=%s', (PUSH,)); c.execute('delete from spell_x_spell_visual where ID>=%s and ID<%s', (ROW0, ROW0 + 100000))
rows = [(ROW0 + n, 0, V[t], 1, 0, 0, 0, 0, 0, 0, 0, 0, s, BUILD) for n, (s, t) in enumerate(plan.items())]
c.executemany('insert into spell_x_spell_visual (ID,DifficultyID,SpellVisualID,Probability,Flags,Priority,SpellIconFileID,ActiveIconFileID,ViewerUnitConditionID,ViewerPlayerConditionID,CasterUnitConditionID,CasterPlayerConditionID,SpellID,VerifiedBuild) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)', rows)
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3971000000 + i, H, r[0], BUILD) for i, r in enumerate(rows)])
# projectile visuals only travel when the spell has a missile speed (converted spells have 0 = instant hit)
fast = [s for s, t in plan.items() if t in ('frost', 'fire', 'arcane', 'bolt')]
for i in range(0, len(fast), 500):
    c.execute('update spell_misc set Speed=28 where Speed=0 and SpellID in (%s)' % ','.join(map(str, fast[i:i + 500])))
print('visuals added', len(rows))
