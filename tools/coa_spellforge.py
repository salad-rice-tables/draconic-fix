import os
"""Spell forge: turns the retail visual-only / half-working spells (from the design list) into real class spells (hotfix push 1953400, ids 7991001+).
Each spec clones a working template (Lichfrost = bolt with missile), swaps in the visual of the retail source spell and sets damage / aura / cast time / range.
Balance: every damage coefficient is multiplied by BAL (one knob, retail-like pacing; Necrobolt = 0.87 SP for a 1.5 s cast).
Learned through COA_FORGED (lua/coa_forged.lua, read by lua/coa_extras.lua) at the listed level. Re-runnable.   usage: python tools/coa_spellforge.py"""
import csv, pymysql
csv.field_size_limit(10 ** 9)
W = r'C:\WowServer\Custom\data\wago'
PUSH, BUILD = 1953400, 69933
BAL = 0.7
H = {'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344, 'spell_effect': 4030871717, 'spell_power': 2712461791,
     'spell_categories': 3689412649, 'spell_cooldowns': 4193483863, 'spell_levels': 501138918, 'spell_class_options': 680438657, 'spell_x_spell_visual': 666345498}
ROW0 = 75000100
TEMPLATE = 7501969   # Lichfrost: damage + missile (effect 0), 2 more effect slots
SCHOOL = {'physical': 1, 'holy': 2, 'fire': 4, 'nature': 8, 'frost': 16, 'shadow': 32, 'arcane': 64}


def idx_for(fn, col, want):
    r = csv.reader(open(f'{W}\\{fn}', encoding='utf-8')); hdr = next(r); ci = hdr.index(col)
    for row in r:
        if row and row[ci] == str(want): return int(row[0])
    raise SystemExit(f'{fn}: no row with {col}={want}')


def range_idx(yd):
    if yd == 0: return 1
    r = csv.reader(open(f'{W}\\SpellRange.csv', encoding='utf-8')); hdr = next(r)
    for row in r:
        if row and row[hdr.index('RangeMax_1')] == str(yd) and row[hdr.index('Flags')] == '0': return int(row[0])
    raise SystemExit(f'no hostile range {yd}')


def visual_of(src):
    r = csv.reader(open(f'{W}\\SpellXSpellVisual.csv', encoding='utf-8')); hdr = next(r)
    si, vi = hdr.index('SpellID'), hdr.index('SpellVisualID')
    return [int(row[vi]) for row in r if row and row[si] == str(src)]


# id, name, desc, cls (CoA class key), lvl (learn level), src (retail spell whose visual is used), school, cast (ms), rng (yd), cd (ms),
# kind: bolt | aoe | channel | channel_aoe | root | stun | slow_aoe | shield ; coef = SP coefficient (before BAL); dur (ms); radius (yd); speed (0 = no missile)
SPECS = [
 dict(id=7991001, name='Bone Spear', cls='necromancer', lvl=10, src=342675, school='physical', cast=2500, rng=40, kind='bolt', coef=1.45, speed=28,
      desc='Hurls a massive spear of bone at the target, dealing physical damage.'),
 dict(id=7991002, name='Bone Splinter', cls='necromancer', lvl=4, src=256880, school='physical', cast=1500, rng=35, kind='bolt', coef=0.8, speed=28,
      desc='Launches a splinter of bone that deals physical damage.'),
 dict(id=7991003, name='Necrotic Chains', cls='necromancer', lvl=8, src=323075, school='shadow', cast=0, rng=30, kind='stun', dur=4000, cd=30000,
      desc='Chains an enemy in necrotic energy, stunning it for 4 sec. Cannot be used on friendly targets.'),
 dict(id=7991004, name='Bone Chilling Fear', cls='necromancer', lvl=12, src=268886, school='frost', cast=0, rng=0, kind='slow_aoe', dur=8000, radius=10, cd=20000,
      desc='Chills the bones of all enemies within 10 yards, slowing their movement speed by 40% for 8 sec.'),
 dict(id=7991005, name='Necrotic Rush', cls='necromancer', lvl=14, src=1296392, school='shadow', cast=0, rng=0, kind='aoe', coef=0.9, radius=8, cd=12000,
      desc='A rush of necrotic energy erupts around you, dealing shadow damage to all enemies within 8 yards.'),
 dict(id=7991006, name='Grasping Hands', cls='necromancer', lvl=18, src=1255590, school='shadow', cast=0, rng=30, kind='root', dur=6000, cd=25000,
      desc='Necrotic hands burst from the ground and root the target for 6 sec.'),
 dict(id=7991007, name='Bone Spikes', cls='necromancer', lvl=16, src=1305702, school='physical', cast=0, rng=0, kind='channel_aoe', coef=2.0, dur=5000, radius=8, cd=30000,
      desc='Channel for 5 sec, raising bone spikes around you that damage all enemies within 8 yards.'),
 dict(id=7991008, name='Malefic Grasp', cls='necromancer', lvl=22, src=1261153, school='shadow', cast=0, rng=30, kind='channel', coef=1.8, dur=6000, cd=20000,
      desc='Channel dark energy into the target for 6 sec, dealing shadow damage over time.'),
 dict(id=7991009, name='Bone Carapace', cls='necromancer', lvl=20, src=457872, school='physical', cast=0, rng=0, kind='shield', dur=30000, cd=45000, absorb=400,
      desc='Encases you in bone, absorbing damage for 30 sec.'),
 dict(id=7991101, name='Necromantic Spawn', cls=None, lvl=1, src=1300856, school='shadow', cast=0, rng=0, kind='visual',
      desc='Visual: necromantic energy when a minion is raised (cast on the minion by the server).'),
]

