"""Exact CoA Character Advancement catalog from the CoA client DBCs (data/coa_dbc/CA_*.dbc, extracted by coa_ca_dbc_extract.py).
Layout from the CoA core loader (AscensionCoATalentData.cpp): CharacterAdvancement fields 0 id, 1 type, 2-4 required entries, 5-9 rank spells, 14 AE cost, 15 TE cost,
26 level, 29 group, 32 class type, 33 tab, 38/39 tab AE/TE investment (gate), 47 name, 73 flags, 153 node type. Essence.dbc: 1 level, 2 class, 7 AE, 8 TE (cumulative budget).
Positions come from the class docs' reference table (by name). Output: data/coa/ca_trees.json"""
import json, os, re, struct

D = r'C:\WowServer\Custom\data\coa_dbc'


POSB = {}


def load(name):
    d = open(os.path.join(D, 'CA_' + name + '.dbc'), 'rb').read()
    m, rc, fc, rs, ss = struct.unpack('<4sIIII', d[:20])
    sb = 20 + rc * rs

    def s(off):
        if not (0 < off < ss):
            return ''
        e = d.index(b'\0', sb + off)
        return d[sb + off:e].decode('utf-8', 'replace')
    rows = [struct.unpack_from('<%dI' % fc, d, 20 + i * rs) for i in range(rc)]
    if name == 'characteradvancement':   # PositionX / PositionY are floats packed at byte offsets 398 / 402 of the record (column, row)
        for i in range(rc):
            o = 20 + i * rs
            POSB[rows[i][0]] = (struct.unpack_from('<f', d, o + 398)[0], struct.unpack_from('<f', d, o + 402)[0])
    return rows, s


classes, cs = load('chrclasses')
ctypes, _ = load('characteradvancementclasstypes')
ttypes, ts = load('characteradvancementtabtypes')
specs, ss_ = load('chrspecs')
adv, a_s = load('characteradvancement')
ess, _ = load('characteradvancementessence')

class_token = {r[0]: cs(r[55]).upper() for r in classes}
class_of_type = {r[0]: r[2] for r in ctypes if r[4] and 12 <= r[2] <= 32}
tab_name = {r[0]: ts(r[1]) for r in ttypes}
SHARED = 87
budget = {}
for r in ess:
    if r[2] in range(12, 33) and r[1] and not any(r[3:7]):
        budget.setdefault(r[2], {})[r[1]] = (r[7], r[8])

KEY = {12: 'barbarian', 13: 'witchdoctor', 14: 'demonhunter', 15: 'witchhunter', 16: 'stormbringer', 17: 'knightofxoroth', 18: 'guardian', 19: 'monk', 20: 'sonofarugal',
       21: 'ranger', 22: 'chronomancer', 23: 'necromancer', 24: 'pyromancer', 25: 'cultist', 26: 'starcaller', 27: 'suncleric', 28: 'tinker', 29: 'venomancer',
       30: 'reaper', 31: 'primalist', 32: 'runemaster'}
out = {}
for r in adv:
    cid = class_of_type.get(r[32])
    if not cid:
        continue
    tab = r[33]
    tname = 'Class' if tab == SHARED else tab_name.get(tab, str(tab)).title()
    node = {'id': r[0], 'name': a_s(r[47]), 'type': a_s(r[1]), 'nodeType': a_s(r[153]), 'req': [x for x in r[2:5] if x], 'ranks': [x for x in r[5:10] if x], 'ae': r[14], 'te': r[15],
            'level': r[26], 'group': r[29], 'px': POSB[r[0]][0], 'py': POSB[r[0]][1], 'gateAE': r[38], 'gateTE': r[39], 'flags': r[73]}
    out.setdefault(KEY[cid], {}).setdefault(tname, []).append(node)
res = {'classes': {}, 'budget': {str(k): {str(l): v for l, v in b.items()} for k, b in budget.items()}}
for k, tabs in out.items():
    res['classes'][k] = {t: ns for t, ns in tabs.items()}
json.dump(res, open(r'C:\WowServer\Custom\data\coa\ca_trees.json', 'w'))
n = res['classes']['necromancer']
print({t: len(v) for t, v in n.items()})
print({l: budget[23][l] for l in (10, 11, 30, 60, 80) if l in budget[23]})
for x in n.get('Class', [])[:5]:
    print(x)
