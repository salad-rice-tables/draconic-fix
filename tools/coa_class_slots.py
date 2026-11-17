"""Turn the 13 selectable creation-screen class slots into CoA classes (client cannot list extra class ids).
 hotfixes.chr_classes ids 1..13 : name/description/colour/icon of the CoA class (push 1950400); Filename stays the retail token so the client UI keeps working
 world                          : every race can pick every slot, DK/DH/Evoker start like Mage (level 1, normal start zone)
 client                         : class icon BLPs (files/ + mappings/coa_class_icons.txt) and data/coa/coa_class_slots.json for the glue override + Lua
Writes sql/20261106_class_slots.sql (+_undo, only restores nothing: base DB2 rows come back when the hotfix rows are deleted). usage: python coa_class_slots.py"""
import csv, json, os, struct, pymysql
from PIL import Image

ROOT = r'C:\WowServer\Custom'
CLIENT = r'C:\Games\Wow\World of Warcraft\_retail_'
ICONS = os.path.join(ROOT, 'data', 'ascension-data', 'repo', 'supplemental', 'exiles-db', 'assets', 'class-icons')
PUSH, BUILD = 1950400, 69933
H_CLASS = 4119371148
# slot id -> (coa key used by coa_kits.lua, display name, icon png, description, colour r,g,b, roles text)
SLOTS = {
    1: ('barbarian', 'Barbarian', 'barbarian', 'A savage warrior who lives for the fight. Rage, raw strength and a fury that grows with every blow.', 199, 86, 36),
    2: ('suncleric', 'Sun Cleric', 'sun_cleric', 'Healer and avenger of the sun. Heals allies and burns the wicked with radiant fire.', 255, 215, 90),
    3: ('ranger', 'Ranger', 'ranger', 'A deadly archer of the wild frontier. Strikes from afar with bow, trap and companion.', 120, 190, 70),
    4: ('venomancer', 'Venomancer', 'venomancer', 'Poison in every blade and every breath. Stacks venom and cripples whatever it touches.', 86, 180, 90),
    5: ('cultist', 'Cultist', 'cultist', 'Whispers of the Old Gods twist mind and flesh. Madness is a weapon.', 160, 90, 190),
    6: ('necromancer', 'Necromancer', 'necromancer', 'Commands the dead. Raises skeletal minions, abominations and wyrms, spreads plague and wields the cold of the grave. Minions are held by Life Force; Runic Power fuels the dark arts.', 148, 130, 201),
    7: ('witchdoctor', 'Witch Doctor', 'witch_doctor', 'Voodoo, hexes and spirits of the loa. Poison, totems and curses in one toolkit.', 70, 160, 140),
    8: ('runemaster', 'Runemaster', 'runemaster', 'Carves arcane runes of power and protection and bends them to his will.', 70, 140, 230),
    9: ('bloodmage', 'Bloodmage', 'bloodmage', 'Spends his own blood for power. Drains, burns and bleeds the enemy dry.', 190, 30, 50),
    10: ('monk', 'Templar', 'templar', 'Holy warrior of the order. Fights with faith, discipline and blessed steel.', 240, 200, 140),
    11: ('primalist', 'Primalist', 'primalist', 'Wields the raw fury of the wilds. Beast, storm and thorn answer his call.', 80, 150, 40),
    12: ('demonhunter', 'Felsworn', 'felsworn', 'Bound to fel power. Hunts demons with their own fire.', 110, 220, 60),
    13: ('chronomancer', 'Chronomancer', 'chronomancer', 'Bends time itself to slow foes and mend allies.', 90, 190, 230),
}


def q(v):
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


def write_blp(img, path):
    img = img.convert('RGBA').resize((64, 64), Image.LANCZOS)
    px = bytearray()
    for r, g, b, a in img.get_flattened_data() if hasattr(img, 'get_flattened_data') else img.getdata():
        px += bytes((b, g, r, a))
    off = 4 + 4 + 4 + 4 + 4 + 64 + 64 + 1024
    hdr = b'BLP2' + struct.pack('<IBBBB', 1, 3, 8, 7, 0) + struct.pack('<II', 64, 64)
    hdr += struct.pack('<16I', off, *([0] * 15)) + struct.pack('<16I', len(px), *([0] * 15)) + bytes(1024)
    open(path, 'wb').write(hdr + bytes(px))


