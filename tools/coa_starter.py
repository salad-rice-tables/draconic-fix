"""CoA starter gear + starting action bars for the 13 class slots.
 - 75 CoA starter items (exiles item_character_creation, ids 2000000+) -> hotfix item/item_sparse/item_modified_appearance (push 1950600), look = retail template item of the same
   class/subclass/inventory type
 - lua/coa_starter.lua : COA_STARTER[key] = {itemId, ...}  (granted + equipped on first login by coa_starter_main.lua)
 - world.playercreateinfo_action for the 13 slots = the first level-1/3/5 spells of the class schedule (replaces the old Mage bars)
usage: python coa_starter.py"""
import csv, gzip, json, os, re, pymysql

ROOT = r'C:\WowServer\Custom'
csv.field_size_limit(10 ** 9)
PUSH, BUILD = 1950600, 69933
H_ITEM, H_SPARSE, H_MOD = 1344507586, 2442913102, 3834752085
# CoA class id -> class key used by coa_kits / schedule
CID_KEY = {12: 'barbarian', 13: 'witchdoctor', 14: 'demonhunter', 15: 'witchhunter', 16: 'stormbringer', 17: 'knightofxoroth', 18: 'guardian', 19: 'monk',
           20: 'sonofarugal', 21: 'ranger', 22: 'chronomancer', 23: 'necromancer', 24: 'pyromancer', 25: 'cultist', 26: 'starcaller', 27: 'suncleric',
           28: 'tinker', 29: 'venomancer', 30: 'reaper', 31: 'primalist', 32: 'runemaster'}
SLOT_KEY = json.load(open(os.path.join(ROOT, 'data', 'coa', 'coa_class_slots.json'), encoding='utf-8'))      # slot -> {coa,...}
INV = {'head': 1, 'neck': 2, 'shoulder': 3, 'body': 4, 'chest': 5, 'waist': 6, 'legs': 7, 'feet': 8, 'wrist': 9, 'hands': 10, 'finger': 11, 'trinket': 12,
       'weapon': 13, 'shield': 14, 'ranged': 15, 'cloak': 16, 'two_hand': 17, 'bag': 18, 'tabard': 19, 'robe': 20, 'main_hand': 21, 'off_hand': 22, 'holdable': 23,
       'ammo': 24, 'thrown': 25, 'ranged_right': 26, 'relic': 28}
EQUIP_SLOT = {1: 0, 2: 1, 3: 2, 4: 3, 5: 4, 20: 4, 6: 5, 7: 6, 8: 7, 9: 8, 10: 9, 11: 10, 12: 12, 16: 14, 13: 15, 17: 15, 21: 15, 14: 16, 22: 16, 23: 16, 15: 17, 26: 17, 25: 17, 19: 18}
QUAL = {'poor': 0, 'common': 1, 'uncommon': 2, 'rare': 3, 'epic': 4, 'legendary': 5}
WAGO = os.path.join(ROOT, 'data', 'wago')


def q(v):
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


# starter items
EX = os.path.join(ROOT, 'data', 'ascension-data', 'exiles', 'tables')
pairs = [(int(a), int(b)) for a, b in list(csv.reader(gzip.open(os.path.join(EX, 'item_character_creation.csv.gz'), 'rt', encoding='utf-8')))[1:]]
want = {i for i, _ in pairs}
items = {}
with gzip.open(os.path.join(EX, 'items.csv.gz'), 'rt', encoding='utf-8') as f:
    r = csv.reader(f)
    h = next(r)
    for x in r:
        if x and x[0].isdigit() and int(x[0]) in want:
            items[int(x[0])] = dict(zip(h, x))

# retail templates: (class, subclass, inv) -> (item row, appearance id)
app = {}
for r_ in csv.DictReader(open(os.path.join(WAGO, 'ItemModifiedAppearance.csv'), encoding='utf-8')):
    if r_['ItemAppearanceModifierID'] == '0':
        app.setdefault(int(r_['ItemID']), int(r_['ItemAppearanceID']))
tmpl = {}
for r_ in csv.DictReader(open(os.path.join(WAGO, 'Item.csv'), encoding='utf-8')):
    iid = int(r_['ID'])
    if iid in app and 1000 < iid < 60000:
        tmpl.setdefault((int(r_['ClassID']), int(r_['SubclassID']), int(r_['InventoryType'])), (r_, app[iid]))

