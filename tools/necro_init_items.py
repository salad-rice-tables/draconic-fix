import os
"""Maldraxxi Initiate's armour (custom items 9330101-9330110), cloned from the retail Duty-Bound Conjurer's set (cloth) and the
Plague-Wrapped Greatstaff 181323 (wowhead item 181323), renamed and made level-1 gear. Hotfix push 1953200. Re-runnable.
usage: python tools/necro_init_items.py"""
import csv, pymysql
csv.field_size_limit(10 ** 9)
W = r'C:\WowServer\Custom\data\wago'
PUSH, BUILD = 1953201, 69933
H = {'item': 1344507586, 'item_sparse': 2442913102, 'item_modified_appearance': 3834752085}
ITEMS = [  # new id, source retail item, name
    (9330101, 182535, "Maldraxxi Initiate's Hood"), (9330102, 182540, "Maldraxxi Initiate's Mantle"), (9330103, 182536, "Maldraxxi Initiate's Robe"),
    (9330104, 182542, "Maldraxxi Initiate's Bindings"), (9330105, 182538, "Maldraxxi Initiate's Gloves"), (9330106, 182541, "Maldraxxi Initiate's Belt"),
    (9330107, 182539, "Maldraxxi Initiate's Leggings"), (9330108, 182537, "Maldraxxi Initiate's Boots"), (9330109, 182543, "Maldraxxi Initiate's Cloak"),
    (9330110, 181323, "Vex'thal's Bonebound Staff"),
]


def rows(fn, key='ID'):
    r = csv.reader(open(f'{W}\\{fn}', encoding='utf-8'))
    hdr = next(r)
    return hdr, r


src = {s for _, s, _ in ITEMS}
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
out = []
for table, fn, keycol in (('item', 'Item.csv', 0), ('item_sparse', 'ItemSparse.csv', 0)):
    c.execute(f'show columns from {table}'); cols = [x[0] for x in c.fetchall()]
    hdr, r = rows(fn)
    found = {}
    for row in r:
        if row and row[0].isdigit() and int(row[0]) in src:
            found[int(row[0])] = row
    for new, s, name in ITEMS:
        vals = list(found[s]) + [BUILD]
        d = dict(zip(cols, vals))
        d['ID'] = new
        if table == 'item_sparse':
            d.update(Display=name, Display1='', Display2='', Display3='', Description='Worn by the Necromancers of Maldraxxus.', ItemLevel=5, RequiredLevel=1, OverallQualityID=2, ExpansionID=0, Flags4=0, SellPrice=1, BuyPrice=5, Flags1=0 if False else d.get('Flags1', 0))
        if table == 'item':
            d['ContentTuningID'] = 0
        c.execute(f'delete from {table} where ID=%s', (new,))
        c.execute(f'insert into {table} (' + ','.join(f'`{k}`' for k in d) + ') values (' + ','.join(['%s'] * len(d)) + ')', tuple(d.values()))
        out.append((H[table], new))
# appearances: copy each source item's base appearance row
c.execute('show columns from item_modified_appearance'); cols = [x[0] for x in c.fetchall()]
hdr, r = rows('ItemModifiedAppearance.csv')
ia = hdr.index('ItemID'); mod = hdr.index('ItemAppearanceModifierID')
app = {}
for row in r:
    if row and row[ia].isdigit() and int(row[ia]) in src and row[mod] == '0':
        app[int(row[ia])] = row
for n, (new, s, _) in enumerate(ITEMS):
    row = app.get(s)
    if not row:
        print('no appearance for', s); continue
    d = dict(zip(hdr, row)); rid = 93301000 + n
    vals = {'ID': rid, 'ItemID': new, 'ItemAppearanceModifierID': 0, 'ItemAppearanceID': d['ItemAppearanceID'], 'OrderIndex': 0, 'TransmogSourceTypeEnum': d['TransmogSourceTypeEnum'], 'Flags': d['Flags'], 'VerifiedBuild': BUILD}
    vals = {k: v for k, v in vals.items() if k in cols}
    c.execute('delete from item_modified_appearance where ItemID=%s', (new,))
    c.execute('insert into item_modified_appearance (' + ','.join(f'`{k}`' for k in vals) + ') values (' + ','.join(['%s'] * len(vals)) + ')', tuple(vals.values()))
    out.append((H['item_modified_appearance'], rid))
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)', [(PUSH, 3997000000 + i, h, rid, BUILD) for i, (h, rid) in enumerate(out)])
# the corpse loot = this set (every piece, 100 %)
w = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
w.execute('delete from creature_loot_template where Entry=161180')
for new, _, name in ITEMS:
    w.execute('insert into creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) values (161180,%s,0,100,0,1,0,1,1,%s)', (new, name))
print('items', len(ITEMS), 'hotfix rows', len(out))
