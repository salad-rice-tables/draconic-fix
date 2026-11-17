"""Worldforged items the CoA pickups hand out but this server does not have yet -> Midnight hotfix rows (item 9760001+).
Per Ascension item (from the Exiles / Worldforged-data supplemental set in data/ascension-data):
  name, quality, item level, required level, class / subclass / inventory type  <- worldforged/.../dump_zips_wf_items.csv
  icon                                                                         <- exiles-db-export/.../icon-map.csv (inv_* name -> FileDataID via the community listfile)
  everything else (armor, damage, sounds ...)                                  <- cloned from the closest existing Worldforge item (9700001+) of the same class / subclass / inventory type
Like the first import it carries no per-item stats (the Exiles tooltips are free text); tooltips show name, quality, levels, armor / damage of the template.
Writes hotfixes.item / item_sparse + hotfix_data push 1952400, and world.worldforge_item rows. undo: python coa_worldforged_items.py undo
usage: python coa_worldforged_items.py [apply|undo]   (needs data/coa/worldforged_pickups_parsed.json + cow_scratch from the pickups import)"""
import sys, os, gzip, glob, csv, io, json, collections
sys.path.append("C:/Users/<user>/AppData/Roaming/Python/Python314/site-packages")
import pymysql

SUP = r'C:\WowServer\Custom\data\ascension-data\repo\supplemental'
LF = r'C:\WowServer\Custom\data\listfile\community-listfile.csv'
FIRST, PUSH, UBASE, BUILD = 9760001, 1952400, 4200000000, 69933
H_ITEM, H_SPARSE = 1344507586, 2442913102
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), autocommit=True, charset='utf8mb4')
q = c.cursor()


def undo():
    q.execute("select RecordID from hotfixes.hotfix_data where ID=%s", (PUSH,)); ids = sorted({r[0] for r in q.fetchall()})
    if ids:
        q.execute("delete from hotfixes.item where ID in %s", (tuple(ids),)); q.execute("delete from hotfixes.item_sparse where ID in %s", (tuple(ids),))
        q.execute("delete from world.worldforge_item where item in %s", (tuple(ids),))
    q.execute("delete from hotfixes.hotfix_data where ID=%s", (PUSH,)); print('removed', len(ids), 'items')


def read_gz(pattern):
    return gzip.open(glob.glob(SUP + pattern, recursive=True)[0], 'rt', encoding='utf-8', errors='ignore').read()


def apply():
    undo()
    attrs = {int(r['item_id']): r for r in csv.DictReader(io.StringIO(read_gz('/worldforged/*/data/provenance/dump_zips_wf_items.csv.gz'))) if r['item_id'].isdigit()}
    icons = {}
    for r in csv.reader(io.StringIO(read_gz('/exiles-db-export/*/icon-map.csv.gz'))):
        if len(r) >= 3 and r[0] == 'item' and r[1].isdigit(): icons[int(r[1])] = r[2].lower()
    path2id = {}
    for l in open(LF, encoding='utf-8'):
        i, _, n = l.rstrip('\n').partition(';')
        if n.lower().startswith('interface/icons/'): path2id[n.lower()] = int(i)
    q.execute("use cow_scratch"); q.execute("select distinct Item from gameobject_loot_template"); loot = {r[0] for r in q.fetchall()}
    q.execute("select ascension_id from world.worldforge_item"); have = {r[0] for r in q.fetchall()}
    todo = sorted(loot - have)
    # templates: existing Worldforge items with their class / subclass / inventory type / item level
    q.execute("select i.ID,i.ClassID,i.SubclassID,i.InventoryType,s.ItemLevel from hotfixes.item i join hotfixes.item_sparse s on s.ID=i.ID where i.ID between 9700001 and 9701383 or (i.ID between 9702000 and 9759999 and i.ClassID in (0,15))")
    tpl = collections.defaultdict(list)
    for iid, cl, sc, inv, il in q.fetchall(): tpl[(cl, sc, inv)].append((il, iid)); tpl[(cl, None, inv)].append((il, iid))
    q.execute("show columns from hotfixes.item"); icols = [r[0] for r in q.fetchall()]
    q.execute("show columns from hotfixes.item_sparse"); scols = [r[0] for r in q.fetchall()]
    n = skipped = noicon = 0; nid = FIRST; unique = UBASE
    exiles = json.load(open(r'C:\WowServer\Custom\data\coa\worldforged_missing_exiles.json')) if os.path.exists(r'C:\WowServer\Custom\data\coa\worldforged_missing_exiles.json') else {}
    for a in todo:
        r = attrs.get(a)
        if (not r or not r['class'].lstrip('-').isdigit()) and str(a) in exiles:   # no client item cache row: use the Exiles page (scroll = consumable 0/2, anything else = miscellaneous 15/0)
            e = exiles[str(a)]; nm = e.get('name') or ''
            r = {'item_name': nm, 'item_level': str(e.get('default_level') or 35), 'req_level': '0', 'quality': str(e.get('quality') or 1), 'class': '0' if nm.startswith('Worldforged Scroll') else '15', 'subclass': '2' if nm.startswith('Worldforged Scroll') else '0', 'inv_type': '0'}
        if not r or not r['class'].lstrip('-').isdigit() or not r['inv_type'].lstrip('-').isdigit(): skipped += 1; continue
        cl, sc, inv = int(r['class']), int(r['subclass'] or 0), int(r['inv_type'])
        il = int(r['item_level'] or 1); req = int(r['req_level'] or 0); qual = int(r['quality'] or 1)
        cand = tpl.get((cl, sc, inv)) or tpl.get((cl, None, inv))
        if not cand: skipped += 1; continue
        t = min(cand, key=lambda x: abs(x[0] - il))[1]
        q.execute("select * from hotfixes.item where ID=%s", (t,)); irow = dict(zip(icols, q.fetchone()))
        q.execute("select * from hotfixes.item_sparse where ID=%s", (t,)); srow = dict(zip(scols, q.fetchone()))
        irow['ID'] = nid; srow['ID'] = nid
        ic = path2id.get('interface/icons/' + icons.get(a, '') + '.blp')
        if ic: irow['IconFileDataID'] = ic
        else: noicon += 1
        srow.update({'Display': r['item_name'], 'Description': '', 'ItemLevel': il, 'RequiredLevel': req, 'OverallQualityID': qual})
        for tab, row in (('item', irow), ('item_sparse', srow)):
            q.execute("insert into hotfixes.%s (%s) values (%s)" % (tab, ','.join('`' + k + '`' for k in row), ','.join(['%s'] * len(row))), list(row.values()))
        for h in (H_ITEM, H_SPARSE):
            q.execute("insert into hotfixes.hotfix_data (ID,UniqueID,TableHash,RecordID,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)", (PUSH, unique, h, nid, BUILD)); unique += 1
        q.execute("insert into world.worldforge_item (item,name,zone,x,y,quality,ascension_id,map,wx,wy,zone_id,object_name,spawn_guid) values (%s,%s,'',0,0,%s,%s,0,0,0,0,'',0)", (nid, r['item_name'], qual, a))
        nid += 1; n += 1
    print('built', n, 'items;', skipped, 'skipped (no attributes / no template);', noicon, 'without icon (template icon kept)')


if __name__ == '__main__':
    undo() if sys.argv[1:2] == ['undo'] else apply()
