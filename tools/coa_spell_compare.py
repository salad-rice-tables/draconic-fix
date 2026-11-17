import os
"""Compare the original Conquest of Azeroth spell data with what this server has in hotfixes.

The CoA source export lives in Custom/data/coa/all_spells_raw.json (one record per spell id).
Server values come from hotfixes.spell_levels / hotfixes.spell_effect.

usage: python tools/coa_spell_compare.py 7501969 7501970 ...      (ids)
       python tools/coa_spell_compare.py --schedule necromancer   (every spell of a CoA class)
"""
import json
import re
import sys

import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
SRC = r'C:\WowServer\Custom\data\coa\all_spells_raw.json'
SCHEDULE = r'C:\WowServer\Custom\lua\coa_class_schedule.lua'


def load_source():
    with open(SRC, 'r', encoding='utf-8') as f:
        return json.load(f)


def schedule_ids(key):
    text = open(SCHEDULE, 'r', encoding='utf-8').read()
    m = re.search(r'COA_SCHEDULE\s*\.\s*' + key + r'\s*=\s*\{(.*?)\n\}', text, re.S)
    if not m:
        m = re.search(key + r'\s*=\s*\{(.*?)\n\}', text, re.S)
    if not m:
        return []
    return [int(x) for x in re.findall(r'\{\s*(\d{5,9})\s*,', m.group(1))]


def effects_of(rec):
    e = rec.get('effects')
    if isinstance(e, str):
        try:
            e = json.loads(e)
        except Exception:
            return []
    out = []
    for x in (e or []):
        out.append({
            'effect': int(x.get('effect', 0) or 0),
            'base': float(x.get('base_points', 0) or 0),
            'coef': float(x.get('coefficient', 0) or 0),
            'die': float(x.get('die_sides', 0) or 0),
            'per_level': float(x.get('real_points_per_level', 0) or 0),
            'aura': int(x.get('apply_aura_name', 0) or 0),
            'misc': int(x.get('effect_misc_value', 0) or 0),
        })
    return out


def main():
    if '--schedule' in sys.argv:
        ids = schedule_ids(sys.argv[sys.argv.index('--schedule') + 1])
    else:
        ids = [int(x) for x in sys.argv[1:] if x.isdigit()]
    if not ids:
        print(__doc__)
        return
    src = load_source()
    db = pymysql.connect(**DB)
    cur = db.cursor()
    fmt = '%-9s %-30s %-16s %-16s %s'
    print(fmt % ('spell', 'name', 'server lvl b/s/m', 'coa lvl b/s/m', 'effect base/cpl  server vs coa'))
    bad = 0
    for sid in ids:
        rec = src.get(str(sid))
        cur.execute('SELECT Name FROM hotfixes.spell_name WHERE ID=%s', (sid,))
        r = cur.fetchone()
        name = (r[0] if r else '?')[:30]
        cur.execute('SELECT BaseLevel,SpellLevel,MaxLevel FROM hotfixes.spell_levels WHERE SpellID=%s', (sid,))
        srv = cur.fetchone()
        if not srv:
            cur.execute('SELECT 1 FROM hotfixes.spell_name WHERE ID=%s', (sid,))
            if not cur.fetchone():
                print(fmt % (sid, name, 'MISSING', '-', 'not in hotfixes'))
                bad += 1
                continue
            srv = (0, 0, 0)
        cur.execute('SELECT EffectIndex,Effect,EffectBasePoints,Coefficient,EffectRealPointsPerLevel '
                    'FROM hotfixes.spell_effect WHERE SpellID=%s ORDER BY EffectIndex', (sid,))
        se = cur.fetchall()
        if not rec:
            print(fmt % (sid, name, '%s/%s/%s' % srv, 'NO SOURCE', 'server effects %s' % (se,)))
            continue
        coa_lvl = '%s/%s/%s' % (rec.get('base_level'), rec.get('spell_level'), rec.get('max_level'))
        ce = effects_of(rec)
        srv_dmg = [(e[1], e[2], round(float(e[4] or 0), 3)) for e in se if e[1] in (2, 3, 6, 9)]
        coa_dmg = [(e['effect'], int(e['base']), round(e['per_level'], 3)) for e in ce if e['effect'] in (2, 3, 6, 9)]
        diff = ''
        if len(srv_dmg) != len(coa_dmg):
            diff = ' COUNT %d vs %d' % (len(srv_dmg), len(coa_dmg))
        else:
            for a, b in zip(srv_dmg, coa_dmg):
                if abs(a[1] - b[1]) > 0.5 or abs(a[2] - b[2]) > 0.01:
                    diff = ' DIFF'
        if diff:
            bad += 1
        print(fmt % (sid, name, '%s/%s/%s' % srv, coa_lvl, '%s vs %s%s' % (srv_dmg, coa_dmg, diff)))
    print('\n%d of %d differ or are missing' % (bad, len(ids)))
    db.close()


main()
