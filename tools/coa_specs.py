"""Rename the retail specializations of the 13 slot classes to the CoA specs (names/descriptions from data/coa/<class>.md). push 1950900."""
import csv, json, os, re, pymysql
ROOT = r'C:\WowServer\Custom'
PUSH, BUILD, H = 1950900, 69933, 2685374048
DOC = {'demonhunter': 'demon-hunter', 'knightofxoroth': 'knight-of-xoroth', 'sonofarugal': 'son-of-arugal', 'suncleric': 'sun-cleric', 'witchdoctor': 'witch-doctor', 'witchhunter': 'witch-hunter'}
slots = json.load(open(os.path.join(ROOT, 'data', 'coa', 'coa_class_slots.json'), encoding='utf-8'))
rows = list(csv.DictReader(open(os.path.join(ROOT, 'data', 'wago', 'ChrSpecialization.csv'), encoding='utf-8')))
db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)
c = db.cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
hot = []
for s, v in slots.items():
    key = v['coa']
    t = open(os.path.join(ROOT, 'data', 'coa', DOC.get(key, key) + '.md'), encoding='utf-8').read()
    names = re.findall(r'^\| (\w[\w \'-]*?) \| .*? \| \d+ \| (.*?) \|$', t.split('## Specializations')[1].split('## Export')[0], re.M)
    names = [n for n in names if n[0] != 'Spec']
    per = {n: re.search(r'^- \*\*' + re.escape(n) + r'\*\* — (.*)$', t, re.M) for n, _ in names}
    specs = sorted([r for r in rows if r['ClassID'] == s and int(r['OrderIndex']) < 3], key=lambda r: int(r['OrderIndex']))
    for r, (n, spell) in zip(specs, names):
        m = per[n]
        desc = (m.group(1) if m else spell).strip()
        c.execute('select count(*) from chr_specialization where ID=%s', (r['ID'],))
        if c.fetchone()[0]:
            c.execute('update chr_specialization set Name=%s, FemaleName=%s, Description=%s, VerifiedBuild=%s where ID=%s', (n, n, desc, BUILD, r['ID']))
        else:
            c.execute('insert into chr_specialization (Name, FemaleName, Description, ID, ClassID, OrderIndex, PetTalentType, Role, Flags, SpellIconFileID, PrimaryStatPriority, AnimReplacements, MasterySpellID1, MasterySpellID2, VerifiedBuild) '
                      'values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)', (n, n, desc, r['ID'], s, r['OrderIndex'], r['PetTalentType'], r['Role'], r['Flags'], r['SpellIconFileID'], r['PrimaryStatPriority'], r['AnimReplacements'], r['MasterySpellID_0'], r['MasterySpellID_1'], BUILD))
        hot.append(int(r['ID']))
        print(s, r['ID'], n)
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3900000000 + i, H, rid, BUILD) for i, rid in enumerate(hot)])
