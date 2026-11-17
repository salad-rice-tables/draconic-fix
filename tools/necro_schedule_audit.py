"""Which spells of our Necromancer learn schedule belong to a DIFFERENT class (CoA trainer lists / class docs)?"""
import glob, json, os, re

tr = json.load(open(r'C:\WowServer\Custom\data\coa\class_trainer_spells.json'))
sched = {int(i) - 7000000: (n, int(l)) for i, n, l in re.findall(r'\{(7\d{6}), "([^"]+)", (\d+)\}', open(r'C:\WowServer\Custom\lua\coa_necromancer_schedule.lua', encoding='utf-8').read())}
other = {}
for cls, v in tr.items():
    if cls == '23':
        continue
    for x in v:
        other.setdefault(x['spell'], []).append(cls)
print('in another class trainer:', [(k, sched[k][0], other[k]) for k in sched if k in other])
docs = {os.path.basename(f)[:-3]: open(f, encoding='utf-8').read().lower() for f in glob.glob(r'C:\WowServer\Custom\data\coa\*.md')}
mine = docs['necromancer']
out = []
for k, (n, l) in sched.items():
    nm = n.lower()
    if nm.startswith('spell #') or nm == 'nyi':
        continue
    others = [c for c, t in docs.items() if c not in ('necromancer', 'necromancer-completion', 'ascension-talents') and nm in t]
    if nm not in mine and others:
        out.append((n, l, others[:4]))
print('name only in OTHER class docs:', out)
