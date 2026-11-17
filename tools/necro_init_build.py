"""Necromancer initiation campaign: database part + locations (idempotent).
 1. world: renames the three provided creatures, flags them as quest givers, creates / converts the gameobject templates, quests 9330001-9330002 (+ chain links, texts), loot of the corpse, gossip menus
 2. hotfixes: phase auras 7990101 (Valley of Trials campaign phase 90330001) and 7990102 (Maldraxxus campaign phase 90330002)  [push 1953100]
 3. characters: table coa_initiation(guid, stage, essence)
 4. spawns + lua/coa_init_config.lua from data/necro_init/locations.json (entries with null coordinates are skipped, nothing is invented)
usage: python tools/necro_init_build.py   (re-run after editing locations.json)    undo: sql/20261107_necro_init_undo.sql (written by this script)"""
import json, os, pymysql, sys
ROOT = r'C:\WowServer\Custom'
LOC = json.load(open(os.path.join(ROOT, 'data', 'necro_init', 'locations.json'), encoding='utf-8'))
PH = LOC['phase']
CAP = os.path.join(ROOT, 'data', 'necro_init', 'captured.txt')   # written in game by  .ni here <key>   (map x y z o): overrides / fills locations.json
if os.path.exists(CAP):
    for line in open(CAP, encoding='utf-8'):
        p = line.split()
        if len(p) == 6 and p[0] in LOC and isinstance(LOC[p[0]], dict):
            LOC[p[0]].update(map=int(p[1]), x=float(p[2]), y=float(p[3]), z=float(p[4]), o=float(p[5]))
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
Hc = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
Ch = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='characters', autocommit=True).cursor()
undo = []

# ---- characters: persistence
Ch.execute("CREATE TABLE IF NOT EXISTS coa_initiation (guid INT UNSIGNED NOT NULL PRIMARY KEY, stage TINYINT UNSIGNED NOT NULL DEFAULT 0, essence TINYINT UNSIGNED NOT NULL DEFAULT 0, updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)")

# ---- creatures (existing ids are kept; only name, subname and the quest-giver / gossip flags change)
for entry, name, sub, flags in ((139829, "Zal'thira", 'Necromancer Trainer', 3), (161180, "Vex'thal", 'Fallen Necromancer', 0), (163243, 'Korthaz', 'Maldraxxian Necromancer', 3)):
    W.execute('select name, subname, npcflag from creature_template where entry=%s', (entry,))
    undo.append("UPDATE creature_template SET name=%s, subname=%s, npcflag=%s WHERE entry=%s;" % tuple(repr(x) if isinstance(x, str) else str(x) for x in (*W.fetchone(), entry)))
    W.execute('update creature_template set name=%s, subname=%s, npcflag=%s where entry=%s', (name, sub, flags, entry))
W.execute("update creature_template set AIName='' where entry=139829")   # SmartAI of the retail Nazmani would fight the script

