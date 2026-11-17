"""Extract CharacterAdvancement*.dbc / ChrSpecs / ChrClasses from the CoA client MPQs into data/coa_dbc/CA_<name>.dbc (newest archive wins)."""
import glob, os, struct
import mpyq

D = r'C:\Games\Conquest of Azerothcore\COA\Data'
OUT = r'C:\WowServer\Custom\data\coa_dbc'
BS = chr(92)
want = {b'characteradvancement.dbc', b'characteradvancementessence.dbc', b'characteradvancementclasstypes.dbc', b'characteradvancementtabtypes.dbc', b'chrspecs.dbc', b'chrclasses.dbc'}
prefix = b'dbfilesclient' + BS.encode()
got = {}
for f in sorted(glob.glob(D + '/*.MPQ') + glob.glob(D + '/*/*.MPQ'), key=os.path.getmtime):
    if os.path.getsize(f) > 4294967000:
        continue
    try:
        a = mpyq.MPQArchive(f, listfile=True)
    except Exception:
        continue
    for x in a.files or []:
        xl = x.lower()
        if xl.startswith(prefix) and xl[len(prefix):] in want:
            got[xl[len(prefix):]] = (f, x)
os.makedirs(OUT, exist_ok=True)
for k, (f, x) in got.items():
    d = mpyq.MPQArchive(f, listfile=True).read_file(x)
    open(os.path.join(OUT, 'CA_' + k.decode()), 'wb').write(d)
    m, rc, fc, rs, ss = struct.unpack('<4sIIII', d[:20])
    print(k.decode(), os.path.basename(f), rc, fc, rs)
