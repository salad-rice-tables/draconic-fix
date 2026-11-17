import os
"""Level-appropriateness audit of the CoA necromancer spell list.

For every spell in COA_SCHEDULE.necromancer it prints the direct-damage value that this core
would compute at the level the spell is learned (SpellEffectInfo::CalcValue: base + level x
EffectRealPointsPerLevel, no spell power) and flags values that are far above a retail-like
budget for that level.

usage: python tools/coa_dmg_audit.py [class_key]
"""
import re
import sys

import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
SCHEDULE = r'C:\WowServer\Custom\lua\coa_class_schedule.lua'
KEY = sys.argv[1] if len(sys.argv) > 1 else 'necromancer'

text = open(SCHEDULE, 'r', encoding='utf-8').read()
m = re.search(r'\n\s*' + re.escape(KEY) + r'\s*=\s*\{(.*?)\n\s*\},', text, re.S)
if not m:
    print('schedule block not found'); sys.exit(1)
rows = [(int(a), b, int(c)) for a, b, c in re.findall(r'\{\s*(\d{5,9})\s*,\s*"([^"]*)"\s*,\s*(\d+)\s*\}', m.group(1))]
print('%d spells in %s\n' % (len(rows), KEY))

db = pymysql.connect(**DB)
cur = db.cursor()
out = []
for sid, name, lvl in rows:
    cur.execute('SELECT BaseLevel,SpellLevel,MaxLevel FROM hotfixes.spell_levels WHERE SpellID=%s', (sid,))
    r = cur.fetchone()
    if not r:
        out.append((0, lvl, sid, name, 'no spell_levels row', 0))
        continue
    bl, sl, ml = int(r[0]), int(r[1]), int(r[2])
    cur.execute('SELECT Effect,EffectBasePoints,EffectRealPointsPerLevel,EffectBonusCoefficient,Coefficient,EffectMiscValue1 '
                'FROM hotfixes.spell_effect WHERE SpellID=%s ORDER BY EffectIndex', (sid,))
    eff = cur.fetchall()
    dmg = 0
    for e in eff:
        if int(e[0]) != 2:      # SPELL_EFFECT_SCHOOL_DAMAGE
            continue
        base = float(e[1]) + 1
        per = float(e[2] or 0)
        eff_lvl = min(max(lvl, max(bl, sl)), ml) if ml > 0 else max(lvl, max(bl, sl))
        dmg += base + max(0, eff_lvl - max(bl, sl)) * per
    coef = max([float(e[3] or 0) for e in eff] or [0])
    out.append((dmg, lvl, sid, name, 'b/s/m %d/%d/%d' % (bl, sl, ml), coef))

out.sort(key=lambda x: -x[0])
print('%-8s %-5s %-30s %-22s %-9s %s' % ('dmg', 'lvl', 'name', 'levels', 'coef', 'flag'))
for dmg, lvl, sid, name, info, coef in out:
    if dmg <= 0:
        continue
    budget = 12 + 9 * lvl          # very loose retail-like direct-hit budget for a nuke
    flag = 'HIGH' if dmg > budget else ''
    print('%-8.0f %-5d %-30s %-22s %-9.3f %s' % (dmg, lvl, name[:30], info, coef, flag))
db.close()