# ---- gameobjects: Goober (type 10) so every one of them can open a gossip menu; the Tome gets a new template (display of an existing book)
W.execute("select displayId from gameobject_template where entry=92013"); book = W.fetchone()[0]
for entry, name, disp in ((322354, 'Tome of Oblivion', book), (5080290, 'Maldraxxian Anima Crystal', None), (5081476, 'Necrotic Portal', None)):
    W.execute('select count(*) from gameobject_template where entry=%s', (entry,))
    if W.fetchone()[0]:
        W.execute('update gameobject_template set type=10, name=%s where entry=%s', (name, entry))
    else:
        W.execute('select * from gameobject_template where entry=92013'); r = list(W.fetchone())
        W.execute('show columns from gameobject_template'); cs = [c[0] for c in W.fetchall()]
        d = dict(zip(cs, r)); d.update(entry=entry, name=name, displayId=disp, type=10, Data0=0, Data1=0, Data2=0)
        W.execute('insert into gameobject_template (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))

# ---- quests (custom ids 9330001..; copied from an existing simple quest row, then text / links replaced)
W.execute('select * from quest_template where ID=94957000'); base = W.fetchone()
W.execute('show columns from quest_template'); qc = [c[0] for c in W.fetchall()]
QUESTS = {int(k): {**v, 'starter': tuple(v['starter']), 'ender': tuple(v['ender'])} for k, v in json.load(open(os.path.join(ROOT, 'data', 'necro_init', 'quests.json'), encoding='utf-8')).items()}
for qid, q in QUESTS.items():
    d = dict(zip(qc, base)); d.update(ID=qid, LogTitle=q['LogTitle'], LogDescription=q['LogDescription'], QuestDescription=q['QuestDescription'], QuestCompletionLog=q['QuestCompletionLog'])
    for k in qc:
        if k.startswith(('RewardItem', 'RewardChoice', 'ItemDrop', 'RewardAmount', 'RewardFaction')) or k in ('RewardMoneyDifficulty', 'RewardBonusMoney', 'RewardNextQuest', 'StartItem', 'RewardSpell'):
            d[k] = 0
    d.update(QuestSortID=0, AllowableRaces=18446744073709551615)   # visible to every race; class is enforced by the script (and by the phase)
    W.execute('delete from quest_template where ID=%s', (qid,))
    W.execute('insert into quest_template (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
    W.execute('delete from quest_template_addon where ID=%s', (qid,)); W.execute('insert into quest_template_addon (ID, PrevQuestID, NextQuestID) values (%s,%s,%s)', (qid, q['prev'], q['nxt']))
    W.execute('delete from quest_offer_reward where ID=%s', (qid,)); W.execute('insert into quest_offer_reward (ID, RewardText) values (%s,%s)', (qid, q['reward']))
    W.execute('delete from quest_request_items where ID=%s', (qid,)); W.execute('insert into quest_request_items (ID, CompletionText) values (%s,%s)', (qid, q['request']))
    for kind, who in (('starter', q['starter']), ('ender', q['ender'])):
        t = ('creature_' if who[0] == 'c' else 'gameobject_') + 'quest' + kind
        W.execute(f'delete from {t} where id=%s and quest=%s', (who[1], qid)); W.execute(f'insert into {t} (id, quest) values (%s,%s)', (who[1], qid))
undo.append('DELETE FROM quest_template WHERE ID BETWEEN 9330001 AND 9330099;')

# ---- corpse loot: the equipment is real loot (the player opens the loot window); existing CoA starter pieces are reused
W.execute('delete from creature_loot_template where Entry=161180')
LOOT = [(2000053, 'Necrotic Robes'), (2000051, 'Necrotic Pants'), (2000052, 'Necrotic Slippers'), (2000089, 'Wraithscythe')]
for item, _ in LOOT:
    W.execute('insert into creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) values (161180,%s,0,100,0,1,0,1,1,%s)', (item, 'Necro initiation'))
W.execute('select LootID from creature_template_difficulty where Entry=161180 and DifficultyID=0'); lid = W.fetchone()
if not lid or lid[0] != 161180: W.execute('update creature_template_difficulty set LootID=161180 where Entry=161180')

# ---- hotfix phase auras (clone of an infinite dummy aura, effect 0 = SPELL_AURA_PHASE)
sys.argv = ['x']
Hc.execute('delete from hotfix_data where Id=1953100')
HASH = {'spell_name': 1187407512, 'spell': 3776013982, 'spell_misc': 3322146344, 'spell_effect': 4030871717}
ctr = 0
for sid, label, phase in ((7990101, 'Necromancer Initiation: Valley', PH['valley']), (7990102, 'Necromancer Initiation: Maldraxxus', PH['maldraxxus']), (7990105, 'Necromancer Initiation: Portal', PH['portal'])):
    for t in HASH:
        key = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
        Hc.execute(f'delete from {t} where {key}=%s', (sid,))
        Hc.execute(f'show columns from {t}'); cs = [c[0] for c in Hc.fetchall()]
        Hc.execute(f'select * from {t} where {key}=%s', (7500985,))
        for r in Hc.fetchall():
            d = dict(zip(cs, r))
            if t in ('spell_name', 'spell'):
                d['ID'] = sid
                if t == 'spell_name': d['Name'] = label
                else: d['Description'] = ''; d['AuraDescription'] = ''
            else:
                ctr += 1; d['ID'] = 75000000 + ctr; d['SpellID'] = sid
                if t == 'spell_effect':
                    if d['EffectIndex'] == 0 and phase is None:
                        d.update(EffectAura=4, ImplicitTarget1=1, ImplicitTarget2=0, EffectTriggerSpell=0)
                    elif d['EffectIndex'] == 0:
                        d.update(Effect=6, EffectAura=261, EffectMiscValue1=0, EffectMiscValue2=phase, ImplicitTarget1=1, ImplicitTarget2=0, EffectTriggerSpell=0, EffectBasePoints=0)
                    else:
                        d.update(Effect=0)
                if t == 'spell_misc': d['DurationIndex'] = 21 if phase is not None else 27
            Hc.execute(f'insert into {t} (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
            if t != 'spell_effect' or True:
                Hc.execute('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (1953100,%s,%s,%s,1,69933)', (3995000000 + ctr * 10 + len(HASH), HASH[t], d['ID']))

# ---- spawns from the locations file (only entries that have coordinates)
spawn_sql, lua = [], {}
for key, v in LOC.items():
    if not isinstance(v, dict) or v.get('map') is None or v.get('x') is None:
        continue
    lua[key] = {k: v[k] for k in ('map', 'x', 'y', 'z', 'o') if k in v}
    ph = PH.get(v.get('phase'), 0)
    if v.get('kind') == 'creature':
        spawn_sql.append(f"DELETE FROM creature WHERE guid IN (SELECT guid FROM (SELECT guid FROM creature WHERE id={v['entry']} AND map={v['map']}) t) AND PhaseId={ph};")
        W.execute('select ifnull(max(guid),0)+1 from creature'); g = W.fetchone()[0]
        W.execute('delete from creature where id=%s and map=%s and PhaseId=%s', (v['entry'], v['map'], ph))
        W.execute('insert into creature (guid,id,map,spawnDifficulties,PhaseId,position_x,position_y,position_z,orientation,spawntimesecs,MovementType) values (%s,%s,%s,"0",%s,%s,%s,%s,%s,120,0)', (g, v['entry'], v['map'], ph, v['x'], v['y'], v['z'], v['o']))
    elif v.get('kind') == 'gameobject':   # the Valley portal sits in its own phase 90330003, which the crystal ritual grants to the character
        W.execute('select ifnull(max(guid),0)+1 from gameobject'); g = W.fetchone()[0]
        W.execute('delete from gameobject where id=%s and map=%s and PhaseId=%s', (v['entry'], v['map'], ph))
        W.execute('insert into gameobject (guid,id,map,spawnDifficulties,PhaseId,position_x,position_y,position_z,orientation,rotation0,rotation1,rotation2,rotation3,spawntimesecs,state,size) values (%s,%s,%s,"0",%s,%s,%s,%s,%s,0,0,0,1,120,1,%s)', (g, v['entry'], v['map'], ph, v['x'], v['y'], v['z'], v['o'], v.get('size', -1)))
def lv(v):
    if isinstance(v, dict): return '{' + ', '.join(f'{k} = {lv(x)}' for k, x in v.items()) + '}'
    return json.dumps(v)
cfg = 'COA_INIT = ' + lv({'phase': PH, 'loc': lua}) + chr(10)
open(os.path.join(ROOT, 'lua', 'coa_init_config.lua'), 'w', encoding='utf-8').write('-- generated by tools/necro_init_build.py from data/necro_init/locations.json\n' + cfg)
open(os.path.join(ROOT, 'sql', '20261107_necro_init_undo.sql'), 'w', encoding='utf-8').write('\n'.join(undo) + '\n')
print('placed', sorted(lua) or 'nothing yet (coordinates missing)')
