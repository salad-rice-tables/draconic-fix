"""Local asset server for Midnight Creator Studio (127.0.0.1:8095): serves any client file by FileDataID and resolves creature display ids to model + textures.
Run with the PyCASC venv:  C:\\WowServer\\Custom\\.venv_casc\\Scripts\\python.exe C:\\WowServer\\Custom\\tools\\casc_server.py
  GET /file/<fdid>            raw file (cached in Custom/data/casc_cache), loose-file overrides of the client (_retail_/mappings + files) win
  GET /godisplay/<displayId>  {"model": fdid, "kind": "m2|wmo|other|missing", "scale": f}  from hotfixes.gameobject_display_info
  GET /display/<displayId>    {"model": fdid, "textures": [fdid,...], "scale": f}  from hotfixes.creature_display_info + CreatureModelData.db2
  GET /ping
The first start reads the 1.6 M CASC index entries (~40 s)."""
import json, os, struct, sys, threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import wow_casc as W
sys.path.append(r'C:/Users/<user>\AppData\Roaming\Python\Python314\site-packages')   # pymysql lives in the user site, the CASC venv has none
import pymysql
CACHE = r'C:\WowServer\Custom\data\casc_cache'
CLIENT = r'C:\Games\Wow\World of Warcraft\_retail_'
os.makedirs(CACHE, exist_ok=True)
READER = W.DirCASCReader(r'C:\Games\Wow\World of Warcraft', read_install_file=False)
ROOT = W.parse_root(W.RAW['root'])
LOCK = threading.Lock()

# loose-file overrides (the client prefers them): mappings/*.txt = "fdid;path" relative to _retail_/files
LOOSE = {}
mp = os.path.join(CLIENT, 'mappings'); _loose_stamp = None
def load_loose():   # re-read whenever a mappings file changed, so World Editor saves show up without restarting this server
    global _loose_stamp
    fs = [f for f in (os.listdir(mp) if os.path.isdir(mp) else []) if f.endswith('.txt')]
    st = [(f, os.path.getmtime(os.path.join(mp, f))) for f in fs]
    if st == _loose_stamp: return
    _loose_stamp = st; LOOSE.clear()
    for fn in fs:
        for ln in open(os.path.join(mp, fn), encoding='utf-8', errors='ignore'):
            a, _, p = ln.strip().partition(';')
            if a.isdigit() and p: LOOSE[int(a)] = os.path.join(CLIENT, 'files', p.replace('/', os.sep))
load_loose()

_NOWAGO = set(); _WAGO_GATE = threading.Semaphore(3)
def wago_file(fdid):
    """Files that are not in this client's local archives (the install only holds part of the game data): fetched once from wago.tools and kept in the cache folder. A miss is remembered for this run."""
    if fdid in _NOWAGO: return None
    import urllib.request, urllib.error
    with _WAGO_GATE:
        try:
            d = urllib.request.urlopen(urllib.request.Request('https://wago.tools/api/casc/%d?download' % fdid, headers={'User-Agent': 'MidnightCreatorStudio'}), timeout=120).read()
            if d: open(os.path.join(CACHE, str(fdid)), 'wb').write(d); return d
        except urllib.error.HTTPError as e:
            if e.code == 404: _NOWAGO.add(fdid)   # really not there; other errors (timeouts, busy) are retried next time
        except Exception: pass
    return None

def get_file(fdid, wago=True):
    load_loose()
    if fdid in LOOSE and os.path.exists(LOOSE[fdid]): return open(LOOSE[fdid], 'rb').read()
    cp = os.path.join(CACHE, str(fdid))
    if os.path.exists(cp): return open(cp, 'rb').read()
    ck = ROOT.get(fdid); d = None
    if ck:
        with LOCK:
            try: d = READER.get_file_by_ckey(ck.hex())
            except Exception:
                try: d = READER.get_file_by_ckey(int.from_bytes(ck, 'big'))
                except Exception: d = None
    if d: open(cp, 'wb').write(d); return d
    return wago_file(fdid) if wago else None

# Server copies of client DB2 (WDC5): id -> value of one plain bitpacked field. The DB holds only changed rows, so older ids come from here.
DBC = r'C:\WowServer\MyServer\69587Precompiled\69587Precompiled\bin\RelWithDebInfo\dbc\enUS'
def field_map(name, fidx, fdid=None):
    # prefer the client's own DB2 (always matches the model files); fall back to the older server copy
    b = None
    if fdid:
        try:
            b = get_file(fdid)
            if b and (b[:4] != b'WDC5' or struct.unpack_from('<I', b, 200)[0] != 1): b = None
        except Exception: b = None
    if b is None: b = open(os.path.join(DBC, name), 'rb').read()
    rc, fc, rs = struct.unpack_from('<3I', b, 136); sections, = struct.unpack_from('<I', b, 200)
    tact, foff, rcnt, sts, off_end, idsz, relsz, mapc, copyc = struct.unpack_from('<QIIIIIIII', b, 204)
    fsi = 204 + 40 * sections + 4 * fc
    ids = struct.unpack_from('<%dI' % rcnt, b, foff + rcnt * rs + sts)
    off_bits, size_bits = struct.unpack_from('<HH', b, fsi + 24 * fidx)
    return {ids[i]: (int.from_bytes(b[foff + i * rs: foff + (i + 1) * rs], 'little') >> off_bits) & ((1 << size_bits) - 1) for i in range(rcnt)}
