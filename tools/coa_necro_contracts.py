"""Port of CoA's ApplyContracts() (src/server/coa/AscensionNecromancerContracts.cpp): the per-spell data fixes the CoA core applies at load,
applied here to the converted spells (hotfixes.spell_effect / spell_misc). Only fixes that map onto standard Midnight fields are ported;
fixes that need CoA-only effect types / aura states (ASCENSION_*) are listed in docs/NECROMANCER_ENGINE_STATUS.md.
Idempotent; the original rows are saved to data/coa/contracts_undo.json (restore with --undo).
usage: python coa_necro_contracts.py [--undo]"""
import json, os, sys, pymysql

ROOT = r'C:\WowServer\Custom'
UNDO = os.path.join(ROOT, 'data', 'coa', 'contracts_undo.json')
OFF = 7000000
DUMMY, PERIODIC_DUMMY, PERIODIC_DAMAGE, MOD_ROOT, MOD_STUN, MOD_DAMAGE_DONE, MOD_ATTACK_POWER, MOD_THREAT, SCHOOL_ABSORB, HEAL_ABSORB, MOD_RES_PCT = 4, 226, 3, 26, 12, 13, 99, 10, 69, 301, 22
EFF_NONE, EFF_DUMMY, EFF_APPLY_AURA, EFF_HEAL = 0, 3, 6, 10
T_CASTER, T_ENEMY, T_ALLY, T_ANY = 1, 6, 21, 25

db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)
c = db.cursor()


def fam29():
    c.execute('select SpellID from spell_class_options where SpellClassSet=29 and SpellID>=%s', (OFF,))
    return {r[0] - OFF for r in c.fetchall()}


ops = {}   # (spell, effectIndex) -> {column: value}


def eff(spell, idx, **kw):
    ops.setdefault((spell, idx), {}).update(kw)


def dummy(spell, idx): eff(spell, idx, EffectAura=DUMMY, EffectTriggerSpell=0)
def none(spell, idx): eff(spell, idx, Effect=EFF_NONE)
def periodic(spell, idx, ms): eff(spell, idx, Effect=EFF_APPLY_AURA, EffectAura=PERIODIC_DUMMY, EffectAuraPeriod=ms, EffectTriggerSpell=0)
def target(spell, idx, a, b=0): eff(spell, idx, ImplicitTarget1=a, ImplicitTarget2=b)


spell_ops = {}   # spell -> {column: value} on spell_misc


def misc(spell, **kw): spell_ops.setdefault(spell, {}).update(kw)


# generic: every family-29 spell: proc-trigger auras (42, 354) become dummy (the script drives the procs)
c.execute('select SpellID, EffectIndex, EffectAura from spell_effect where SpellID>=%s and EffectAura in (42,354)', (OFF,))
F29 = fam29()
for sid, idx, aura in c.fetchall():
    if sid - OFF in F29:
        dummy(sid - OFF, idx)

# legacy placeholders: no effects
for s in (805013, 805014, 805018, 805268, 805269, 805270, 805271, 805602, 805608, 500494, 500524, 570132):
    for i in range(3): none(s, i)
for s in (805011, 525004, 805015):   # Necromancer status auras: one infinite dummy
    for i in range(3): none(s, i)
    eff(s, 0, Effect=EFF_APPLY_AURA, EffectAura=DUMMY, ImplicitTarget1=T_CASTER, ImplicitTarget2=0, EffectBasePoints=0, EffectAuraPeriod=0)
    misc(s, DurationIndex=21)
eff(805015, 1, Effect=EFF_APPLY_AURA, EffectAura=MOD_DAMAGE_DONE, EffectMiscValue1=126, ImplicitTarget1=T_CASTER, ImplicitTarget2=0, EffectBasePoints=0)

for s in (804360, 302923, 300234, 301325, 704163, 573223, 706949, 806149, 807925, 801747):
    dummy(s, 0)
