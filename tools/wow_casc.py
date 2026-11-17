"""Extract files from the local WoW (Midnight) CASC by FileDataID with PyCASC (venv C:\\WowServer\\Custom\\.venv_casc). Read-only.
The package's WoW root parser predates the 12.x root, so the root file is parsed here (TSFM, header-size variant, 3 block-header layouts tried).
usage: .venv_casc\\Scripts\\python.exe tools\\wow_casc.py <fdid> [<fdid> ...]   -> data/casc_extract/<fdid>.<ext guessed from magic>"""
import os, struct, sys
import PyCASC.rootfiles as R
RAW = {}
def _grab(fd):
    RAW['root'] = fd if isinstance(fd, bytes) else fd.encode('latin1'); return []
R.parse_wow_root = _grab
from PyCASC import DirCASCReader
OUT = r'C:\WowServer\Custom\data\casc_extract'

def parse_root(b):
    magic, = struct.unpack_from('<I', b, 0); assert magic == 0x4D465354, 'not TSFM'
    hs, ver = struct.unpack_from('<II', b, 4)
    if hs > 100 or ver > 5:   # legacy 8.2 layout: magic, total, named
        total, named = hs, ver; pos = 12; layout = 'v1'
    else:
        total, named = struct.unpack_from('<II', b, 12); pos = hs; layout = 'v2'
    out = {}; n = 0
    while pos < len(b) and n < total:
        if layout == 'v1': cnt, cflags, lflags = struct.unpack_from('<III', b, pos); pos += 12
        else:
            cnt, lflags, f1, f2 = struct.unpack_from('<IIII', b, pos); pos += 17; cflags = f1 | f2   # + flags3 byte
        ids = struct.unpack_from('<%di' % cnt, b, pos); pos += 4 * cnt
        cks = [b[pos + 16 * i: pos + 16 * i + 16] for i in range(cnt)]; pos += 16 * cnt
        if not cflags & 0x10000000: pos += 8 * cnt   # name hashes unless the block has NoNameHash
        fid = -1
        for i in range(cnt):
            fid += ids[i] + 1; out.setdefault(fid, cks[i])
        n += cnt
    return out

if __name__ == '__main__':
    r = DirCASCReader(r'C:\Games\Wow\World of Warcraft', read_install_file=False)
    root = parse_root(RAW['root']); print('root files', len(root))
    for a in sys.argv[1:]:
        ck = root.get(int(a))
        if not ck: print(a, 'not in root'); continue
        try: d = r.get_file_by_ckey(ck.hex())
        except Exception as e:
            d = None
            try: d = r.get_file_by_ckey(int.from_bytes(ck, 'big'))
            except Exception as e2: print(a, 'fetch failed', e2)
        if d:
            ext = {b'MD21': 'm2', b'MD20': 'm2', b'SKIN': 'skin', b'BLP2': 'blp'}.get(d[:4], 'bin')
            open(os.path.join(OUT, f'{a}.{ext}'), 'wb').write(d); print(a, ext, len(d))
