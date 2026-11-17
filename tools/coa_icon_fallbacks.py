"""Give every CoA custom-art icon a themed retail FileDataID (native action bars cannot show custom art).
Edits data/coa/necromancer_icons.json in place (field fileDataID)."""
import json, os

ROOT = r'C:\WowServer\Custom\data'
lf = {}
for line in open(os.path.join(ROOT, 'listfile', 'community-listfile.csv'), encoding='utf-8', errors='replace'):
    p = line.strip().split(';')
    if len(p) == 2 and p[1].lower().startswith('interface/icons/'):
        lf[os.path.splitext(p[1].split('/')[-1])[0].lower()] = int(p[0])

# keyword (in custom icon name or spell name) -> retail icon names, first existing wins
RULES = [
    (('skeletalmage', 'icemage'), ['spell_shadow_raisedead', 'spell_frost_frostbolt02']),
    (('skeletal', 'skeleton', 'bone', 'skull'), ['spell_shadow_raisedead', 'inv_misc_bone_humanskull_01', 'spell_deathknight_boneshield']),
    (('plague', 'virus', 'toad', 'acid', 'rot', 'blight', 'sickness', 'disease', 'poison'), ['spell_shadow_plaguecloud', 'ability_creature_disease_02', 'spell_nature_corrosivebreath']),
    (('frost', 'ice', 'glacial', 'rime', 'arctic', 'lich', 'winter', 'cold'), ['spell_frost_frostbolt02', 'spell_frost_icestorm', 'spell_deathknight_frostpresence']),
    (('ghoul', 'zombie', 'flesh', 'abomination', 'golem', 'belcher', 'horror'), ['ability_ghoulfrenzy', 'spell_shadow_animatedead', 'spell_deathknight_summongargoyle']),
    (('wyrm', 'wraith', 'spirit', 'ghost', 'phylactery', 'soul'), ['spell_shadow_soulleech_3', 'spell_shadow_deathpact', 'inv_misc_gem_bloodstone_01']),
    (('curse', 'hex', 'doom'), ['spell_shadow_curseofsargeras', 'spell_shadow_curseofachimonde', 'spell_shadow_antishadow']),
    (('death', 'grave', 'undead', 'unholy', 'necro'), ['spell_shadow_deathcoil', 'spell_deathknight_unholypresence', 'spell_shadow_raisedead']),
    (('summon', 'animate', 'raise', 'contract', 'army', 'swarm', 'scarab', 'locust'), ['spell_shadow_animatedead', 'spell_shadow_raisedead']),
    (('dagger', 'sacrific', 'blade', 'knife'), ['inv_weapon_shortblade_05', 'ability_rogue_sinisterstrike']),
    (('drain', 'life', 'transfer', 'tap'), ['spell_shadow_lifedrain02', 'spell_shadow_siphonmana']),
]
DEFAULT = ['spell_shadow_shadowbolt', 'spell_shadow_deathcoil']


def pick(names):
    for n in names:
        if n in lf:
            return lf[n]
    return None


icons = json.load(open(os.path.join(ROOT, 'coa', 'necromancer_icons.json'), encoding='utf-8'))
book = {str(b['id']): b['name'] for b in json.load(open(os.path.join(ROOT, 'coa', 'necromancer_spellbook.json')))}
fixed = 0
for sid, v in icons.items():
    if 'custom' not in v and v['fileDataID'] != 134400:
        continue
    hay = (v['icon'] + ' ' + book.get(sid, '')).lower()
    fd = None
    for keys, names in RULES:
        if any(k in hay for k in keys):
            fd = pick(names)
            if fd:
                break
    v['fileDataID'] = fd or pick(DEFAULT) or 136197
    fixed += 1
raw = json.load(open(os.path.join(ROOT, 'coa', 'necromancer_spells_raw.json'), encoding='utf-8'))
for sid, sp in raw.items():
    if sid not in icons:                       # triggered/helper spells without an icon in the export: pick by spell name
        hay = sp['name'].lower()
        fd = None
        for keys, names in RULES:
            if any(k in hay for k in keys):
                fd = pick(names)
                if fd:
                    break
        icons[sid] = {'icon': '', 'fileDataID': fd or pick(DEFAULT) or 136197}
        fixed += 1
json.dump(icons, open(os.path.join(ROOT, 'coa', 'necromancer_icons.json'), 'w'), indent=1)
print('fallback icons assigned', fixed)
