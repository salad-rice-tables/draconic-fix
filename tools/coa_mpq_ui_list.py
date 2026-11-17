import json, collections
d = json.load(open(r'C:\WowServer\Custom\data\coa\client_mpq_ui_files.json'))
bs = chr(92)
for k, v in d.items():
    if not v:
        continue
    c = collections.Counter(bs.join(x.split(bs)[:3]) for x in v)
    print(k, len(v), dict(c.most_common(8)))
print()
for x in d['patch-B.MPQ'][:60]:
    print(x)
