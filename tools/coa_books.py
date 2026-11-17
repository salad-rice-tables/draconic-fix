"""CoA companion books: 'Book of Ascension' (class trainer pet) + 'Book of Artisans' (profession trainers pet).
Creates creatures 1488001/2, minipet summon spells 1488101/2 (hotfix push 1950700), gossip->trainer menus (79001/79002),
class trainers 7901001..13 from COA_SCHEDULE (levels > 1), spell_custom rows so every slot class knows both summons.
usage: python coa_books.py     undo: sql/20261106_coa_books_undo.sql"""
import json, os, re, pymysql

ROOT = r'C:\WowServer\Custom'
PUSH, BUILD, H_NAME, H_SPELL, H_EFF, H_MISC = 1950700, 69933, 1187407512, 3776013982, 4030871717, 3322146344
TPL = 7500013
#      creature, spell,   name,                 subname,              template creature, model, icon,   menu
BOOKS = [(1488001, 1488101, 'Book of Ascension', 'Class Trainer', 208116, 102040, 133741, 79001),
         (1488002, 1488102, 'Book of Artisans', 'Profession Trainer', 106553, 46938, 133743, 79002)]
PROF = {129: 'First Aid', 164: 'Blacksmithing', 165: 'Leatherworking', 171: 'Alchemy', 182: 'Herbalism', 185: 'Cooking', 186: 'Mining', 197: 'Tailoring', 202: 'Engineering',
        333: 'Enchanting', 356: 'Fishing', 393: 'Skinning', 755: 'Jewelcrafting', 773: 'Inscription', 794: 'Archaeology'}
db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True)
c = db.cursor()
slots = json.load(open(os.path.join(ROOT, 'data', 'coa', 'coa_class_slots.json'), encoding='utf-8'))
TRAIN = json.load(open(os.path.join(ROOT, 'data', 'coa', 'class_trainer_spells.json'), encoding='utf-8'))
CID_OF = {'barbarian': 12, 'witchdoctor': 13, 'demonhunter': 14, 'witchhunter': 15, 'stormbringer': 16, 'knightofxoroth': 17, 'guardian': 18, 'monk': 19, 'sonofarugal': 20, 'ranger': 21, 'chronomancer': 22, 'necromancer': 23, 'pyromancer': 24, 'cultist': 25, 'starcaller': 26, 'suncleric': 27, 'tinker': 28, 'venomancer': 29, 'reaper': 30, 'primalist': 31, 'runemaster': 32}
sched = open(os.path.join(ROOT, 'lua', 'coa_class_schedule.lua'), encoding='utf-8').read()


def run(sql, a=None):
    c.execute(sql, a)


def clone_row(table, key, where, new_key, newvals):
    """copy the template spell's row of hotfixes.<table> (where `where`=TPL) with key=new_key and overrides"""
    c.execute(f'select * from hotfixes.{table} where `{where}`=%s', (TPL,))
    cols = [d[0] for d in c.description]
    row = dict(zip(cols, c.fetchone()))
    row.update(newvals)
    row[key] = new_key
    row['VerifiedBuild'] = BUILD
    run(f'delete from hotfixes.{table} where `{key}`=%s', (new_key,))
    run(f'insert into hotfixes.{table} ({",".join(f"`{k}`" for k in cols)}) values ({",".join(["%s"] * len(cols))})', [row[k] for k in cols])


run('delete from hotfixes.hotfix_data where Id=%s', (PUSH,))
uid = 3700000000
hot = []
for cid, sid, name, sub, tplc, disp, icon, menu in BOOKS:
    run('drop temporary table if exists tmpc')
    run('create temporary table tmpc as select * from world.creature_template where entry=%s', (tplc,))
    run('update tmpc set entry=%s, name=%s, subname=%s, npcflag=17, faction=35, scale=0.6, flags_extra=0', (cid, name, sub))
    run('delete from world.creature_template where entry=%s', (cid,))
    run('insert into world.creature_template select * from tmpc')
    run('delete from world.creature_template_model where CreatureID=%s', (cid,))
    run('insert into world.creature_template_model values (%s,0,%s,1,1,%s)', (cid, disp, BUILD))
    run('delete from world.creature_template_difficulty where Entry=%s', (cid,))
    run('insert into world.creature_template_difficulty (Entry, DifficultyID, ContentTuningID, HealthScalingExpansion, HealthModifier, ManaModifier, ArmorModifier, DamageModifier, CreatureDifficultyID, TypeFlags, VerifiedBuild) '
        'values (%s,0,864,0,1,1,1,0,%s,0,%s)', (cid, 79000000 + cid, BUILD))
    clone_row('spell', 'ID', 'ID', sid, {})
    clone_row('spell_name', 'ID', 'ID', sid, {'Name_lang': name})
    clone_row('spell_effect', 'ID', 'SpellID', 72500000 + sid - 1488100, {'SpellID': sid, 'EffectMiscValue1': cid, 'EffectMiscValue2': 41, 'EffectBasePoints': 0})
    clone_row('spell_misc', 'ID', 'SpellID', 72600000 + sid - 1488100, {'SpellID': sid, 'CastingTimeIndex': 1, 'DurationIndex': 0, 'SpellIconFileDataID': icon, 'ActiveIconFileDataID': icon, 'RangeIndex': 1})
    for h, rid in ((H_NAME, sid), (H_SPELL, sid), (H_EFF, 72500000 + sid - 1488100), (H_MISC, 72600000 + sid - 1488100)):
        hot.append((h, rid))