# --- icons -> client files (ids 9500200+)
out_dir = os.path.join(CLIENT, 'files', 'Interface', 'Icons', 'coa')
os.makedirs(out_dir, exist_ok=True)
lines, ids = [], {}
for slot, v in SLOTS.items():
    fid = 9500200 + slot
    write_blp(Image.open(os.path.join(ICONS, v[2] + '.png')), os.path.join(out_dir, f'class_{v[2]}.blp'))
    lines.append(f'{fid};Interface/Icons/coa/class_{v[2]}.blp')
    ids[slot] = fid
open(os.path.join(CLIENT, 'mappings', 'coa_class_icons.txt'), 'w', newline='\n').write('\n'.join(lines) + '\n')
json.dump({str(s): {'coa': v[0], 'name': v[1], 'fileDataID': ids[s], 'description': v[3]} for s, v in SLOTS.items()},
          open(os.path.join(ROOT, 'data', 'coa', 'coa_class_slots.json'), 'w', encoding='utf-8'), indent=1)

# --- hotfix rows for chr_classes 1..13
rows = list(csv.reader(open(os.path.join(ROOT, 'data', 'wago', 'ChrClasses.csv'), encoding='utf-8')))
hdr = rows[0]
cols = ['Name', 'Filename', 'NameMale', 'NameFemale', 'PetNameToken', 'Description', 'RoleInfoString', 'DisabledString', 'HyphenatedNameMale', 'HyphenatedNameFemale',
        'CreateScreenFileDataID', 'SelectScreenFileDataID', 'IconFileDataID', 'LowResScreenFileDataID', 'Flags', 'StartingLevel', 'SpellTextureBlobFileDataID', 'ArmorTypeMask',
        'CharStartKitUnknown901', 'MaleCharacterCreationVisualFallback', 'MaleCharacterCreationIdleVisualFallback', 'FemaleCharacterCreationVisualFallback',
        'FemaleCharacterCreationIdleVisualFallback', 'CharacterCreationIdleGroundVisualFallback', 'CharacterCreationGroundVisualFallback',
        'AlteredFormCharacterCreationIdleVisualFallback', 'CharacterCreationAnimLoopWaitTimeMsFallback', 'CinematicSequenceID', 'DefaultSpec', 'ID', 'HasStrengthBonus',
        'PrimaryStatPriority', 'DisplayPower', 'RangedAttackPowerPerAgility', 'AttackPowerPerAgility', 'AttackPowerPerStrength', 'SpellClassSet', 'ClassColorR', 'ClassColorG',
        'ClassColorB', 'RolesMask', 'DamageBonusStat', 'HasRelicSlot', 'VerifiedBuild']
base = {int(r[hdr.index('ID')]): r for r in rows[1:]}
mage = base[8]
sql = ["-- CoA classes on the 13 creation slots (coa_class_slots.py). push %d" % PUSH, "DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = %d;" % PUSH,
       "DELETE FROM `hotfixes`.`chr_classes` WHERE `ID` IN (%s);" % ','.join(map(str, SLOTS))]
vals = []
for slot, v in SLOTS.items():
    r = list(base[slot])

    def setc(n, x):
        r[hdr.index(n)] = str(x)
    for n in ('Name_lang', 'Name_male_lang', 'Name_female_lang'):
        setc(n, v[1])
    setc('Hyphenated_name_male_lang', v[1]); setc('Hyphenated_name_female_lang', v[1])
    setc('Description_lang', v[3]); setc('DisabledString_lang', 'This class is not available.')
    setc('ClassColorR', v[4]); setc('ClassColorG', v[5]); setc('ClassColorB', v[6])
    setc('IconFileDataID', ids[slot])
    if slot in (6, 12, 13):                     # former hero / race-locked classes: start like a normal class
        for n in ('Flags', 'StartingLevel', 'CinematicSequenceID'):
            setc(n, mage[hdr.index(n)])
        setc('StartingLevel', 1)
    vals.append('(' + ', '.join(q(x) if i < 10 else x for i, x in enumerate(r)) + ', %d)' % BUILD)
sql.append("INSERT INTO `hotfixes`.`chr_classes` (`%s`) VALUES\n%s;" % ('`, `'.join(cols), ",\n".join(vals)))
sql.append("INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES\n" +
           ",\n".join("(%d, %d, %d, %d, 1, %d)" % (PUSH, 3300000000 + s, H_CLASS, s, BUILD) for s in SLOTS) + ";")
