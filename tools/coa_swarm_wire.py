import os
"""Severed Covenant passive + Swarm Call trainer wiring (world.trainer_spell).

Run after tools/coa_swarm_forge.py. Idempotent.
  * 7991155 "Severed Covenant" = passive marker (attributes passive, dummy aura), level 10.
  * trainer 7901006 (Necromancer book) gets one row per Swarm Call spell, gated with
    ReqAbility1 = 7991155, so the summons only become learnable once the passive is known.
"""
import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
TEMPLATE = 7500970
PASSIVE = 7991155
PASSIVE_ICON = 5792082
PASSIVE_NAME = 'Severed Covenant'
PASSIVE_LEVEL = 10
PUSH = 1960004
ROW = 75002999
BUILD = 69933
TRAINER = 7901006
TABLE_HASH = {
    'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344,
    'spell_effect': 4030871717, 'spell_power': 2712461791, 'spell_categories': 3689412649,
    'spell_cooldowns': 4193483863, 'spell_levels': 501138918,
    'spell_class_options': 680438657, 'spell_x_spell_visual': 666345498,
}
# spell, level
SUMMONS = [
    (7991140, 5), (7991141, 7), (7991142, 10),
    (7991143, 70), (7991144, 70), (7991145, 70), (7991146, 70), (7991147, 70),
    (7991148, 80), (7991149, 85),
    (7991150, 90), (7991151, 90), (7991152, 90), (7991153, 90), (7991154, 90),
]


def cols(cur, t):
    cur.execute('SHOW COLUMNS FROM hotfixes.%s' % t)
    return [r[0] for r in cur.fetchall()]


def main():
    db = pymysql.connect(**DB)
    cur = db.cursor()
    undo = ['-- Undo of the Swarm Call trainer / Severed Covenant wiring', 'SET NAMES utf8mb4;']

    cur.execute('SELECT ID FROM hotfixes.spell_name WHERE ID=%s', (PASSIVE,))
    if cur.fetchone():
        print('passive exists')
    else:
        pushes = []
        for t in TABLE_HASH:
            key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
            cs = cols(cur, t)
            cur.execute('SELECT * FROM hotfixes.%s WHERE `%s`=%%s' % (t, key), (TEMPLATE,))
            for row in cur.fetchall():
                d = dict(zip(cs, row))
                if t == 'spell_effect' and d['EffectIndex'] != 0:
                    continue   # passive has a single dummy aura, not the template's summon + dummy pair
                d['ID'] = PASSIVE if t in ('spell_name', 'spell') else ROW + len(pushes)
                if t not in ('spell_name', 'spell'):
                    d['SpellID'] = PASSIVE
                if t == 'spell_name':
                    d['Name'] = PASSIVE_NAME
                if t == 'spell':
                    d['Description'] = 'Your pact is severed: the Swarm Call summons answer you.'
                    d['AuraDescription'] = ''
                if t == 'spell_misc':
                    d['SpellIconFileDataID'] = PASSIVE_ICON
                    d['ActiveIconFileDataID'] = PASSIVE_ICON
                    d['Attributes1'] = int(d['Attributes1']) | 64   # SPELL_ATTR0_PASSIVE
                    d['CastingTimeIndex'] = 1
                    d['SpellVisualScript'] = 0
                if t == 'spell_effect':
                    d['Effect'] = 6          # SPELL_EFFECT_APPLY_AURA
                    d['EffectAura'] = 4      # SPELL_AURA_DUMMY
                    d['EffectBasePoints'] = 0
                    d['EffectMiscValue1'] = 0
                    d['EffectMiscValue2'] = 0
                    d['ImplicitTarget1'] = 1  # caster
                    d['ImplicitTarget2'] = 0
                cur.execute('INSERT INTO hotfixes.%s (%s) VALUES (%s)' % (
                    t, ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))
                pushes.append((TABLE_HASH[t], d['ID']))
            undo.append('DELETE FROM hotfixes.%s WHERE `%s`=%d;' % (t, key, PASSIVE))
        cur.execute('DELETE FROM hotfixes.hotfix_data WHERE Id=%s', (PUSH,))
        cur.executemany('INSERT INTO hotfixes.hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) '
                        'VALUES (%s,%s,%s,%s,1,%s)',
                        [(PUSH, 3993000000 + i, th, rid, BUILD) for i, (th, rid) in enumerate(pushes)])
        print('passive forged', PASSIVE, 'hotfix rows', len(pushes))
    undo.append('DELETE FROM hotfixes.hotfix_data WHERE Id=%d;' % PUSH)

    rows = [PASSIVE] + [s for s, _ in SUMMONS]
    levels = {PASSIVE: PASSIVE_LEVEL}
    levels.update(dict(SUMMONS))
    for spell in rows:
        cur.execute('DELETE FROM world.trainer_spell WHERE TrainerId=%s AND SpellId=%s', (TRAINER, spell))
        req = 0 if spell == PASSIVE else PASSIVE
        cost = max(2, int(levels[spell] ** 2 * 5.5))
        cur.execute('INSERT INTO world.trainer_spell (TrainerId,SpellId,MoneyCost,ReqSkillLine,ReqSkillRank,'
                    'ReqAbility1,ReqAbility2,ReqAbility3,ReqLevel,VerifiedBuild) '
                    'VALUES (%s,%s,%s,0,0,%s,0,0,%s,0)',
                    (TRAINER, spell, cost, req, levels[spell]))
        undo.append('DELETE FROM world.trainer_spell WHERE TrainerId=%d AND SpellId=%d;' % (TRAINER, spell))
    print('trainer rows', len(rows))

    db.commit()
    open(r'C:\WowServer\Custom\sql\20261112_coa_swarm_call_wire_undo.sql', 'w', encoding='utf-8').write(
        '\n'.join(undo) + '\n')
    db.close()


main()
