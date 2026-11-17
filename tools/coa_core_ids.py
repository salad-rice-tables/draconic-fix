import os
"""Give the Ascension-only spell effects / auras of the CoA spells their OWN ids in the core, so they stop colliding with unrelated Midnight handlers.
 alloc   data/coa/coa_effect_remap.json -> data/coa/coa_effect_alloc.json: CoA id -> existing Midnight id (same meaning, e.g. TELEPORT_UNITS 5 -> 252)
         or a new id after TOTAL_AURAS (675..) / TOTAL_SPELL_EFFECTS (361..)
 core    adds the new enum values + empty handler / static-data entries to Draconic-RoleplayCore (idempotent, marker 'CoA custom ids')
 hotfix  rewrites hotfixes.spell_effect of the CoA spells (7000000 + CoA id) to the new ids; originals kept in hotfixes.coa_effect_remap_bak
usage: python coa_core_ids.py alloc | core | hotfix | undo-hotfix"""
import sys, json, re
sys.path.append("C:/Users/<user>/AppData/Roaming/Python/Python314/site-packages")
import pymysql

D = r'C:\WowServer\Custom\data\coa'
REMAP, ALLOC = D + r'\coa_effect_remap.json', D + r'\coa_effect_alloc.json'
G = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game'
MARK = 'CoA custom ids'
AURA0, EFF0 = 675, 361


def ident(n):
    return None if (n.isdigit() or n == '?') else re.sub(r'[^A-Z0-9_]', '_', 'ASC_' + n.replace('ASCENSION_', '').upper())


def alloc():
    r = json.load(open(REMAP)); out = {'aura': {}, 'effect': {}}
    for kind, base in (('aura', AURA0), ('effect', EFF0)):
        k = 0
        for cid, v in sorted(r[kind].items(), key=lambda kv: int(kv[0])):
            if v['to'] < 1000: out[kind][cid] = {'to': v['to'], 'name': v['coa'], 'custom': False}
            else: out[kind][cid] = {'to': base + k, 'name': v['coa'], 'custom': True}; k += 1
    json.dump(out, open(ALLOC, 'w'), indent=1)
    print('aura custom', sum(1 for v in out['aura'].values() if v['custom']), 'effect custom', sum(1 for v in out['effect'].values() if v['custom']))


def insert(path, anchor_re, text, before):
    """Insert text before / after the LAST match of anchor_re (CRLF files stay CRLF). Idempotent through MARK."""
    s = open(path, encoding='utf-8', errors='ignore', newline='').read()
    if MARK in s: return 'already done'
    ms = list(re.finditer(anchor_re, s)); assert ms, (path, anchor_re)
    m = ms[-1]; nl = '\r\n' if '\r\n' in s else '\n'; text = text.replace('\n', nl)
    pos = m.start() if before else m.end()
    open(path, 'w', encoding='utf-8', newline='').write(s[:pos] + text + s[pos:]); return 'edited'


def core():
    a = json.load(open(ALLOC))
    au = sorted((v['to'], v['name'], k) for k, v in a['aura'].items() if v['custom'])
    ef = sorted((v['to'], v['name'], k) for k, v in a['effect'].items() if v['custom'])

    def enum(prefix, rows):
        seen = set(); out = ''
        for t, n, cid in rows:
            x = ident(n) or 'ASC_%s' % cid
            while x in seen: x += '_B'
            seen.add(x); out += '    %-54s = %d,\n' % (prefix + x, t)
        return out
    print('SpellAuraDefines.h', insert(G + r'\Spells\Auras\SpellAuraDefines.h', r'\r?\n    TOTAL_AURAS',
          '\n    // ' + MARK + ' (tools/coa_core_ids.py): CoA/Ascension auras without a Midnight equivalent\n' + enum('SPELL_AURA_', au), True))
    print('SharedDefines.h', insert(G + r'\Miscellaneous\SharedDefines.h', r'\r?\n    TOTAL_SPELL_EFFECTS',
          '\n    // ' + MARK + ' (tools/coa_core_ids.py): CoA/Ascension effects without a Midnight equivalent\n' + enum('SPELL_EFFECT_', ef), True))
    print('SpellAuraEffects.cpp', insert(G + r'\Spells\Auras\SpellAuraEffects.cpp', r'\r?\n    &AuraEffect::HandleNULL,[^\n]*//674',
          '\n    // ' + MARK + '\n' + ''.join('    &AuraEffect::HandleNULL,                                      //%d CoA %s\n' % (t, n) for t, n, cid in au).rstrip('\n'), False))
    print('SpellEffects.cpp', insert(G + r'\Spells\SpellEffects.cpp', r'\r?\n    &Spell::EffectNULL,[^\n]*//360 SPELL_EFFECT_360',
          '\n    // ' + MARK + '\n' + ''.join('    &Spell::EffectNULL,                                     //%d CoA %s\n' % (t, n) for t, n, cid in ef).rstrip('\n'), False))
    print('SpellInfo.cpp', insert(G + r'\Spells\SpellInfo.cpp', r'\r?\n    \{EFFECT_IMPLICIT_TARGET_NONE,     TARGET_OBJECT_TYPE_NONE\}, // 360 SPELL_EFFECT_360',
          '\n    // ' + MARK + '\n' + ''.join('    {EFFECT_IMPLICIT_TARGET_EXPLICIT, TARGET_OBJECT_TYPE_UNIT}, // %d CoA %s\n' % (t, n) for t, n, cid in ef).rstrip('\n'), False))


def hotfix():
    a = json.load(open(ALLOC))
    raw = json.load(open(D + r'\all_spells_raw.json')); S = {7000000 + int(k) for k in raw if k.isdigit()}
    c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True); q = c.cursor()
    q.execute("create table if not exists coa_effect_remap_bak (ID int not null, Effect int not null, EffectAura smallint not null, primary key (ID))")
    n = 0
    for kind, col in (('aura', 'EffectAura'), ('effect', 'Effect')):
        for cid, v in a[kind].items():
            q.execute("select ID,SpellID,Effect,EffectAura from spell_effect where " + col + "=%s and SpellID between 7000001 and 7999999", (int(cid),))
            for rid, sid, e, au in q.fetchall():
                if sid not in S: continue
                q.execute("insert ignore into coa_effect_remap_bak (ID,Effect,EffectAura) values (%s,%s,%s)", (rid, e, au))
                q.execute("update spell_effect set " + col + "=%s where ID=%s", (v['to'], rid)); n += 1
    print('rewrote', n, 'spell_effect values (originals in hotfixes.coa_effect_remap_bak)')


def undo_hotfix():
    c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True); q = c.cursor()
    q.execute("update spell_effect e join coa_effect_remap_bak b on b.ID=e.ID set e.Effect=b.Effect, e.EffectAura=b.EffectAura"); print('restored', q.rowcount)


if __name__ == '__main__':
    {'alloc': alloc, 'core': core, 'hotfix': hotfix, 'undo-hotfix': undo_hotfix}[sys.argv[1]]()
