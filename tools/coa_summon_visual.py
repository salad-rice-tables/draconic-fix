import os
"""Necromancer cast animation: every CoA summon spell (effect 28) gets the retail Raise Dead cast visual (SpellVisual 38762) unless it already has a visual. push 1951800, undo = delete the push + rows.
usage: python coa_summon_visual.py [visual_id]"""
import json, re, sys, pymysql
VIS = int(sys.argv[1]) if len(sys.argv) > 1 else 38762
PUSH, BUILD, H, ROW0 = 1951800, 69933, 666345498, 72900000 + 80000
sp = json.load(open(r'C:\WowServer\Custom\data\coa\all_spells_raw.json', encoding='utf-8'))
ids = []
nec = set()   # every active (non-passive) necromancer spell: class trainer rows + Character Advancement ranks
sched = open(r'C:\WowServer\Custom\lua\coa_class_schedule.lua', encoding='utf-8').read()
blk = sched[sched.index('  necromancer = {'):]
nec |= {int(x) for x in re.findall(r'\{(\d+), "', blk[:blk.index('  },')])}
nec |= {r for ns in json.load(open(r'C:\WowServer\Custom\data\coa\ca_trees.json'))['classes']['necromancer'].values() for n in ns for r in n['ranks']}
for k, s in sp.items():
    effs = json.loads(s['effects']) if isinstance(s['effects'], str) else s['effects']
    new = 7000000 + int(k)
    passive = int((s['attributes'].strip('{}').split(',') + ['0'])[0] or 0) & 0x40
    if any(e['id'] == 28 for e in effs) or (new in nec and not passive and any(e['id'] in (2, 6, 3, 10, 64, 77, 56, 27, 31, 35) for e in effs)):
        ids.append(new)
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
c.execute('delete from spell_x_spell_visual where ID>=%s and ID<%s', (ROW0, ROW0 + 5000))
c.execute('select SpellID from spell_x_spell_visual where SpellID in (%s)' % ','.join(map(str, ids)))
have = {r[0] for r in c.fetchall()}
todo = [i for i in ids if i not in have]
rows = [(ROW0 + n, 0, VIS, 1, 0, 0, 0, 0, 0, 0, 0, 0, sid, BUILD) for n, sid in enumerate(todo)]
c.executemany('insert into spell_x_spell_visual (ID,DifficultyID,SpellVisualID,Probability,Flags,Priority,SpellIconFileID,ActiveIconFileID,ViewerUnitConditionID,ViewerPlayerConditionID,CasterUnitConditionID,CasterPlayerConditionID,SpellID,VerifiedBuild) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)', rows)
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3970000000 + i, H, r[0], BUILD) for i, r in enumerate(rows)])
print('cast-visual spells', len(ids), 'already visual', len(have), 'added', len(rows))
