"""Generic CoA class build (all class docs in data/coa/*.md) -> raw spell/creature/icon data + per-class learn schedule.
steps: 1) spell closure from exiles spell.csv.gz  2) icons (retail id via listfile, custom art -> BLP + new FileDataID, themed fallback)
       3) schedule lua (castable spells by level per class)  -> then run coa_spell_to_hotfix.py / coa_creatures_to_world.py on the union files.
usage: python coa_all_build.py"""
import csv, glob, gzip, json, os, re, struct
from PIL import Image

ROOT = r'C:\WowServer\Custom'
CLIENT = r'C:\Games\Wow\World of Warcraft\_retail_'
D = os.path.join(ROOT, 'data')
ASSET = os.path.join(D, 'ascension-data', 'repo', 'supplemental', 'exiles-db', 'assets', 'icons')
BASE_ID = 9510000
KEYS = {'demon-hunter': 'demonhunter', 'knight-of-xoroth': 'knightofxoroth', 'son-of-arugal': 'sonofarugal', 'sun-cleric': 'suncleric',
        'witch-doctor': 'witchdoctor', 'witch-hunter': 'witchhunter'}
csv.field_size_limit(10 ** 9)

docs = {}
for f in sorted(glob.glob(os.path.join(D, 'coa', '*.md'))):
    k = os.path.basename(f)[:-3]
    docs[KEYS.get(k, k)] = open(f, encoding='utf-8').read()

# 1) spell closure
book = {k: sorted(set(int(x) for x in re.findall(r'^### .*`(\d+)`$', t, re.M))) for k, t in docs.items()}
# exact CoA trainer data (Books of Ascension): every trainer spell + its rank prerequisite is part of the class
CID_KEY = {12: 'barbarian', 13: 'witchdoctor', 14: 'demonhunter', 15: 'witchhunter', 16: 'stormbringer', 17: 'knightofxoroth', 18: 'guardian', 19: 'monk', 20: 'sonofarugal',
           21: 'ranger', 22: 'chronomancer', 23: 'necromancer', 24: 'pyromancer', 25: 'cultist', 26: 'starcaller', 27: 'suncleric', 28: 'tinker', 29: 'venomancer',
           30: 'reaper', 31: 'primalist', 32: 'runemaster'}
TRAINER = json.load(open(os.path.join(D, 'coa', 'class_trainer_spells.json'), encoding='utf-8'))
for cid, rows_ in TRAINER.items():
    key = CID_KEY[int(cid)]
    extra = {x['spell'] for x in rows_} | {x['req1'] for x in rows_ if x['req1']}
    book[key] = sorted(set(book.get(key, [])) | {i for i in extra if i >= 300000})
# talent / passive rank spells of the exact Character Advancement catalog (data/coa/ca_trees.json) are part of the class too
_CA = json.load(open(os.path.join(D, 'coa', 'ca_trees.json')))['classes']
for key, tabs in _CA.items():
    ids_ = {r for ns in tabs.values() for n in ns for r in n['ranks'] if r >= 300000}
    book[key] = sorted(set(book.get(key, [])) | ids_)
allsp, hdr = {}, None
with gzip.open(os.path.join(D, 'ascension-data', 'exiles', 'tables', 'spell.csv.gz'), 'rt', encoding='utf-8') as f:
    r = csv.reader(f)
    hdr = next(r)
    for row in r:
        allsp[int(row[0])] = row
hi = {k: i for i, k in enumerate(hdr)}


def effs(row):
    try:
        return json.loads(row[hi['effects']])
    except Exception:
        return []


have, q = set(), [i for v in book.values() for i in v]
while q:
    i = q.pop()
    if i in have or i not in allsp:
        continue
    have.add(i)
    for e in effs(allsp[i]):
        if e.get('trigger_spell') and e['trigger_spell'] not in have:
            q.append(e['trigger_spell'])
union = {str(i): dict(zip(hdr, allsp[i])) for i in sorted(have)}
json.dump(union, open(os.path.join(D, 'coa', 'all_spells_raw.json'), 'w', encoding='utf-8'), ensure_ascii=False)
cre = sorted({int(e['misc_value']) for i in have for e in effs(allsp[i]) if e['id'] == 28 and e['misc_value']})
crows = {}
with gzip.open(os.path.join(D, 'ascension-data', 'exiles', 'tables', 'creature.csv.gz'), 'rt', encoding='utf-8') as f:
    r = csv.reader(f)
    ch = next(r)
    for row in r:
        if row and row[0].isdigit() and int(row[0]) in cre:
            crows[row[0]] = dict(zip(ch, row))
json.dump(crows, open(os.path.join(D, 'coa', 'all_creatures_raw.json'), 'w', encoding='utf-8'), ensure_ascii=False)
print('spells', len(union), 'creatures', len(crows), {k: len(v) for k, v in book.items()})

# 2) icons
lf = {}
for line in open(os.path.join(D, 'listfile', 'community-listfile.csv'), encoding='utf-8', errors='replace'):
    p = line.strip().split(';')
    if len(p) == 2 and p[1].lower().startswith('interface/icons/'):
        lf[os.path.splitext(p[1].split('/')[-1])[0].lower()] = int(p[0])
sicon = {}
for t in docs.values():
    for sid, name in re.findall(r'^### .*`(\d+)`\s*\n\s*\n!\[[^\]]*\]\(\.\./assets/icons/([^)]+)\.png\)', t, re.M):
        sicon[sid] = name
