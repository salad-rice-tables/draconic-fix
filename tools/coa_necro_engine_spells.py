"""Every spell id referenced by CoA's necromancer engine (data/coa_src/AscensionNecromancer*.cpp/.h) that is not converted yet
-> closure (trigger spells) from the exiles spell table -> data/coa/engine_spells_raw.json (+ icons json) for coa_spell_to_hotfix.py."""
import csv, glob, gzip, json, os, re
csv.field_size_limit(10 ** 9)
ROOT = r'C:\WowServer\Custom'
D = os.path.join(ROOT, 'data')
have = json.load(open(os.path.join(D, 'coa', 'all_spells_raw.json'), encoding='utf-8'))
ids = set()
for f in glob.glob(os.path.join(D, 'coa_src', 'AscensionNecromancer*')):
    ids |= {int(x) for x in re.findall(r'\b(\d{6})\b', open(f, encoding='utf-8', errors='replace').read())}
allsp = {}
with gzip.open(os.path.join(D, 'ascension-data', 'exiles', 'tables', 'spell.csv.gz'), 'rt', encoding='utf-8') as f:
    r = csv.reader(f); hdr = next(r)
    for row in r:
        allsp[int(row[0])] = row
hi = {k: i for i, k in enumerate(hdr)}
out, q = {}, [i for i in ids if str(i) not in have]
while q:
    i = q.pop()
    if str(i) in have or str(i) in out or i not in allsp:
        continue
    out[str(i)] = dict(zip(hdr, allsp[i]))
    try:
        for e in json.loads(allsp[i][hi['effects']]):
            if e.get('trigger_spell'):
                q.append(e['trigger_spell'])
    except Exception:
        pass
icons = json.load(open(os.path.join(D, 'coa', 'dbc_spell_icons.json')))
json.dump(out, open(os.path.join(D, 'coa', 'engine_spells_raw.json'), 'w', encoding='utf-8'), ensure_ascii=False)
json.dump({k: {'fileDataID': icons.get(k, 136243)} for k in out}, open(os.path.join(D, 'coa', 'engine_icons.json'), 'w'))
print('referenced', len(ids), 'new spells', len(out))
