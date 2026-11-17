import os
"""Swarm Call forge: Necromancer summon tiers -> hotfix spells + world creatures.

One creature per tier; every model of its retail display pool goes into
creature_template_model with Probability 1, so the server picks a random look per spawn.
The summon spell is a clone of 7500970 "Raise: Lesser Skeletal Warrior" (complete hotfix row
set incl. SpellVisual 184527 and hotfix_data push), with its own name, icon and creature.

usage: python tools/coa_swarm_forge.py [--dry]
"""
import sys
import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
TEMPLATE = 7500970          # Raise: Lesser Skeletal Warrior (1 summon effect, full row set)
TEMPLATE_CREATURE = 7050065  # Lesser Skeletal Warrior: faction 35, unit_class 1, CT 864
PUSH = 1960003             # hotfix_data batch id
ROW0 = 75002000            # synthetic row ids for the cloned tables
BUILD = 69933
TABLE_HASH = {
    'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344,
    'spell_effect': 4030871717, 'spell_power': 2712461791, 'spell_categories': 3689412649,
    'spell_cooldowns': 4193483863, 'spell_levels': 501138918,
    'spell_class_options': 680438657, 'spell_x_spell_visual': 666345498,
}

# entry, spell, name, level, icon, ranged, [retail creature entries -> their display ids]
TIERS = [
    (7050140, 7991140, 'Swarm Call: Nerubian Swarmite',  5, 5520458, False, [225702, 225703, 271252, 229512, 222490, 221219]),
    (7050141, 7991141, 'Swarm Call: Nerubian Skitterling', 7, 5764866, False, [228085, 220221, 225203, 217294, 217292, 215928]),
    (7050142, 7991142, 'Swarm Call: Crypt Fiend',        10, 5793407, True,  [224388, 215449, 227761, 228951, 238612, 227458, 234341, 229791, 271250, 229699, 228955, 228954]),
    (7050143, 7991143, 'Swarm Call: Royal Warrior',      70, 5779389, False, [211847, 213377, 217311]),
    (7050144, 7991144, 'Swarm Call: Royal Mage',         70, 5661707, True,  [211907, 208242, 212717]),
    (7050145, 7991145, 'Swarm Call: Royal Rogue',        70, 5764868, False, [227578, 213378]),
    (7050146, 7991146, 'Swarm Call: Royal Priest',       70, 5792085, True,  [212949, 212950, 212951, 212952, 213372, 213373, 213374, 213375]),
    (7050147, 7991147, 'Swarm Call: Royal Hunter',       70, 5764865, True,  [235083]),
    (7050148, 7991148, 'Swarm Call: Crypt Lord',         80, 5779391, False, [208240, 212509, 217039]),
    (7050149, 7991149, 'Swarm Call: Crypt Lord',         85, 5779391, False, [215935]),
    (7050150, 7991150, 'Swarm Call: Royal Warrior',      90, 5779389, False, [216322]),
    (7050151, 7991151, 'Swarm Call: Royal Mage',         90, 5661707, True,  [211928, 216323]),
    (7050152, 7991152, 'Swarm Call: Royal Rogue',        90, 5764868, False, [215298]),
    (7050155, 7991153, 'Swarm Call: Royal Priest',       90, 5792085, True,  [213855]),
    (7050154, 7991154, 'Swarm Call: Nerubian Hulk',      90, 5779390, False, [215895, 215896, 218096]),
]


def cols(cur, t):
    cur.execute(f'SHOW COLUMNS FROM hotfixes.{t}')
    return [r[0] for r in cur.fetchall()]


def clone_rows(cur, new, name, icon, creature):
    """Copy every hotfix row of TEMPLATE onto `new` and patch name/icon/effect."""
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
    undo = ['-- Undo of 20261112_coa_swarm_call.sql (generated)', 'SET NAMES utf8mb4;']
    pushes = []

    for entry, spell, name, level, icon, ranged, pool in TIERS:
        cur.execute('SELECT entry FROM world.creature_template WHERE entry=%s', (entry,))
        if cur.fetchone():
            print('creature ok', entry, name)
        elif dry:
            print('would create creature', entry, name)
        else:
            cur.execute('SELECT * FROM world.creature_template WHERE entry=%s', (TEMPLATE_CREATURE,))
            d = dict(zip([x[0] for x in cur.description], cur.fetchone()))
            d.update(entry=entry, name=name, RangeAttackTime=1000 if ranged else 2000)
            cur.execute('INSERT INTO world.creature_template (%s) VALUES (%s)' % (
                ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))

            cur.execute('SELECT * FROM world.creature_template_difficulty WHERE Entry=%s', (TEMPLATE_CREATURE,))
            d = dict(zip([x[0] for x in cur.description], cur.fetchone()))
            d['Entry'] = entry
            cur.execute('INSERT INTO world.creature_template_difficulty (%s) VALUES (%s)' % (
                ','.join('`%s`' % k for k in d), ','.join(['%s'] * len(d))), tuple(d.values()))

            cur.execute('DELETE FROM world.creature_template_model WHERE CreatureID=%s', (entry,))
            cur.execute('SELECT DISTINCT m.CreatureDisplayID FROM world.creature_template_model m '
                        'WHERE m.CreatureID IN (%s) ORDER BY m.CreatureDisplayID' % ','.join(str(x) for x in pool))
            seen = [r[0] for r in cur.fetchall()]
            for i, disp in enumerate(seen):
                cur.execute('INSERT INTO world.creature_template_model '
                            '(CreatureID,Idx,CreatureDisplayID,DisplayScale,Probability,VerifiedBuild) '
                            'VALUES (%s,%s,%s,1,1,%s)', (entry, i, disp, BUILD))
            print('creature', entry, name, 'models', len(seen))
        undo.append('DELETE FROM world.creature_template_model WHERE CreatureID=%d;' % entry)
        undo.append('DELETE FROM world.creature_template_difficulty WHERE Entry=%d;' % entry)
        undo.append('DELETE FROM world.creature_template WHERE entry=%d;' % entry)

        cur.execute('SELECT ID FROM hotfixes.spell_name WHERE ID=%s', (spell,))
        if cur.fetchone():
            print('exists, skip spell', spell, name)
            continue
        if dry:
            print('would forge spell', spell, name, level)
            continue
        pushes += clone_rows(cur, spell, name, icon, entry)
        for t in TABLE_HASH:
            key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
            undo.append('DELETE FROM hotfixes.%s WHERE `%s`=%d;' % (t, key, spell))
        print('spell', spell, name, 'lvl', level, 'icon', icon)

    if not dry and pushes:
        cur.execute('DELETE FROM hotfixes.hotfix_data WHERE Id=%s', (PUSH,))
        cur.executemany('INSERT INTO hotfixes.hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) '
                        'VALUES (%s,%s,%s,%s,1,%s)',
                        [(PUSH, 3992000000 + i, th, rid, BUILD) for i, (th, rid) in enumerate(pushes)])
        print('hotfix rows', len(pushes))

    db.commit()
    if not dry:
        undo.append('DELETE FROM hotfixes.hotfix_data WHERE Id=%d;' % PUSH)
        open(r'C:\WowServer\Custom\sql\20261112_coa_swarm_call_undo.sql', 'w', encoding='utf-8').write('\n'.join(undo) + '\n')
    db.close()


main()
