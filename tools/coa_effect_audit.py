"""CoA spells -> does the Midnight core actually handle their effects / auras?
Reads the core's handler tables (SpellEffects.cpp, SpellAuraEffects.cpp): an effect/aura mapped to EffectNULL/EffectUnused/HandleNULL/HandleUnused does NOTHING.
Usage: python coa_effect_audit.py [lua name glob, default coa_necro*.lua]   -> logs/coa_effect_audit_<glob>.md
A spell with a dead effect is reported with the effect id; spell_script_names rows (C++ script) are counted as 'script hook' and are NOT dead."""
import glob, os, re, sys, collections, pymysql
ROOT = r'C:\WowServer'
SRC = ROOT + r'\Source\Draconic-Kamilia\src\server\game\Spells'
pat = sys.argv[1] if len(sys.argv) > 1 else 'coa_necro*.lua'

def table(path, prefix, start_pat):
    s = open(path, encoding='utf-8', errors='ignore').read()
    i = re.search(start_pat, s).end()
    body = s[i:s.index('};', i)]
    out = []
    for ln in body.splitlines():
        m = re.match(r'\s*&' + prefix + r'::(\w+)\s*,', ln)
        if m: out.append(m.group(1))
    return out

EFF = table(SRC + r'\SpellEffects.cpp', 'Spell', r'NonDefaultConstructible<SpellEffectHandlerFn>\s+SpellEffectHandlers\[TOTAL_SPELL_EFFECTS\]\s*=\s*\{')
AUR = table(SRC + r'\Auras\SpellAuraEffects.cpp', 'AuraEffect', r'AuraEffectHandler\[TOTAL_AURAS\]\s*=\s*\{')
DEAD = {'EffectNULL', 'EffectUnused', 'HandleNULL', 'HandleUnused'}
print('effect handlers', len(EFF), 'aura handlers', len(AUR))

ids = set()
for f in glob.glob(ROOT + r'\Custom\lua\\' + pat): ids |= {int(x) for x in re.findall(r'\b(7\d{6})\b', open(f, encoding='utf-8', errors='ignore').read())}
H = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes').cursor()
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world').cursor()
W.execute('select distinct spell_id from spell_script_names'); scripted = {r[0] for r in W.fetchall()}
H.execute('select ID, Name from spell_name where ID in (%s)' % ','.join(map(str, ids)) if ids else 'select 1 where 0'); names = dict(H.fetchall())
dead = collections.defaultdict(list); cnt = 0
if ids:
    H.execute('select SpellID, Effect, EffectAura from spell_effect where SpellID in (%s)' % ','.join(map(str, names)))
    for sid, e, a in H.fetchall():
        cnt += 1
        if e < len(EFF) and EFF[e] in DEAD and e != 0: dead[sid].append(f'effect {e}')
        if e == 6 and a < len(AUR) and AUR[a] in DEAD and a != 0: dead[sid].append(f'aura {a}')
        if e >= len(EFF): dead[sid].append(f'effect {e} (beyond core table)')
        if e == 6 and a >= len(AUR): dead[sid].append(f'aura {a} (beyond core table)')
out = os.path.join(ROOT, 'Custom', 'logs', 'coa_effect_audit_' + re.sub(r'\W', '', pat) + '.md')
kinds = collections.Counter(k for v in dead.values() for k in v)
with open(out, 'w', encoding='utf-8') as f:
    f.write(f'# CoA effect audit ({pat})\n{len(names)} spells found in Lua + hotfix DB, {cnt} effects; {len(dead)} spells have a dead effect or aura.\n\n## Dead effect/aura types (count)\n')
    for k, n in kinds.most_common(): f.write(f'- {k}: {n}\n')
    f.write('\n## Spells\n')
    for sid in sorted(dead): f.write(f'- {sid} {names.get(sid)}: {", ".join(sorted(set(dead[sid])))}{"  [has C++ script]" if sid in scripted else ""}\n')
print(len(names), 'spells,', len(dead), 'with dead effects ->', out)
