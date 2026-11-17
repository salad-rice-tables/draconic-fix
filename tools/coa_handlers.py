"""Installs the CoA effect handlers (tools/coa_handlers_batch1.cpp.txt) into Draconic-RoleplayCore: member declarations in Spell.h,
the code appended to SpellEffects.cpp, and the handler table slots of the CoA custom effect ids (data/coa/coa_effect_alloc.json).
Idempotent (marker 'CoA handlers batch1').  usage: python coa_handlers.py install"""
import json, re

G = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game\Spells'
ALLOC = r'C:\WowServer\Custom\data\coa\coa_effect_alloc.json'
CODE = r'C:\WowServer\Custom\tools\coa_handlers_batch1.cpp.txt'
MARK = 'CoA handlers batch1'
HANDLERS = {  # CoA effect id -> Spell member
    165: 'EffectCoaModifyCooldown', 166: 'EffectCoaRestoreBaseManaPct', 168: 'EffectCoaPlaySpellVisualKit', 171: 'EffectCoaModifyAuraCharges',
    173: 'EffectCoaRefreshAura', 175: 'EffectCoaModifyAuraStacks', 176: 'EffectCoaModifyAuraStacksBySpell', 177: 'EffectCoaModifyAuraDuration',
    192: 'EffectCoaModifyCooldownPct', 195: 'EffectCoaResetCooldown'}


def rw(path, fn):
    s = open(path, encoding='utf-8', errors='ignore', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    t = fn(s.replace('\r\n', '\n'))
    open(path, 'w', encoding='utf-8', newline='').write(t.replace('\n', nl))


def install():
    alloc = json.load(open(ALLOC))['effect']
    ids = {int(k): v['to'] for k, v in alloc.items() if v['custom']}

    def spell_h(s):
        if MARK in s: return s
        decl = '        // ' + MARK + '\n' + ''.join('        void %s();\n' % n for n in HANDLERS.values())
        return s.replace('        void EffectNULL();\n', '        void EffectNULL();\n' + decl, 1)
    rw(G + r'\Spell.h', spell_h)

    def effects_cpp(s):
        if MARK in s: return s
        for cid, name in HANDLERS.items():
            t = ids[cid]
            s, n = re.subn(r'&Spell::EffectNULL,( +)//%d CoA ' % t, lambda m: '&Spell::%s,%s//%d CoA ' % (name, ' ' * max(1, len(m.group(1)) - len(name) + len('EffectNULL')), t), s)
            assert n == 1, (cid, t, n)
        return s.rstrip('\n') + '\n\n// ' + MARK + '\n' + open(CODE, encoding='utf-8').read()
    rw(G + r'\SpellEffects.cpp', effects_cpp)
    print('installed', len(HANDLERS), 'handlers')


if __name__ == '__main__':
    install()
