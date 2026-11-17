"""Spellbook: remove the Wildcard hero pool (skill_line_ability rows 9600000..9621391, ClassMask 0) and list each slot class's CoA spells under its class skill line.
push 1950800. Backup: hotfixes.skill_line_ability_bak_20261106. Undo: sql/20261106_coa_spellbook_undo.sql (restore from backup)."""
import json, os, re, pymysql
ROOT = r'C:\WowServer\Custom'
PUSH, BUILD, H = 1950800, 69933, 4282664694
LINE = {1: 840, 2: 800, 3: 795, 4: 921, 5: 804, 6: 796, 7: 924, 8: 904, 9: 849, 10: 829, 11: 798, 12: 1848, 13: 2810}
db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)
c = db.cursor()
slots = json.load(open(os.path.join(ROOT, 'data', 'coa', 'coa_class_slots.json'), encoding='utf-8'))
sched = open(os.path.join(ROOT, 'lua', 'coa_class_schedule.lua'), encoding='utf-8').read()
c.execute('create table if not exists skill_line_ability_bak_20261106 as select * from skill_line_ability where ID between 9600000 and 9621391 and ClassMask=0')
c.execute('select ID from skill_line_ability where ID between 9600000 and 9621391 and ClassMask=0')
old = [r[0] for r in c.fetchall()]
c.execute('delete from hotfix_data where TableHash=%s and (RecordId between 9600000 and 9621391 or Id=%s)', (H, PUSH))
c.execute('delete from skill_line_ability where ID between 9600000 and 9621391 and ClassMask=0')
c.execute('delete from skill_line_ability where ID between 96300000 and 96399999')
rows = []
rid = 96300000
for s, v in slots.items():
    s = int(s)
    m = re.search(r'^  ' + v['coa'] + r' = \{\n(.*?)^  \},', sched, re.M | re.S)
    ids = [int(i) for i, _, _ in re.findall(r'\{(\d+), "(.*?)", (\d+)\}', m.group(1))] + [1488101, 1488102]
    for sp in ids:
        rows.append((rid, LINE[s], sp, 1 << (s - 1)))
        rid += 1
c.executemany('insert into skill_line_ability (AbilityVerb,AbilityAllVerb,ID,SkillLine,Spell,MinSkillLineRank,ClassMask,SupercedesSpell,AcquireMethod,TrivialSkillLineRankHigh,TrivialSkillLineRankLow,Flags,NumSkillUps,UniqueBit,TradeSkillCategoryID,SkillupSkillLineID,RaceMask1,RaceMask2,VerifiedBuild) '
              'values ("","",%s,%s,%s,1,%s,0,0,0,0,0,0,0,0,0,0,0,%s)', [(a, b, d, e, BUILD) for a, b, d, e in rows])
u = 3800000000
hot = [(r[0], 1) for r in rows]   # pool rows were hotfix-only: removing them = no row (Status 2 on a non-DB2 record crashes the core); client: clear Cache
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,%s,%s)', [(PUSH, u + n, H, r, st, BUILD) for n, (r, st) in enumerate(hot)])
open(os.path.join(ROOT, 'sql', '20261106_coa_spellbook_undo.sql'), 'w').write(
    "DELETE FROM hotfixes.hotfix_data WHERE Id=1950800;\nDELETE FROM hotfixes.skill_line_ability WHERE ID BETWEEN 96300000 AND 96399999;\n"
    "INSERT INTO hotfixes.skill_line_ability SELECT * FROM hotfixes.skill_line_ability_bak_20261106;\n-- (old hotfix_data rows of the pool were removed; re-push with Status 1 if needed)\n")
print('removed', len(old), 'added', len(rows))