CMD = field_map('CreatureModelData.db2', 2, 1365368)      # FileDataID is field 2
GOD = field_map('GameObjectDisplayInfo.db2', 1, 1266277)  # FileDataID is field 1 (field 0 is the 6-float GeoBox)
print('model data rows', len(CMD), 'object display rows', len(GOD), flush=True)
import threading
DBL = threading.Lock()   # one shared connection; HTTP handlers run in threads
H = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)

import csv, glob
def _csv(name):
    f = sorted(glob.glob('C:/WowServer/Custom/docs/wago_csv/' + name + '_12.1.5*.csv'))
    return csv.DictReader(open(f[-1], encoding='utf-8')) if f else []
# humanoid NPCs: CreatureDisplayInfoExtra -> baked body texture (HD first) -> TextureFileData -> FileDataID
_mat = {}
for r in _csv('TextureFileData'):
    if r['UsageType'] == '0': _mat.setdefault(int(r['MaterialResourcesID']), int(r['FileDataID']))
BAKE = {}   # extra display id -> (HD bake texture, SD bake texture)
for r in _csv('CreatureDisplayInfoExtra'):
    hd = _mat.get(int(r['HDBakeMaterialResourcesID'] or 0), 0); sd = _mat.get(int(r['BakeMaterialResourcesID'] or 0), 0)
    if hd or sd: BAKE[int(r['ID'])] = (hd, sd)
print('baked npc textures', len(BAKE), flush=True)

NPCSLOT = {}   # extended display id -> {slot: ItemDisplayInfoID}  (0 head, 1 shoulders …)
for r in _csv('NPCModelItemSlotDisplayInfo'):
    s = int(r['ItemSlot']); 
    if s in (0, 1): NPCSLOT.setdefault(int(r['NpcModelID']), {})[s] = int(r['ItemDisplayInfoID'])

def display(did):
    with DBL, H.cursor() as c:
        H.ping(reconnect=True)
        c.execute('select ModelID, CreatureModelScale, TextureVariationFileDataID1, TextureVariationFileDataID2, TextureVariationFileDataID3, TextureVariationFileDataID4, ExtendedDisplayInfoID from creature_display_info where ID=%s', (did,))
        r = c.fetchone()
        if not r: return None
        model_fd = CMD.get(r[0])
        c.execute('select FileDataID from creature_model_data where ID=%s', (r[0],))
        row = c.fetchone()
        if row and row[0]: model_fd = row[0]   # hotfix override wins
    return {'model': model_fd, 'textures': [t for t in r[2:6] if t], 'scale': r[1], 'bake': next((f for f in BAKE.get(r[6], ()) if f and get_file(f)), 0), 'items': NPCSLOT.get(r[6], {})}   # HD first, the older SD texture when the HD file does not exist, 'items': NPCSLOT.get(r[6], {})}

def godisplay(did):
    """GameObjectDisplayInfo (full table in hotfixes) -> model file id; kind from the file magic: MD21 = M2, REVM (reversed MVER) = WMO root."""
    with DBL, H.cursor() as c:
        H.ping(reconnect=True)
        c.execute('select FileDataID, OverrideNameScale from gameobject_display_info where ID=%s', (did,))
        r = c.fetchone()
    fd = r[0] if r and r[0] else GOD.get(did)
    if not fd: return None
    r = (fd, r[1] if r else 1)
    d = get_file(r[0]); kind = 'missing' if not d else 'm2' if d[:4] == b'MD21' else 'wmo' if d[:4] == b'REVM' else 'other'
    return {'model': r[0], 'kind': kind, 'scale': r[1]}

_ITEM = {}; _ITEM_LOCK = threading.Lock()
def _item_maps():
    with _ITEM_LOCK: return _item_maps_locked()
