"""Exact CoA spell icons from the CoA client itself.
 Spell.dbc (area-52/patch-D) spell -> SpellIconID -> SpellIcon.dbc (patch-S) path -> BLP from the client MPQs.
 Retail icon (path in the community listfile) -> its FileDataID; otherwise the BLP is copied into <client>/files with a new FileDataID (9600000+, mappings/coa_icons_dbc.txt).
 Then hotfixes.spell_misc.SpellIconFileDataID (+ActiveIconFileDataID) of every converted CoA spell (7000000+id) is set and pushed (push 1951100).
usage: python coa_dbc_icons.py"""
import glob, json, os, re, struct
import mpyq, pymysql

ROOT = r'C:\WowServer\Custom'
DATA = r'C:\Games\Conquest of Azerothcore\COA\Data'
CLIENT = r'C:\Games\Wow\World of Warcraft\_retail_'
SP = os.path.join(ROOT, 'data', 'coa_dbc', 'D_Spell.dbc')
SI = os.path.join(ROOT, 'data', 'coa_dbc', 'S_SpellIcon.dbc')
BASE_ID, PUSH, BUILD, H_MISC = 9600000, 1951100, 69933, 3322146344


def dbc(path):
    d = open(path, 'rb').read()
    _, rc, fc, rs, ss = struct.unpack('<4sIIII', d[:20])
    return d, rc, fc, rs, 20 + rc * rs


def cstr(d, strbase, off):
    e = d.index(b'\0', strbase + off)
    return d[strbase + off:e].decode('latin1')


# SpellIcon.dbc: id -> path
d, rc, fc, rs, sb = dbc(SI)
icon_path = {}
for i in range(rc):
    rid, off = struct.unpack_from('<II', d, 20 + i * rs)
    icon_path[rid] = cstr(d, sb, off)
# Spell.dbc: spell -> SpellIconID (field 133)
d, rc, fc, rs, sb = dbc(SP)
spell_icon = {}
for i in range(rc):
    sid = struct.unpack_from('<I', d, 20 + i * rs)[0]
    if 300000 <= sid < 1000000:
        spell_icon[sid] = icon_path.get(struct.unpack_from('<I', d, 20 + i * rs + 133 * 4)[0], '')
print('CoA spells with icon path', sum(1 for v in spell_icon.values() if v), 'of', len(spell_icon))

# retail listfile: lowercase path -> id
lf = {}
for line in open(os.path.join(ROOT, 'data', 'listfile', 'community-listfile.csv'), encoding='utf-8', errors='replace'):
    p = line.strip().split(';')
    if len(p) == 2:
        lf[p[1].lower().replace('\\', '/')] = int(p[0])

# BLP index of the CoA MPQs (Interface\Icons)
idx = {}
for f in sorted(glob.glob(DATA + '/*.MPQ') + glob.glob(DATA + '/*/*.MPQ'), key=os.path.getmtime):
    if os.path.getsize(f) > 4294967000:
        continue
    try:
        a = mpyq.MPQArchive(f, listfile=True)
    except Exception:
        continue
    for x in a.files or []:
        xl = x.lower()
        if xl.startswith(b'interface\\icons\\') and xl.endswith(b'.blp'):
            idx[xl.decode('latin1').replace('\\', '/')] = (f, x)        # later (newer) archives win
print('MPQ icon files', len(idx))

out_dir = os.path.join(CLIENT, 'files', 'Interface', 'Icons', 'coa2')
os.makedirs(out_dir, exist_ok=True)
new_ids, lines, arch_cache = {}, [], {}
res = {}
for sid, path in spell_icon.items():
    if not path:
        continue
    key = path.lower().replace('\\', '/') + '.blp'
    if not key.startswith('interface/'):
        key = 'interface/icons/' + key
    if key in lf:
        res[sid] = lf[key]
        continue
    if key in idx:
        if key not in new_ids:
            f, x = idx[key]
            a = arch_cache.get(f) or arch_cache.setdefault(f, mpyq.MPQArchive(f, listfile=True))
            data = a.read_file(x)
            if not data or data[:4] != b'BLP2' and data[:4] != b'BLP1':
                continue
            fid = BASE_ID + len(new_ids)
            name = os.path.basename(key)
            open(os.path.join(out_dir, name), 'wb').write(data)
            new_ids[key] = fid
            lines.append(f'{fid};Interface/Icons/coa2/{name}')
        res[sid] = new_ids[key]
open(os.path.join(CLIENT, 'mappings', 'coa_icons_dbc.txt'), 'w', newline='\n').write('\n'.join(lines) + '\n')
json.dump({str(k): v for k, v in res.items()}, open(os.path.join(ROOT, 'data', 'coa', 'dbc_spell_icons.json'), 'w'))
print('resolved', len(res), 'new custom BLPs', len(new_ids))

db = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)
c = db.cursor()
c.execute('select SpellID from spell_misc where SpellID between 7300000 and 7999999')
have = {r[0] for r in c.fetchall()}
upd = [(fid, fid, 7000000 + sid) for sid, fid in res.items() if 7000000 + sid in have]
c.executemany('update spell_misc set SpellIconFileDataID=%s, ActiveIconFileDataID=%s where SpellID=%s', upd)
c.execute('select ID,SpellID from spell_misc where SpellID in (%s)' % ','.join(str(u[2]) for u in upd))
rows = c.fetchall()
c.execute('delete from hotfix_data where Id=%s', (PUSH,))
c.executemany('insert into hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)',
              [(PUSH, 3960000000 + i, H_MISC, r[0], BUILD) for i, r in enumerate(rows)])
print('spell_misc updated', len(upd), 'hotfix rows', len(rows))
