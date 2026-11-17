"""Extract the CoA client UI (Interface\\* , TALENTFRAME, CoAMultiCast, fonts-free) from the CoA client's MPQ patches into data/coa_client/<archive>/<path>.
Read-only on the client folder. usage: python coa_mpq_extract.py"""
import json, os, re, mpyq

SRC = r'C:\Games\Conquest of Azerothcore\COA\Data'
OUT = r'C:\WowServer\Custom\data\coa_client'
ARCH = ['patch-B.MPQ', 'patch-A.MPQ', 'patch-X.MPQ', r'enUS\patch-enUS.MPQ', r'enUS\patch-enUS-2.MPQ', r'enUS\patch-enUS-3.MPQ']
KEEP = re.compile(rb'^(interface\\(addons\\(ascension|coa|aw)|framexml\\(ascension|coa|xphot)|sharedxml|talentframe|coamulticast|ascension|coa)|ascension|coa)', re.I)
ok = bad = 0
for arc in ARCH:
    p = os.path.join(SRC, arc)
    if not os.path.exists(p):
        continue
    a = mpyq.MPQArchive(p, listfile=True)
    for f in a.files or []:
        if not KEEP.search(f):
            continue
        name = f.decode('latin1')
        dst = os.path.join(OUT, os.path.basename(arc).replace('.MPQ', ''), name.replace('\\', os.sep))
        try:
            data = a.read_file(f)
            if data is None:
                bad += 1
                continue
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            open(dst, 'wb').write(data)
            ok += 1
        except Exception as e:
            bad += 1
    print(arc, 'done', ok, bad)
print('extracted', ok, 'failed', bad)
