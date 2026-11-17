import os
"""Extra (non-CoA) necromancer spells, cloned from converted CoA spells and adjusted (push 1953000, ids 7990001+).
 7990001 Necrobolt  - Lichfrost clone, shadow: direct damage + slow + shadow damage over time; necrotic bolt visual (retail 1261326) with a missile.
 7990002 Grasp of the Grave - 3 s stun (the hand from Necrotic Upheaval; cast by lua/coa_extras_spells.lua as a Necrobolt proc).
Re-runnable (deletes and re-inserts its own rows). usage: python coa_custom_spells.py"""
import pymysql
PUSH, BUILD = 1953000, 69933
H = {'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344, 'spell_effect': 4030871717, 'spell_power': 2712461791,
     'spell_categories': 3689412649, 'spell_cooldowns': 4193483863, 'spell_levels': 501138918, 'spell_class_options': 680438657, 'spell_x_spell_visual': 666345498}
ROW0 = 74000000
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
rows_out = []
ctr = [0]


def cols(t):
    c.execute(f'show columns from {t}')
    return [r[0] for r in c.fetchall()]


def clone(src, new, name, desc, change_misc=None, change_eff=None, visual=None):
    for t in H:
        key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
        c.execute(f'delete from {t} where {key}=%s', (new,))
        cs = cols(t)
        c.execute(f'select * from {t} where {key}=%s', (src,))
        for r in c.fetchall():
            d = dict(zip(cs, r))
            if t in ('spell_name', 'spell'):
                d['ID'] = new
            else:
                ctr[0] += 1
                d['ID'] = ROW0 + ctr[0]
                d['SpellID'] = new
            if t == 'spell_name': d['Name'] = name
            if t == 'spell': d['Description'] = desc; d['AuraDescription'] = desc
            if t == 'spell_misc' and change_misc: d.update(change_misc)
            if t == 'spell_effect' and change_eff and d['EffectIndex'] in change_eff: d.update(change_eff[d['EffectIndex']])
            if t == 'spell_x_spell_visual' and visual: d['SpellVisualID'] = visual
            c.execute(f'insert into {t} (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
            rows_out.append((H[t], d['ID']))
        if t == 'spell_effect' and change_eff:   # add effects that the source does not have
            c.execute('select EffectIndex from spell_effect where SpellID=%s', (new,))
            have = {r[0] for r in c.fetchall()}
            for idx, ch in change_eff.items():
                if idx not in have:
                    c.execute('select * from spell_effect where SpellID=%s and EffectIndex=0', (new,))
                    d = dict(zip(cs, c.fetchone())); ctr[0] += 1
                    d.update({'ID': ROW0 + ctr[0], 'EffectIndex': idx, 'EffectTriggerSpell': 0, 'EffectBonusCoefficient': 0}); d.update(ch)
                    c.execute('insert into spell_effect (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
                    rows_out.append((H['spell_effect'], d['ID']))


LICHFROST = 7501969
clone(LICHFROST, 7990001, 'Necrobolt', 'Hurls a bolt of necrotic energy that deals Shadow damage, slows the target by 35% and deals additional Shadow damage over 9 sec. Has a chance to raise a Grasp of the Grave that stuns the target.',
      change_misc={'SchoolMask': 32, 'DurationIndex': 105},   # 105 = 9 sec
      change_eff={1: {'Effect': 6, 'EffectAura': 3, 'EffectAuraPeriod': 3000, 'EffectBasePoints': 12, 'EffectTriggerSpell': 0, 'EffectBonusCoefficient': 0.15, 'ImplicitTarget1': 6}},
      visual=94265)   # necrotic bolt
clone(LICHFROST, 7990002, 'Grasp of the Grave', 'A necrotic hand bursts from the ground and stuns the target for 3 sec.',
      change_misc={'SchoolMask': 32, 'DurationIndex': 27, 'CastingTimeIndex': 1, 'Speed': 0},   # 27 = 3 sec
      change_eff={0: {'Effect': 6, 'EffectAura': 12, 'EffectBasePoints': 0, 'EffectBonusCoefficient': 0}, 1: {'Effect': 0}, 2: {'Effect': 0}},
      visual=187215)   # necrotic upheaval ring + hand
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3990000000 + i, h, rid, BUILD) for i, (h, rid) in enumerate(rows_out)])
print('spell rows', len(rows_out))