item_rows, sparse_rows, mod_rows, hot, granted = [], [], [], [], {}
sp_cols = ("`ID`, `Description`, `Display3`, `Display2`, `Display1`, `Display`, `ExpansionID`, `DmgVariance`, `LimitCategory`, `DurationInInventory`, `QualityModifier`, `BagFamily`, `StartQuestID`, `LanguageID`, `ItemRange`, "
           + ", ".join(f"`StatPercentageOfSocket{i}`" for i in range(1, 11)) + ", " + ", ".join(f"`StatPercentEditor{i}`" for i in range(1, 11)) + ", "
           + ", ".join(f"`StatModifierBonusStat{i}`" for i in range(1, 11)) + ", `Stackable`, `MaxCount`, `MinReputation`, `RequiredAbility`, `AllowableRace1`, `AllowableRace2`, `SellPrice`, `BuyPrice`, `VendorStackCount`, `PriceVariance`, `PriceRandomValue`, "
           "`Flags1`, `Flags2`, `Flags3`, `Flags4`, `Flags5`, `FactionRelated`, `ModifiedCraftingReagentItemID`, `ContentTuningID`, `PlayerLevelToItemLevelCurveID`, `ItemLevelOffsetCurveID`, `ItemLevelOffsetItemLevel`, `ItemSquishEraID`, `ItemNameDescriptionID`, "
           "`RequiredTransmogHoliday`, `RequiredHoliday`, `GemProperties`, `SocketMatchEnchantmentId`, `TotemCategoryID`, `InstanceBound`, `ZoneBound1`, `ZoneBound2`, `ItemSet`, `LockID`, `PageID`, `ItemDelay`, `MinFactionID`, `RequiredSkillRank`, `RequiredSkill`, `ItemLevel`, "
           "`AllowableClass`, `ArtifactID`, `SpellWeight`, `SpellWeightCategory`, `SocketType1`, `SocketType2`, `SocketType3`, `SheatheType`, `Material`, `PageMaterialID`, `Bonding`, `DamageDamageType`, `ContainerSlots`, `RequiredPVPMedal`, `RequiredPVPRank`, `RequiredLevel`, `InventoryType`, `OverallQualityID`, `VerifiedBuild`")
for iid, it in sorted(items.items()):
    inv = INV.get(it['inventory_type'], 0)
    cls, sub = int(it['class'] or 0), int(it['sub_class'] or 0)
    t = tmpl.get((cls, sub, inv)) or next((v for k, v in tmpl.items() if k[0] == cls and k[2] == inv), None)
    if not t:
        print('no template for', iid, it['name'], cls, sub, inv)
        continue
    tr, ap = t
    item_rows.append(f"({iid}, {cls}, {sub}, {it['material'] or 0}, {inv}, {tr['SheatheType']}, -1, {tr['IconFileDataID']}, {tr['ItemGroupSoundsID']}, 0, 0, 0, 0, 0, 0, 0, {BUILD})")
    q_ = QUAL.get(it['quality'], 1)
    vals = [iid, q(''), q(''), q(''), q(''), q(it['name']), 0, 1, 0, 0, 0, 0, 0, 0, 0] + [0] * 10 + [0] * 10 + [-1] * 10 + \
           [1, 0, 0, 0, -1, -1, int(it['sell_price'] or 0), int(it['buy_price'] or 0), 1, 1, 0.9921, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            int(it['delay_ms'] or 0), 0, 0, 0, int(it['item_level'] or 1), -1, 0, 0, 0, 0, 0, 0, 0, int(it['material'] or 0), 0, 0, 0, 0, 0, 0, int(it['required_level'] or 0), inv, q_, BUILD]
    sparse_rows.append('(' + ', '.join(str(v) for v in vals) + ')')
    mod_rows.append(f"({iid}, {iid}, 0, {ap}, 0, 0, 0, {BUILD})")
    hot += [(H_ITEM, iid), (H_SPARSE, iid), (H_MOD, iid)]
for iid, cid in pairs:
    key = CID_KEY.get(cid)
    if key and iid in items and INV.get(items[iid]['inventory_type'], 0):
        granted.setdefault(key, []).append((iid, INV[items[iid]['inventory_type']]))

ids = ','.join(str(i) for i in items)
sql = [f"-- CoA starter items (coa_starter.py) push {PUSH}", f"DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = {PUSH};",
       f"DELETE FROM `hotfixes`.`item` WHERE `ID` IN ({ids});", f"DELETE FROM `hotfixes`.`item_sparse` WHERE `ID` IN ({ids});", f"DELETE FROM `hotfixes`.`item_modified_appearance` WHERE `ID` IN ({ids});"]