def _item_maps_locked():
    """item id -> appearance -> display info -> model file (+ one texture). wago CSV exports of the client tables (all retail items) overlaid with the hotfix rows (custom items). Built on first use."""
    if _ITEM: return _ITEM
    ima = {}
    for r in _csv('ItemModifiedAppearance'): ima.setdefault(int(r['ItemID']), {})[int(r['ItemAppearanceModifierID'])] = int(r['ItemAppearanceID'])
    ia = {int(r['ID']): int(r['ItemDisplayInfoID']) for r in _csv('ItemAppearance')}
    idi = {int(r['ID']): (int(r['ModelResourcesID_0'] or 0), int(r['ModelMaterialResourcesID_0'] or 0)) for r in _csv('ItemDisplayInfo')}
    idi_full = {int(r['ID']): ((int(r['ModelResourcesID_0'] or 0), int(r['ModelResourcesID_1'] or 0)), (int(r['ModelMaterialResourcesID_0'] or 0), int(r['ModelMaterialResourcesID_1'] or 0))) for r in _csv('ItemDisplayInfo')}
    mfd = {}
    for r in _csv('ModelFileData'): mfd.setdefault(int(r['ModelResourcesID']), int(r['FileDataID']))
    with DBL, H.cursor() as c:
        H.ping(reconnect=True)
        c.execute('select ItemID, ItemAppearanceModifierID, ItemAppearanceID from item_modified_appearance')
        for i, m, a in c.fetchall(): ima.setdefault(i, {})[m] = a
        c.execute('select ID, ItemDisplayInfoID from item_appearance')
        for i, d in c.fetchall(): ia[i] = d
    _ITEM.update(ima=ima, ia=ia, idi=idi, mfd=mfd, idi_full=idi_full); return _ITEM

def displayinfo(di):
    """ItemDisplayInfo -> its model files (and the textures that go with them). Weapons have one model, shoulders two (left, right), helms one."""
    _item_maps(); m = _ITEM
    row = m['idi_full'].get(di)
    if not row: return None
    models = [m['mfd'].get(x) for x in row[0]]; texs = [_mat.get(x, 0) for x in row[1]]
    if not any(models): return None
    return {'models': [x or 0 for x in models], 'textures': texs}

def itemdisplay(item):
    m = _item_maps(); mods = m['ima'].get(item)
    if not mods: return None
    app = mods.get(0, next(iter(mods.values()))); info = m['idi'].get(m['ia'].get(app))
    if not info or not info[0]: return None
    model = m['mfd'].get(info[0])
    if not model: return None
    return {'model': model, 'textures': [_mat[info[1]]] if info[1] in _mat else [], 'scale': 1}

_SICON = {}; _SICON_LOCK = threading.Lock()
def spellicon(sid):
    """spell id -> icon FileDataID: the wago SpellMisc export (all retail spells) overlaid with the hotfix rows (custom spells). Built on first use."""
    with _SICON_LOCK:
        if not _SICON:
            for r in _csv('SpellMisc'):
                i = int(r['SpellIconFileDataID'] or 0)
                if i and int(r['DifficultyID'] or 0) == 0: _SICON[int(r['SpellID'])] = i
            with DBL, H.cursor() as c:
                H.ping(reconnect=True); c.execute('select SpellID, SpellIconFileDataID from spell_misc where SpellIconFileDataID > 0')
                for s, i in c.fetchall(): _SICON[s] = i
    i = _SICON.get(sid); return {'icon': i} if i else None

class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def send(self, code, body, ctype='application/octet-stream'):
        self.send_response(code); self.send_header('Content-Type', ctype); self.send_header('Content-Length', str(len(body))); self.end_headers(); self.wfile.write(body)
    def do_GET(self):
        p = self.path.split('?')[0].strip('/').split('/')
        try:
            if p[0] == 'ping': return self.send(200, b'ok', 'text/plain')
            if p[0] == 'has':   # is this file in the client (or already cached)? no download
                f = int(p[1]); ok = f in ROOT or f in LOOSE or os.path.exists(os.path.join(CACHE, str(f))); return self.send(200 if ok else 404, b'1' if ok else b'0', 'text/plain')
            if p[0] == 'file':
                d = get_file(int(p[1]), 'local=1' not in self.path); return self.send(200, d) if d else self.send(404, b'not found', 'text/plain')
            if p[0] == 'godisplay':
                r = godisplay(int(p[1])); return self.send(200, json.dumps(r).encode(), 'application/json') if r else self.send(404, b'no display', 'text/plain')
            if p[0] == 'itemdisplay':
                r = itemdisplay(int(p[1])); return self.send(200, json.dumps(r).encode(), 'application/json') if r else self.send(404, b'no model', 'text/plain')
            if p[0] == 'spellicon':
                r = spellicon(int(p[1])); return self.send(200, json.dumps(r).encode(), 'application/json') if r else self.send(404, b'no icon', 'text/plain')
            if p[0] == 'displayinfo':
                r = displayinfo(int(p[1])); return self.send(200, json.dumps(r).encode(), 'application/json') if r else self.send(404, b'no model', 'text/plain')
            if p[0] == 'display':
                r = display(int(p[1])); return self.send(200, json.dumps(r).encode(), 'application/json') if r else self.send(404, b'no display', 'text/plain')
        except Exception as e: return self.send(500, str(e).encode(), 'text/plain')
        self.send(404, b'?', 'text/plain')

if __name__ == '__main__':
    print('casc_server ready on 127.0.0.1:8095', len(ROOT), 'files', len(CMD), 'model rows', flush=True)
    ThreadingHTTPServer(('127.0.0.1', 8095), Handler).serve_forever()
