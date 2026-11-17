"""Extract files from the WoW client CASC storage by FileDataID (uses CascLib casc.dll that ships with WoWDatabaseEditor).
usage: python tools/casc_get.py <outdir> <fdid> [<fdid> ...]       writes <outdir>/<fdid>.<ext>  (ext from listfile name, else .bin)"""
import ctypes, os, sys
from ctypes import c_void_p, c_uint32, c_char_p, byref, create_string_buffer
STORAGE = r'C:\Games\Wow\World of Warcraft'
LIST = r'C:\WowServer\Custom\data\listfile\community-listfile.csv'
CASC_OPEN_BY_FILEID = 0x00000004  # CascLib: open by FileDataId (pvFileName = (void*)id)
d = ctypes.WinDLL(r'C:\WowServer\Tools\WoWDatabaseEditor\casc.dll')
for n, a, r in (('CascOpenStorage', [c_char_p, c_uint32, c_void_p], c_uint32), ('CascOpenFile', [c_void_p, c_void_p, c_uint32, c_uint32, c_void_p], c_uint32),
                ('CascGetFileSize', [c_void_p, c_void_p], c_uint32), ('CascReadFile', [c_void_p, c_void_p, c_uint32, c_void_p], c_uint32), ('CascCloseFile', [c_void_p], c_uint32)):
    f = getattr(d, n); f.argtypes = a; f.restype = r
out, ids = sys.argv[1], [int(x) for x in sys.argv[2:]]
os.makedirs(out, exist_ok=True)
names = {}
for line in open(LIST, encoding='utf-8'):
    i, _, nm = line.strip().partition(';')
    if i.isdigit() and int(i) in ids: names[int(i)] = nm
h = c_void_p()
ok = d.CascOpenStorage(STORAGE.encode(), 0, byref(h))
if not ok: sys.exit('CascOpenStorage failed, error %d' % ctypes.GetLastError())
for fid in ids:
    f = c_void_p()
    if not d.CascOpenFile(h, c_void_p(fid), 0xFFFFFFFF, CASC_OPEN_BY_FILEID, byref(f)):
        print(fid, 'not found, error', ctypes.GetLastError()); continue
    size = d.CascGetFileSize(f, None)
    buf = create_string_buffer(size); n = c_uint32()
    d.CascReadFile(f, buf, size, byref(n)); d.CascCloseFile(f)
    ext = os.path.splitext(names.get(fid, ''))[1] or '.bin'
    p = os.path.join(out, f'{fid}{ext}')
    open(p, 'wb').write(buf.raw[:n.value]); print(fid, names.get(fid, ''), n.value, 'bytes ->', p)