c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
out, ctr = [], [0]


def cols(t):
    c.execute(f'show columns from {t}'); return [r[0] for r in c.fetchall()]


for s in SPECS:
    new, k = s['id'], s['kind']
    vis = visual_of(s['src'])
    if not vis:
        print('no visual for', s['src'], s['name']); vis = [64829]
    misc = {'SchoolMask': SCHOOL[s['school']], 'CastingTimeIndex': idx_for('SpellCastTimes.csv', 'Base', s['cast']) if s.get('cast') else 1,
            'Speed': s.get('speed', 0), 'DurationIndex': idx_for('SpellDuration.csv', 'Duration', s['dur']) if s.get('dur') else 0,
            'RangeIndex': range_idx(s.get('rng', 0))}
    coef = round(s.get('coef', 0) * BAL, 4)
    tgt = 6   # TARGET_UNIT_TARGET_ENEMY: enemies only
    off = {'Effect': 0, 'EffectAura': 0, 'EffectBasePoints': 0, 'EffectBonusCoefficient': 0, 'EffectTriggerSpell': 0, 'EffectAuraPeriod': 0}
    eff = {0: dict(off), 1: dict(off), 2: dict(off)}
    per = round(coef / (s['dur'] / 1000), 4) if s.get('dur') and coef else 0
    if k == 'visual':
        pass   # no effects: pure visual kit
    elif k == 'bolt':
        eff[0].update(Effect=2, EffectBasePoints=round(30 * BAL), EffectBonusCoefficient=coef, ImplicitTarget1=tgt)
    elif k == 'aoe':
        eff[0].update(Effect=2, EffectBasePoints=round(20 * BAL), EffectBonusCoefficient=coef, ImplicitTarget1=22, ImplicitTarget2=15)
    elif k == 'channel_aoe':
        eff[0].update(Effect=6, EffectAura=3, EffectAuraPeriod=1000, EffectBasePoints=round(10 * BAL), EffectBonusCoefficient=per, ImplicitTarget1=22, ImplicitTarget2=15)
    elif k == 'channel':
        eff[0].update(Effect=6, EffectAura=3, EffectAuraPeriod=1000, EffectBasePoints=round(10 * BAL), EffectBonusCoefficient=per, ImplicitTarget1=tgt)
    elif k == 'stun':
        eff[0].update(Effect=6, EffectAura=12, ImplicitTarget1=tgt)
    elif k == 'root':
        eff[0].update(Effect=6, EffectAura=26, ImplicitTarget1=tgt)
    elif k == 'slow_aoe':
        eff[0].update(Effect=6, EffectAura=33, EffectBasePoints=-40, ImplicitTarget1=22, ImplicitTarget2=15)
    elif k == 'shield':
        eff[0].update(Effect=6, EffectAura=69, EffectBasePoints=s['absorb'], EffectMiscValue1=127, ImplicitTarget1=1)
    if 'radius' in s:
        eff[0]['EffectRadiusIndex1'] = idx_for('SpellRadius.csv', 'Radius', s['radius'])
    if k in ('channel', 'channel_aoe'):
        misc['Attributes2'] = 0x44   # channeled
    for t in H:
        key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
        c.execute(f'delete from {t} where {key}=%s', (new,))
        cs = cols(t)
        c.execute(f'select * from {t} where {key}=%s', (TEMPLATE,))
        for row in c.fetchall():
            d = dict(zip(cs, row))
            if t in ('spell_name', 'spell'): d['ID'] = new
            else:
                ctr[0] += 1; d['ID'] = ROW0 + ctr[0]; d['SpellID'] = new
            if t == 'spell_name': d['Name'] = s['name']
            if t == 'spell': d['Description'] = s['desc']; d['AuraDescription'] = s['desc']
            if t == 'spell_misc': d.update(misc)
            if t == 'spell_effect' and d['EffectIndex'] in eff: d.update(eff[d['EffectIndex']])
            if t == 'spell_cooldowns': d['RecoveryTime'] = s.get('cd', 0); d['CategoryRecoveryTime'] = 0
            if t == 'spell_x_spell_visual': d['SpellVisualID'] = vis[0]
            c.execute(f'insert into {t} (' + ','.join(f'`{kk}`' for kk in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
            out.append((H[t], d['ID']))
    print(new, s['name'], 'visual', vis[0])
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3991000000 + i, h, rid, BUILD) for i, (h, rid) in enumerate(out)])
by = {}
for s in SPECS:
    if s['cls']: by.setdefault(s['cls'], []).append(s)
lua = ['-- generated by tools/coa_spellforge.py', 'COA_FORGED = {']
for cls, ss in by.items():
    lua.append(f'  {cls} = {{')
    for s in ss: lua.append('    {%d, %d, "%s"},' % (s['id'], s['lvl'], s['name']))
    lua.append('  },')
lua.append('}')
open(r'C:\WowServer\Custom\lua\coa_forged.lua', 'w', encoding='utf-8').write('\n'.join(lua) + '\n')
print('rows', len(out))