run('insert into hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild) values ' + ','.join(f'({PUSH},{uid + i},{h},{r},1,{BUILD})' for i, (h, r) in enumerate(hot)))

run('select TextID from world.gossip_menu group by TextID order by count(*) desc limit 1')
text = c.fetchone()[0]
run('delete from world.gossip_menu where MenuID in (79001,79002)')
run('insert into world.gossip_menu (MenuID, TextID, VerifiedBuild) values (79001,%s,0),(79002,%s,0)', (text, text))
run('delete from world.gossip_menu_option where MenuID in (79001,79002)')
run('delete from world.creature_trainer where CreatureID in (1488001,1488002)')
run('delete from world.conditions where SourceTypeOrReferenceId=15 and SourceGroup=79001')
run('delete from world.trainer where Id between 7901001 and 7901013')
run('delete from world.trainer_spell where TrainerId between 7901001 and 7901013')
gm = ('insert into world.gossip_menu_option (MenuID, GossipOptionID, OptionID, OptionNpc, OptionText, OptionBroadcastTextID, Language, Flags, ActionMenuID, ActionPoiID, '
      'GossipNpcOptionID, BoxCoded, BoxMoney, BoxText, BoxBroadcastTextID, SpellID, OverrideIconID, VerifiedBuild) values (%s,%s,%s,3,%s,0,0,0,0,0,NULL,0,0,NULL,0,NULL,NULL,0)')
for s, v in slots.items():
    s = int(s)
    tid = 7901000 + s
    run('insert into world.trainer (Id, Type, Greeting, VerifiedBuild) values (%s,2,%s,0)', (tid, 'Turn the page, and I will teach you.'))
    cid = CID_OF[v['coa']]
    mp = lambda i: 7000000 + i if i >= 300000 else i
    rows = sorted({(tid, mp(x['spell']), x['cost'], mp(x['req1']) if x['req1'] else 0, x['level']) for x in TRAIN[str(cid)]}, key=lambda r: (r[4], r[1]))
    c.executemany('insert into world.trainer_spell (TrainerId, SpellId, MoneyCost, ReqSkillLine, ReqSkillRank, ReqAbility1, ReqAbility2, ReqAbility3, ReqLevel, VerifiedBuild) values (%s,%s,%s,0,0,%s,0,0,%s,0)', rows)
    run(gm, (79001, -(790010 + s), s - 1, f"Teach me {v['name']} abilities."))
    run('insert into world.creature_trainer (CreatureID, TrainerID, MenuID, OptionID) values (1488001,%s,79001,%s)', (tid, s - 1))
    run('insert into world.conditions (SourceTypeOrReferenceId, SourceGroup, SourceEntry, SourceId, ElseGroup, ConditionTypeOrReference, ConditionTarget, ConditionValue1, ConditionValue2, ConditionValue3, '
        'ConditionStringValue1, NegativeCondition, ErrorType, ErrorTextId, ScriptName, Comment) values (15,79001,%s,0,0,15,0,%s,0,0,"",0,0,0,"",%s)', (s - 1, 1 << (s - 1), 'Book of Ascension: ' + v['name']))
run('select ReqSkillLine, TrainerId, count(*) n from world.trainer_spell where ReqSkillLine in (%s) group by ReqSkillLine, TrainerId order by ReqSkillLine, n desc' % ','.join(map(str, PROF)))
best = {}
for sk, t, n in c.fetchall():
    best.setdefault(sk, t)
for i, (sk, tid) in enumerate(best.items()):
    run(gm, (79002, -(790020 + i), i, f'Teach me {PROF[sk]}.'))
    run('insert into world.creature_trainer (CreatureID, TrainerID, MenuID, OptionID) values (1488002,%s,79002,%s)', (tid, i))
run('delete from world.creature_template_gossip where CreatureID in (1488001,1488002)')
run('insert into world.creature_template_gossip (CreatureID, MenuID, VerifiedBuild) values (1488001,79001,0),(1488002,79002,0)')

run("delete from world.playercreateinfo_spell_custom where Note like 'CoA book%'")
for sid in (1488101, 1488102):
    run("insert into world.playercreateinfo_spell_custom (racemask, classmask, Spell, Note) values (0, 8191, %s, 'CoA book summon')", (sid,))
open(os.path.join(ROOT, 'sql', '20261106_coa_books_undo.sql'), 'w').write(
    "DELETE FROM hotfixes.hotfix_data WHERE Id=1950700;\nDELETE FROM world.creature_template WHERE entry IN (1488001,1488002);\n"
    "DELETE FROM world.playercreateinfo_spell_custom WHERE Note LIKE 'CoA book%';\nDELETE FROM world.trainer WHERE Id BETWEEN 7901001 AND 7901013;\n"
    "DELETE FROM world.gossip_menu WHERE MenuID IN (79001,79002);\nDELETE FROM world.gossip_menu_option WHERE MenuID IN (79001,79002);\n")
print('ok', len(best), 'profession options')
