import os
"""The client only downloads hotfix records of a push id it has not applied yet. After editing converted-spell rows in place, run this to
re-announce them under a NEW push id (default 1952000+n), so clients with a warm cache receive the changed rows.
usage: python coa_hotfix_bump.py [push_id]"""
import sys, pymysql
PUSH = int(sys.argv[1]) if len(sys.argv) > 1 else 1952000
BUILD = 69933
T = {'spell_misc': (3322146344, 'ID', 'SpellID'), 'spell_effect': (4030871717, 'ID', 'SpellID'), 'spell_x_spell_visual': (666345498, 'ID', 'SpellID'),
     'spell_categories': (3689412649, 'ID', 'SpellID'), 'spell_cooldowns': (4193483863, 'ID', 'SpellID'), 'spell_power': (2712461791, 'ID', 'SpellID'),
     'spell_name': (1187407512, 'ID', 'ID'), 'spell': (3776013982, 'ID', 'ID')}
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
n = 0
for t, (h, idc, sc) in T.items():
    c.execute(f'select {idc} from {t} where {sc}>=7000000 and {sc}<8000000' if t not in ('spell_name', 'spell') else f'select ID from {t} where ID>=7000000 and ID<8000000')
    ids = [r[0] for r in c.fetchall()]
    c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3980000000 + n + i, h, rid, BUILD) for i, rid in enumerate(ids)])
    n += len(ids)
print('re-announced', n, 'records under push', PUSH)
