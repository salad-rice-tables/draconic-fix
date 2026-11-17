"""Ship CoA custom icons to the client as real files with new FileDataIDs (Burralis launcher: files/ + mappings/*.txt, --mods Full).
 - converts PNG -> uncompressed BLP2 (64x64 BGRA) into <client>/files/Interface/Icons/coa/<name>.blp
 - writes <client>/mappings/coa_icons.txt   (fileId;filePath)
 - updates data/coa/necromancer_icons.json  (fileDataID of every custom icon = its new id) + data/coa/coa_icon_ids.json
IDs start at 9500000 (well above the retail listfile range)."""
import json, os, struct
from PIL import Image

CLIENT = r'C:\Games\Wow\World of Warcraft\_retail_'
ROOT = r'C:\WowServer\Custom\data'
ICONS_PNG = os.path.join(ROOT, 'ascension-data', 'repo', 'supplemental', 'exiles-db', 'assets', 'icons')
BASE_ID = 9500000
OUT_DIR = os.path.join(CLIENT, 'files', 'Interface', 'Icons', 'coa')
MAP_DIR = os.path.join(CLIENT, 'mappings')
os.makedirs(OUT_DIR, exist_ok=True)
os.makedirs(MAP_DIR, exist_ok=True)


def write_blp(img, path):
    """BLP2, colour encoding 3 (uncompressed BGRA), alpha 8 bit, no mipmaps. Header = 1172 bytes, pixel data follows."""
    img = img.convert('RGBA').resize((64, 64), Image.LANCZOS)
    w, h = img.size
    px = bytearray()
    for r, g, b, a in img.getdata():
        px += bytes((b, g, r, a))
    off = 4 + 4 + 4 + 4 + 4 + 64 + 64 + 1024
    hdr = b'BLP2' + struct.pack('<IBBBB', 1, 3, 8, 7, 0) + struct.pack('<II', w, h)
    hdr += struct.pack('<16I', off, *([0] * 15)) + struct.pack('<16I', len(px), *([0] * 15)) + bytes(1024)
    assert len(hdr) == off
    open(path, 'wb').write(hdr + bytes(px))


icons = json.load(open(os.path.join(ROOT, 'coa', 'necromancer_icons.json'), encoding='utf-8'))
names = {}                                     # lower icon name -> source png
for v in icons.values():
    if 'custom' in v:
        names[v['icon'].lower()] = v['icon']
for extra in ('_undead_03', 'wc3lichoriginal', 'classicon_necromancer'):
    names[extra.lower()] = extra

ids = {}
lines = []
for i, (low, orig) in enumerate(sorted(names.items())):
    src = os.path.join(ICONS_PNG, orig + '.png')
    if not os.path.exists(src):
        continue
    fid = BASE_ID + i
    write_blp(Image.open(src), os.path.join(OUT_DIR, low + '.blp'))
    ids[low] = fid
    lines.append(f'{fid};Interface/Icons/coa/{low}.blp')
open(os.path.join(MAP_DIR, 'coa_icons.txt'), 'w', encoding='utf-8', newline='\n').write('\n'.join(lines) + '\n')
json.dump(ids, open(os.path.join(ROOT, 'coa', 'coa_icon_ids.json'), 'w'), indent=1)
n = 0
for v in icons.values():
    if 'custom' in v and v['icon'].lower() in ids:
        v['fileDataID'] = ids[v['icon'].lower()]
        n += 1
json.dump(icons, open(os.path.join(ROOT, 'coa', 'necromancer_icons.json'), 'w'), indent=1)
print('blp files', len(ids), 'spell icon entries updated', n, 'mapping', os.path.join(MAP_DIR, 'coa_icons.txt'))
