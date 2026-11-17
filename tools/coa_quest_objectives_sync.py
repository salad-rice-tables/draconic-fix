"""Sync world.quest_objectives with the retail 12.1.5 QuestObjective DB2 export.

Why: the bot quest audit flagged objectives that differ from the reference DB, and the whole
table still has ~2000 objectives whose Amount is 0 or whose ObjectID is 0 (such a quest either
completes instantly or can never complete).  The retail DB2 export is the authoritative source.

Safety rules (see the wow-retail-sync skill):
  * only quests that exist in the retail export are touched,
  * only quests whose objective COUNT matches retail are touched (a 1:1 OrderIndex mapping,
    so no row is invented or dropped),
  * every touched row is copied to world.quest_objectives_bak_<date> first,
  * the script writes the forward SQL and the exact undo SQL.

usage:
  python tools/coa_quest_objectives_sync.py            # dry run, prints the diff
  python tools/coa_quest_objectives_sync.py --apply    # writes sql + applies nothing
  python tools/coa_quest_objectives_sync.py --file F   # also include quests listed in a file
"""
import argparse
import collections
import csv
import os
import sys

import pymysql

DB = dict(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), charset='utf8mb4')
CSV_PATH = r'C:\WowServer\Custom\data\wago\QuestObjective_full.csv'
SQL_DIR = r'C:\WowServer\Custom\sql'
TAG = '-20261112'
DATE = '20261112'

# objective types whose Amount / ObjectID is meaningful and must not be 0
BROKEN_SQL = ("(o.Amount=0 OR o.ObjectID=0) AND o.Type NOT IN (15)")

retail = collections.defaultdict(list)
with open(CSV_PATH, encoding='utf-8-sig', newline='') as f:
    for r in csv.DictReader(f):
        retail[int(r['QuestID'])].append(dict(
            id=int(r['ID']), type=int(r['Type']), objectid=int(r['ObjectID']),
            amount=int(r['Amount']), order=int(r['OrderIndex']),
            flags=int(r['Flags']), storage=int(r['StorageIndex'])))

db = pymysql.connect(**DB)
cur = db.cursor()

cur.execute("SELECT DISTINCT o.QuestID FROM world.quest_objectives o JOIN world.quest_template t ON t.ID=o.QuestID "
            "WHERE " + BROKEN_SQL)
quests = sorted(r[0] for r in cur.fetchall())
# quests the bot audit reported as "objective differs from the reference DB" (may be valid values
# that simply differ, e.g. a placeholder amount repeated on every objective)
try:
    import json
    rep = r'C:\WowServer\Custom\reports\quest_qa\quest_qa_issues.json'
    for i in json.load(open(rep, encoding='utf-8'))['issues']:
        if i['category'] == 'quest_objectives_diff' and i['quest'] not in quests:
            quests.append(i['quest'])
    quests.sort()
except Exception as e:
    print('qa report not merged:', e)

# a custom CoA object id must never be replaced with a retail one
def is_custom_object(world_row):
    return world_row['objectid'] >= 90000000

chars = []
missing_retail = same = count_mismatch = 0
for q in quests:
    r = retail.get(q)
    cur.execute('SELECT ID,`Order`,Type,StorageIndex,ObjectID,Amount FROM world.quest_objectives WHERE QuestID=%s ORDER BY `Order`,ID', (q,))
    w = [dict(id=a, order=b, type=c, storage=d, objectid=e, amount=f) for a, b, c, d, e, f in cur.fetchall()]
    if not r:
        missing_retail += 1
        continue
    if len(r) != len(w):
        count_mismatch += 1
        continue
    rm = {x['order']: x for x in r}
    if sorted(x['order'] for x in r) != sorted(x['order'] for x in w):
        count_mismatch += 1
        continue
    diffs = []
    for x in w:
        y = rm[x['order']]
        if (x['type'], x['objectid'], x['amount'], x['storage']) != (y['type'], y['objectid'], y['amount'], y['storage']):
            if is_custom_object(x) and x['objectid'] != y['objectid']:
                print('  q%d order %d: kept custom object %d (retail %d)' % (q, x['order'], x['objectid'], y['objectid']))
                continue
            diffs.append((x, y))
    if diffs:
        chars.append((q, diffs))
    else:
        same += 1

print('quests with a broken objective: %d' % len(quests))
print('  not in retail export         : %d' % missing_retail)
print('  objective count differs      : %d' % count_mismatch)
print('  identical to retail          : %d' % same)
print('  fixable (1:1 mapping, differ): %d (%d rows)' % (len(chars), sum(len(d) for _, d in chars)))

cur.execute('SELECT ID,LogTitle FROM world.quest_template')
titles = dict(cur.fetchall())
for q, diffs in chars:
    cur.execute('SELECT Type FROM world.quest_objectives WHERE QuestID=%s ORDER BY `Order`,ID', (q,))
    print('\nq%d %s' % (q, titles.get(q, '?')))
    for x, y in diffs:
        print('   order %d: (%d,%d,%d,st%d) -> retail (%d,%d,%d,st%d)' % (
            x['order'], x['type'], x['objectid'], x['amount'], x['storage'],
            y['type'], y['objectid'], y['amount'], y['storage']))

if not chars:
    db.close()
    sys.exit(0)

fwd = os.path.join(SQL_DIR, '20261112_quest_objectives_retail.sql')
undo = os.path.join(SQL_DIR, '20261112_quest_objectives_retail_undo.sql')
if '--apply' in sys.argv or '--write' in sys.argv:
    qs = ','.join(str(q) for q, _ in chars)
    with open(fwd, 'w', encoding='utf-8', newline='\n') as f:
        f.write('-- quest objectives synced to the retail 12.1.5 QuestObjective export\n')
        f.write('-- quests: %s\n' % qs)
        f.write('CREATE TABLE IF NOT EXISTS `quest_objectives_bak_%s` LIKE `quest_objectives`;\n' % DATE)
        f.write('INSERT IGNORE INTO `quest_objectives_bak_%s` SELECT * FROM `quest_objectives` WHERE `QuestID` IN (%s);\n' % (DATE, qs))
        for q, diffs in chars:
            for x, y in diffs:
                f.write('UPDATE `quest_objectives` SET `Type`=%d, `ObjectID`=%d, `Amount`=%d, `StorageIndex`=%d, `VerifiedBuild`=%d '
                        'WHERE `ID`=%d AND `QuestID`=%d;\n' % (y['type'], y['objectid'], y['amount'], y['storage'], int(TAG), x['id'], q))
    with open(undo, 'w', encoding='utf-8', newline='\n') as f:
        f.write('-- undo of 20261112_quest_objectives_retail.sql (exact previous values)\n')
        for q, diffs in chars:
            for x, y in diffs:
                f.write('UPDATE `quest_objectives` SET `Type`=%d, `ObjectID`=%d, `Amount`=%d, `StorageIndex`=%d '
                        'WHERE `ID`=%d AND `QuestID`=%d;\n' % (x['type'], x['objectid'], x['amount'], x['storage'], x['id'], q))
    print('\nwrote %s and %s' % (fwd, undo))
db.close()
