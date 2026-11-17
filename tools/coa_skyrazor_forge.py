import os
"""Skyrazor forge: the top Necrotic Call tank (6 Life Force).

Same pattern as tools/coa_swarm_forge.py: one custom creature whose model pool is the retail
"Nerubian Skyrazor" display set (random look per spawn), and a summon spell cloned from the
Nerubian Hulk swarm summon (7991154) with its own name, icon and creature.
It has its own hotfix_data push id, so re-running never drops the Swarm Call pushes.

usage: python tools/coa_skyrazor_forge.py [--dry]
"""
import sys
import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
TEMPLATE = 7991154           # Swarm Call: Nerubian Hulk (full clone row set)
TEMPLATE_CREATURE = 7050065  # Lesser Skeletal Warrior: faction 35, unit_class 1
PUSH = 1960005
ROW0 = 75002000
BUILD = 69933

ENTRY = 7050160
SPELL = 7991160
NAME = 'Swarm Call: Skyrazor'
ICON = 5779390
POOL = [221605, 223840]      # retail Nerubian Skyrazor creatures -> their display ids
TRAINER = 7901006
ABILITY = 7991155            # Severed Covenant: the trainer entry stays greyed out without it
MONEY = 44550
LEVEL = 90

TABLE_HASH = {
    'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344,
    'spell_effect': 4030871717, 'spell_power': 2712461791, 'spell_categories': 3689412649,
    'spell_cooldowns': 4193483863, 'spell_levels': 501138918,
    'spell_class_options': 680438657, 'spell_x_spell_visual': 666345498,
}


def cols(cur, t):
    cur.execute(f'SHOW COLUMNS FROM hotfixes.{t}')
    return [r[0] for r in cur.fetchall()]


def clone_rows(cur, new, name, icon, creature):
    out = []
    for t in TABLE_HASH:
        key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
        cur.execute(f'DELETE FROM hotfixes.{t} WHERE `{key}`=%s', (new,))
        cs = cols(cur, t)
        cur.execute(f'SELECT * FROM hotfixes.{t} WHERE `{key}`=%s', (TEMPLATE,))
        for row in cur.fetchall():
            d = dict(zip(cs, row))
            if t in ('spell_name', 'spell'):
                d['ID'] = new
            else:
                d['ID'] = ROW0 + new % 1000 * 10 + d.get('EffectIndex', 0) if t == 'spell_effect' else ROW0 + new % 1000 * 10 + 5
                d['SpellID'] = new
            if t == 'spell_name':
                d['Name'] = name
            if t == 'spell':
                d['Description'] = 'Summons a Nerubian servant.'
                d['AuraDescription'] = ''
            if t == 'spell_misc':
                d['SpellIconFileDataID'] = icon
                d['ActiveIconFileDataID'] = icon
            if t == 'spell_effect' and d['Effect'] == 28:
                d['EffectMiscValue1'] = creature
            cur.execute('INSERT INTO hotfixes.%s (%s) VALUES (%s)' % (
                t, ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))
            out.append((TABLE_HASH[t], d['ID']))
    return out


def main():
    dry = '--dry' in sys.argv
    db = pymysql.connect(**DB)
    cur = db.cursor()
    pushes = []

    cur.execute('SELECT entry FROM world.creature_template WHERE entry=%s', (ENTRY,))
    if cur.fetchone():
        print('creature ok', ENTRY)
    elif dry:
        print('would create creature', ENTRY)
    else:
        cur.execute('SELECT * FROM world.creature_template WHERE entry=%s', (TEMPLATE_CREATURE,))
        d = dict(zip([x[0] for x in cur.description], cur.fetchone()))
        d.update(entry=ENTRY, name=NAME, RangeAttackTime=2000)
        cur.execute('INSERT INTO world.creature_template (%s) VALUES (%s)' % (
            ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))
        cur.execute('SELECT * FROM world.creature_template_difficulty WHERE Entry=%s', (TEMPLATE_CREATURE,))
        d = dict(zip([x[0] for x in cur.description], cur.fetchone()))
        d['Entry'] = ENTRY
        cur.execute('INSERT INTO world.creature_template_difficulty (%s) VALUES (%s)' % (
            ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))
        cur.execute('DELETE FROM world.creature_template_model WHERE CreatureID=%s', (ENTRY,))
        cur.execute('SELECT DISTINCT CreatureDisplayID FROM world.creature_template_model '
                    'WHERE CreatureID IN (%s) ORDER BY CreatureDisplayID' % ','.join(str(x) for x in POOL))
        seen = [r[0] for r in cur.fetchall()]
        for i, disp in enumerate(seen):
            cur.execute('INSERT INTO world.creature_template_model '
                        '(CreatureID,Idx,CreatureDisplayID,DisplayScale,Probability,VerifiedBuild) '
                        'VALUES (%s,%s,%s,1,1,%s)', (ENTRY, i, disp, BUILD))
        print('creature', ENTRY, 'models', len(seen))

    cur.execute('SELECT ID FROM hotfixes.spell_name WHERE ID=%s', (SPELL,))
    if cur.fetchone():
        print('exists, skip spell', SPELL)
    elif dry:
        print('would forge spell', SPELL)
    else:
        pushes += clone_rows(cur, SPELL, NAME, ICON, ENTRY)
        print('spell', SPELL, 'rows', len(pushes))

    if not dry and pushes:
        cur.execute('DELETE FROM hotfixes.hotfix_data WHERE Id=%s', (PUSH,))
        cur.executemany('INSERT INTO hotfixes.hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) '
                        'VALUES (%s,%s,%s,%s,1,%s)',
                        [(PUSH, 3993000000 + i, th, rid, BUILD) for i, (th, rid) in enumerate(pushes)])
        print('hotfix rows', len(pushes))

    if not dry:
        cur.execute('DELETE FROM world.trainer_spell WHERE TrainerId=%s AND SpellId=%s', (TRAINER, SPELL))
        cur.execute('INSERT INTO world.trainer_spell '
                    '(TrainerId,SpellId,MoneyCost,ReqSkillLine,ReqSkillRank,ReqAbility1,ReqAbility2,ReqAbility3,ReqLevel,VerifiedBuild) '
                    'VALUES (%s,%s,%s,0,0,%s,0,0,%s,0)', (TRAINER, SPELL, MONEY, ABILITY, LEVEL))
        print('trainer row', TRAINER, SPELL)

    db.commit()
    db.close()


main()