RULES = [(('skeletal', 'skeleton', 'bone', 'skull'), ['spell_shadow_raisedead', 'inv_misc_bone_humanskull_01']),
         (('plague', 'virus', 'acid', 'rot', 'blight', 'poison', 'venom', 'toxic'), ['spell_shadow_plaguecloud', 'ability_creature_poison_06']),
         (('frost', 'ice', 'glacial', 'cold', 'winter', 'rime'), ['spell_frost_frostbolt02', 'spell_frost_icestorm']),
         (('fire', 'flame', 'burn', 'ember', 'inferno', 'pyro', 'molten', 'scorch'), ['spell_fire_flamebolt', 'spell_fire_fireball02']),
         (('fel', 'demon', 'chaos'), ['spell_fire_felflamestrike', 'spell_shadow_shadowbolt']),
         (('blood', 'bleed', 'rend', 'hemo'), ['spell_shadow_lifedrain02', 'ability_backstab']),
         (('holy', 'sun', 'light', 'radiant', 'smite'), ['spell_holy_holybolt', 'spell_holy_innerfire']),
         (('storm', 'thunder', 'lightning', 'shock', 'tempest'), ['spell_nature_lightning', 'spell_nature_chainlightning']),
         (('nature', 'thorn', 'vine', 'root', 'wild', 'beast', 'primal'), ['spell_nature_thorns', 'ability_druid_demoralizingroar']),
         (('arcane', 'rune', 'time', 'chrono', 'temporal', 'star'), ['spell_arcane_arcane01', 'spell_arcane_blast']),
         (('shadow', 'curse', 'cult', 'madness', 'void', 'dark'), ['spell_shadow_shadowbolt', 'spell_shadow_curseofsargeras']),
         (('arrow', 'shot', 'trap', 'bow', 'aim'), ['ability_marksmanship', 'ability_hunter_snipershot']),
         (('strike', 'slash', 'cleave', 'rage', 'axe', 'sword', 'blade', 'charge', 'smash'), ['ability_warrior_cleave', 'ability_whirlwind']),
         (('totem', 'spirit', 'ward', 'voodoo', 'hex'), ['spell_nature_earthbindtotem', 'spell_shaman_hex']),
         (('gadget', 'bomb', 'turret', 'tinker', 'rocket', 'mech'), ['inv_gizmo_01', 'inv_misc_enggizmos_27'])]
DEFAULT = ['spell_shadow_shadowbolt', 'inv_misc_questionmark']


def pick(names):
    for n in names:
        if n in lf:
            return lf[n]
    return None


def write_blp(img, path):
    img = img.convert('RGBA').resize((64, 64), Image.LANCZOS)
    px = bytearray()
    for r_, g_, b_, a_ in (img.get_flattened_data() if hasattr(img, 'get_flattened_data') else img.getdata()):
        px += bytes((b_, g_, r_, a_))
    off = 4 + 4 + 4 + 4 + 4 + 64 + 64 + 1024
    h_ = b'BLP2' + struct.pack('<IBBBB', 1, 3, 8, 7, 0) + struct.pack('<II', 64, 64)
    h_ += struct.pack('<16I', off, *([0] * 15)) + struct.pack('<16I', len(px), *([0] * 15)) + bytes(1024)
    open(path, 'wb').write(h_ + bytes(px))


out_dir = os.path.join(CLIENT, 'files', 'Interface', 'Icons', 'coa')
os.makedirs(out_dir, exist_ok=True)
custom, lines, icons = {}, [], {}
for sid, sp in union.items():
    name = sicon.get(sid)
    if name and name.lower() in lf:
        icons[sid] = {'icon': name, 'fileDataID': lf[name.lower()]}
        continue
    if name and os.path.exists(os.path.join(ASSET, name + '.png')):
        low = name.lower()
        if low not in custom:
            custom[low] = BASE_ID + len(custom)
            write_blp(Image.open(os.path.join(ASSET, name + '.png')), os.path.join(out_dir, low + '.blp'))
            lines.append(f'{custom[low]};Interface/Icons/coa/{low}.blp')
        icons[sid] = {'icon': name, 'custom': low, 'fileDataID': custom[low]}
        continue
    hay = ((name or '') + ' ' + sp['name']).lower()
    fd = None
    for keys, names in RULES:
        if any(k in hay for k in keys):
            fd = pick(names)
            if fd:
                break
    icons[sid] = {'icon': name or '', 'fileDataID': fd or pick(DEFAULT) or 136197}
open(os.path.join(CLIENT, 'mappings', 'coa_icons_all.txt'), 'w', newline='\n').write('\n'.join(lines) + '\n')
json.dump(icons, open(os.path.join(D, 'coa', 'all_icons.json'), 'w'), indent=0)
print('custom icon files', len(custom), 'retail/fallback', len(icons) - sum(1 for v in icons.values() if 'custom' in v))

# 3) learn schedule = the exact CoA trainer (Book of Ascension) rows: level per spell (tools: data/coa/class_trainer_spells.json)
lua = ['-- CoA class spells by level = CoA class trainer rows (generated by tools/coa_all_build.py); custom ids = 7000000 + CoA id, retail ids unchanged', 'COA_SCHEDULE = {']
for cid, rows_ in TRAINER.items():
    key = CID_KEY[int(cid)]
    lua.append(f'  {key} = {{')
    for x in sorted(rows_, key=lambda r: (r['level'], r['spell'])):
        i = x['spell']
        nm = (union.get(str(i)) or {}).get('name', str(i)).replace('"', "'")
        lua.append(f'    {{{7000000 + i if i >= 300000 else i}, "{nm}", {x["level"]}}},')
    lua.append('  },')
lua.append('}')
open(os.path.join(ROOT, 'lua', 'coa_class_schedule.lua'), 'w', encoding='utf-8').write(chr(10).join(lua) + chr(10))
print('schedule written', sum(1 for l in lua if l.startswith('    {')), 'spells')
