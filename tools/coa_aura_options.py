import os
"""Imports CoA proc chance / proc charges / max stacks (CoA raw spell data) into hotfixes.spell_aura_options for the +7000000 spells.
Server-side only (no hotfix_data push). Row ids 75500000+ (keep ids small, see memory reference-hotfix-row-ids). undo: python coa_aura_options.py undo"""
import json, sys, pymysql
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True); q = c.cursor()
BASE = 75500000
if len(sys.argv) > 1 and sys.argv[1] == 'undo':
    q.execute("delete from spell_aura_options where ID between %s and %s", (BASE, BASE + 999999)); print('removed', q.rowcount); sys.exit()
d = json.load(open(r'C:\WowServer\Custom\data\coa\all_spells_raw.json'))
q.execute("select SpellID from spell_aura_options where SpellID between 7000000 and 7999999"); have = {r[0] for r in q.fetchall()}
n = 0
for k, v in sorted(d.items(), key=lambda x: int(x[0])):
    pc, ch, st = int(v['proc_chance'] or 0), int(v['proc_charges'] or 0), int(v['stack_amount'] or 0)
    sid = 7000000 + int(k)
    if sid in have or not (0 < pc < 101 or ch or st):
        continue
    q.execute("select 1 from spell_name where ID=%s", (sid,))
    if not q.fetchone():
        continue
    q.execute("insert into spell_aura_options (ID,DifficultyID,CumulativeAura,ProcCategoryRecovery,ProcChance,ProcCharges,SpellProcsPerMinuteID,ProcTypeMask1,ProcTypeMask2,SpellID,VerifiedBuild) values (%s,0,%s,0,%s,%s,0,0,0,%s,69933)",
              (BASE + n, st, min(pc, 100), ch, sid)); n += 1
print('inserted', n)