# remove the experimental class 15 (Necromancer now lives on slot 6)
sql += ["DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` IN (1950300, 1950320);", "DELETE FROM `hotfixes`.`chr_classes` WHERE `ID` = 15;",
        "DELETE FROM `hotfixes`.`chr_specialization` WHERE `ClassID` = 15;", "DELETE FROM `hotfixes`.`chr_classes_x_power_types` WHERE `ID` = 9501;",
        "DELETE FROM `hotfixes`.`chr_class_ui_display` WHERE `ID` = 9501;",
        "DELETE FROM `world`.`class_expansion_requirement` WHERE `ClassID` = 15;", "DELETE FROM `world`.`playercreateinfo` WHERE `class` = 15;",
        "DELETE FROM `world`.`playercreateinfo_action` WHERE `class` = 15;", "DELETE FROM `world`.`player_classlevelstats` WHERE `class` = 15;"]
# world: every race x every slot; DK/DH/Evoker start like Mage
sql += ["DELETE FROM `world`.`class_expansion_requirement` WHERE `ClassID` BETWEEN 1 AND 13;",
        "INSERT INTO `world`.`class_expansion_requirement` (`ClassID`, `RaceID`, `ActiveExpansionLevel`, `AccountExpansionLevel`) SELECT c.n, m.RaceID, 0, 0 FROM (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13) c JOIN (SELECT DISTINCT race AS RaceID FROM `world`.`playercreateinfo` WHERE class = 8) m;",
        "DELETE FROM `world`.`playercreateinfo` WHERE `class` IN (6, 12, 13);",
        "INSERT IGNORE INTO `world`.`playercreateinfo` SELECT m.race, c.n, m.map, m.position_x, m.position_y, m.position_z, m.orientation, m.npe_map, m.npe_position_x, m.npe_position_y, m.npe_position_z, m.npe_orientation, m.npe_transport_guid, m.intro_movie_id, m.intro_scene_id, m.npe_intro_scene_id FROM `world`.`playercreateinfo` m JOIN (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13) c WHERE m.class = 8;",
        "DELETE FROM `world`.`playercreateinfo_action` WHERE `class` IN (6, 12, 13);",
        "INSERT IGNORE INTO `world`.`playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`) SELECT m.race, c.n, m.button, m.action, m.type FROM `world`.`playercreateinfo_action` m JOIN (SELECT 6 n UNION SELECT 12 UNION SELECT 13) c WHERE m.class = 8;",
        "INSERT IGNORE INTO `world`.`player_classlevelstats` (`class`, `level`, `str`, `agi`, `sta`, `inte`, `spi`, `VerifiedBuild`) SELECT c.n, m.level, m.str, m.agi, m.sta, m.inte, m.spi, m.VerifiedBuild FROM `world`.`player_classlevelstats` m JOIN (SELECT 6 n UNION SELECT 12 UNION SELECT 13) c WHERE m.class = 8;"]
open(os.path.join(ROOT, 'sql', '20261106_class_slots.sql'), 'w', encoding='utf-8').write("\n".join(sql) + "\n")
open(os.path.join(ROOT, 'sql', '20261106_class_slots_undo.sql'), 'w', encoding='utf-8').write(
    "-- undo: remove the hotfix rows (base DB2 class rows return); world rows keep the extra race/class combos (harmless)\n"
    "DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = %d;\nDELETE FROM `hotfixes`.`chr_classes` WHERE `ID` IN (%s);\n" % (PUSH, ','.join(map(str, SLOTS))))
db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), client_flag=pymysql.constants.CLIENT.MULTI_STATEMENTS)
cur = db.cursor()
cur.execute("\n".join(sql))
while cur.nextset():
    pass
db.commit()
cur.execute('select count(*) from world.class_expansion_requirement where ClassID between 1 and 13'); print('class/race rows', cur.fetchone())
cur.execute('select class,count(*) from world.playercreateinfo group by class'); print(cur.fetchall())
cur.execute('select class,count(*) from world.player_classlevelstats group by class'); print(cur.fetchall())
cur.execute('select ID,Name,Filename,StartingLevel from hotfixes.chr_classes order by ID'); print(cur.fetchall())