eff(573223, 0, EffectBasePoints=19)
for s in (302888, 302920, 503738, 570136, 801728): dummy(s, 1)
for s in (500968, 501890, 501891, 501892, 583255, 583256): eff(s, 0, EffectAura=PERIODIC_DAMAGE)   # Harvest Plague = periodic damage
eff(704706, 0, EffectAura=MOD_ATTACK_POWER)
for i in range(3): dummy(560595, i)
for i in (1, 2): none(504439, i)
none(300960, 1)
for s in (300748, 301326): pass   # copies effect 0 base points to effect 1 (done below)
for s in (500982, 500983, 500985): misc(s, DurationIndex=21)
dummy(500983, 0); eff(500983, 0, Effect=EFF_APPLY_AURA)
eff(500985, 1, EffectAura=MOD_THREAT, EffectMiscValue1=127)
for s in (572638, 706472): eff(s, 0, EffectAura=MOD_DAMAGE_DONE, EffectMiscValue1=126)
eff(681529, 2, Effect=EFF_APPLY_AURA)
none(500981, 2)
eff(505224, 0, EffectAura=SCHOOL_ABSORB, EffectMiscValue1=126, ImplicitTarget1=T_ALLY, ImplicitTarget2=0); misc(505224, DurationIndex=9)
eff(705746, 0, EffectAura=HEAL_ABSORB)
periodic(807796, 1, 5000); periodic(561138, 0, 3000); periodic(704676, 0, 5000)
misc(808016, SchoolMask=48)   # frost | shadow
eff(680928, 1, Effect=EFF_APPLY_AURA, EffectAura=MOD_STUN)
for s in (800979, 572777, 707176, 807856, 801747): pass
eff(706504, 0, ImplicitTarget1=T_CASTER, ImplicitTarget2=0)
eff(301207, 0, EffectAura=MOD_RES_PCT, EffectMiscValue1=127); periodic(301207, 1, 5000)
for s in (803767, 803773):
    eff(s, 0, Effect=EFF_DUMMY)
    for i in (1, 2): none(s, i)
for s in (504845, 704860):   # Bonefreeze / Frozen Grasp: root until damaged
    eff(s, 0, Effect=EFF_APPLY_AURA, EffectAura=MOD_ROOT, ImplicitTarget1=T_ENEMY, ImplicitTarget2=0)
none(504845, 1)
for i in (1, 2): none(800043, i)   # Abomination Hook
none(500933, 1); none(500729, 0); none(500307, 0); none(801938, 1)
eff(707133, 0, EffectAura=DUMMY, EffectTriggerSpell=0, ImplicitTarget1=T_ANY); eff(707133, 1, ImplicitTarget1=T_ANY)
for s in (533240, 500267): target(s, 0, T_ENEMY)
none(500267, 1)
eff(500443, 2, Effect=EFF_NONE)
for s in [*range(533236, 533240), 802121]:
    eff(s, 0, Effect=EFF_DUMMY, ImplicitTarget1=T_CASTER, ImplicitTarget2=0)
    for i in (1, 2): none(s, i)
none(805031, 0); target(805031, 1, T_ALLY)
eff(801514, 2, ImplicitTarget1=0)   # target = master: left to the engine
c.execute('select SpellID, ID, EffectIndex, Effect from spell_effect where SpellID in (%s)' % ','.join(str(OFF + s) for s in (573242, 801241, 561318, 561095, 570050, 505225, 681463)))
for sid, rid, idx, e in c.fetchall():
    if idx == 0: target(sid - OFF, 0, T_ALLY if e == EFF_HEAL else T_ENEMY)
    eff(sid - OFF, idx, EffectBonusCoefficient=0, BonusCoefficientFromAP=0)
eff(707575, 0, EffectBonusCoefficient=0); eff(707575, 1, EffectBonusCoefficient=0); eff(707575, 2, EffectBonusCoefficient=0)

if '--undo' in sys.argv:
    saved = json.load(open(UNDO))
    for rid, row in saved['effects'].items():
        c.execute('update spell_effect set ' + ','.join(f'`{k}`=%s' for k in row) + ' where ID=%s', (*row.values(), int(rid)))
    for sid, row in saved['misc'].items():
        c.execute('update spell_misc set ' + ','.join(f'`{k}`=%s' for k in row) + ' where SpellID=%s', (*row.values(), int(sid)))
    print('undone', len(saved['effects']), len(saved['misc']))
    sys.exit()

saved = json.load(open(UNDO)) if os.path.exists(UNDO) else {'effects': {}, 'misc': {}}
done = skipped = 0
for (spell, idx), cols in ops.items():
    c.execute('select ID,' + ','.join(f'`{k}`' for k in cols) + ' from spell_effect where SpellID=%s and EffectIndex=%s', (OFF + spell, idx))
    r = c.fetchone()
    if not r:
        skipped += 1; continue
    saved['effects'].setdefault(str(r[0]), dict(zip(cols, r[1:])))
    c.execute('update spell_effect set ' + ','.join(f'`{k}`=%s' for k in cols) + ' where ID=%s', (*cols.values(), r[0])); done += 1
for spell, cols in spell_ops.items():
    c.execute('select ' + ','.join(f'`{k}`' for k in cols) + ' from spell_misc where SpellID=%s', (OFF + spell,))
    r = c.fetchone()
    if not r: continue
    saved['misc'].setdefault(str(OFF + spell), dict(zip(cols, r)))
    c.execute('update spell_misc set ' + ','.join(f'`{k}`=%s' for k in cols) + ' where SpellID=%s', (*cols.values(), OFF + spell))
json.dump(saved, open(UNDO, 'w'))
print('effect rows updated', done, 'skipped (spell not converted)', skipped, 'spell_misc updated', len(spell_ops))
