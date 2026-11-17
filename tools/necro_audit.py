import os
"""Static audit: which Necromancer spells use effects / auras our core does not implement (NULL / unused handlers)."""
import re, json, sys, pymysql, collections
G = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game\Spells'
def table(path, pat):
    out = {}
    for m in re.finditer(pat, open(path, encoding='utf-8', errors='ignore').read()):
        out[int(m.group(2))] = m.group(1)
    return out
eff = table(G + r'\SpellEffects.cpp', r'&Spell::(\w+),\s*//\s*(\d+)\s')
aur = table(G + r'\Auras\SpellAuraEffects.cpp', r'&AuraEffect::(\w+),\s*//\s*(\d+)\s')
NULLS = {'EffectNULL', 'EffectUnused', 'HandleNULL', 'HandleUnused'}
badE = {k for k, v in eff.items() if v in NULLS}; badA = {k for k, v in aur.items() if v in NULLS}
print('effect handlers', len(eff), 'null', len(badE), '| aura handlers', len(aur), 'null', len(badA))
sys.path.insert(0, r'C:\WowServer\Custom\lua')
ids = set()
for f in ('coa_necromancer_schedule.lua', 'coa_necromancer_data.lua'):
    ids |= {int(x) for x in re.findall(r'\{(7\d{6}),', open('C:/WowServer/Custom/lua/' + f, encoding='utf-8').read())}
d = json.load(open(r'C:\WowServer\Custom\data\coa\all_spells_raw.json'))
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes'); q = c.cursor()
rep = []; stat = collections.Counter()
for sid in sorted(ids):
    q.execute("select EffectIndex,Effect,EffectAura from spell_effect where SpellID=%s order by EffectIndex", (sid,)); rows = q.fetchall()
    name = (d.get(str(sid - 7000000)) or {}).get('name', '?')
    if not rows: rep.append((sid, name, 'NO EFFECT ROWS')); stat['norows'] += 1; continue
    prob = []
    for i, e, a in rows:
        if e in badE and e != 0: prob.append('effect %d (%s)' % (e, eff.get(e)))
        if e in (6, 27, 35, 119, 174, 129) and a in badA and a: prob.append('aura %d (%s)' % (a, aur.get(a)))
    if prob: rep.append((sid, name, '; '.join(prob))); stat['bad'] += 1
    else: stat['ok'] += 1
print(dict(stat), 'of', len(ids))
with open(r'C:\WowServer\Custom\logs\necro_audit.txt', 'w', encoding='utf-8') as f:
    for r in rep: f.write('%d | %s | %s\n' % r)
for r in rep[:60]: print(r)