sql.append("INSERT INTO `hotfixes`.`item` (`ID`, `ClassID`, `SubclassID`, `Material`, `InventoryType`, `SheatheType`, `SoundOverrideSubclassID`, `IconFileDataID`, `ItemGroupSoundsID`, `ContentTuningID`, `ModifiedCraftingReagentItemID`, `Unknown1200`, `CraftingQualityID`, `ItemSquishEraID`, `RecraftReagentCountPercentage`, `OrderSource`, `VerifiedBuild`) VALUES\n" + ",\n".join(item_rows) + ";")
sql.append(f"INSERT INTO `hotfixes`.`item_sparse` ({sp_cols}) VALUES\n" + ",\n".join(sparse_rows) + ";")
sql.append("INSERT INTO `hotfixes`.`item_modified_appearance` (`ID`, `ItemID`, `ItemAppearanceModifierID`, `ItemAppearanceID`, `OrderIndex`, `TransmogSourceTypeEnum`, `Flags`, `VerifiedBuild`) VALUES\n" + ",\n".join(mod_rows) + ";")
sql.append("INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES\n" + ",\n".join(f"({PUSH}, {3600000000 + n}, {h_}, {rid}, 1, {BUILD})" for n, (h_, rid) in enumerate(hot)) + ";")
# action bars: first spells of each slot class (schedule lines "{id, name, level}")
sched = open(os.path.join(ROOT, 'lua', 'coa_class_schedule.lua'), encoding='utf-8').read()
bars = {}
for key, body in re.findall(r'^  (\w+) = \{\n(.*?)^  \},', sched, re.M | re.S):
    bars[key] = [int(x) for x, _, _ in re.findall(r'\{(\d+), "(.*?)", (\d+)\}', body)][:12]
sql += ["DELETE FROM `world`.`playercreateinfo_action` WHERE `class` BETWEEN 1 AND 13;"]
act = []
for slot, v in SLOT_KEY.items():
    for n, sid in enumerate(bars.get(v['coa'], [])):
        act.append(f"(`race`, {slot}, {n}, {sid}, 0)")
if act:
    sql.append("INSERT INTO `world`.`playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`) SELECT r.race, c.class, c.button, c.action, c.type FROM (SELECT DISTINCT race FROM `world`.`playercreateinfo` WHERE class = 8) r JOIN (" +
                " UNION ALL ".join(f"SELECT {s} AS class, {n} AS button, {sid} AS action, 0 AS type" for s, v in SLOT_KEY.items() for n, sid in enumerate(bars.get(v['coa'], []))) + ") c;")
open(os.path.join(ROOT, 'sql', '20261106_coa_starter.sql'), 'w', encoding='utf-8').write("\n".join(sql) + "\n")
open(os.path.join(ROOT, 'sql', '20261106_coa_starter_undo.sql'), 'w', encoding='utf-8').write(
    f"DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = {PUSH};\nDELETE FROM `hotfixes`.`item` WHERE `ID` IN ({ids});\nDELETE FROM `hotfixes`.`item_sparse` WHERE `ID` IN ({ids});\n"
    f"DELETE FROM `hotfixes`.`item_modified_appearance` WHERE `ID` IN ({ids});\n-- action bars: playercreateinfo_action classes 1..13 were Mage copies before (copy class 8 rows back if needed)\n")
lua = ['-- CoA starter gear per class key (tools/coa_starter.py): {itemId, inventoryType}', 'COA_STARTER = {']
for key, lst in granted.items():
    lua.append(f'  {key} = {{' + ', '.join(f'{{{i}, {t}}}' for i, t in lst) + '},')
lua += ['}', 'COA_EQUIP_SLOT = {' + ', '.join(f'[{k}] = {v}' for k, v in EQUIP_SLOT.items()) + '}']
open(os.path.join(ROOT, 'lua', 'coa_starter.lua'), 'w', encoding='utf-8').write('\n'.join(lua) + '\n')
db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS)
cur = db.cursor()
cur.execute("\n".join(sql))
while cur.nextset():
    pass
db.commit()
cur.execute('select count(*) from world.playercreateinfo_action where class between 1 and 13'); print('actions', cur.fetchone())
print('items', len(item_rows), 'classes with gear', {k: len(v) for k, v in granted.items()})
