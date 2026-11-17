"""Looks up CoA creature display ids in the CoA client DBCs (CreatureDisplayInfo / CreatureModelData, incl. HD patch) -> model path.
usage: python coa_display_models.py 33924 95426 ..."""
import glob, os, pickle, struct, sys
import mpyq

SRC = 'C:/Games/Conquest of Azerothcore/COA/Data'
BS = chr(92)
CACHE = 'C:/Users/<user>/AppData/Local/Temp/dbcfound.pkl'
names = {'info': 'dbfilesclient' + BS + 'creaturedisplayinfo.dbc', 'model': 'dbfilesclient' + BS + 'creaturemodeldata.dbc',
         'hinfo': 'dbfilesclient' + BS + 'hdcreaturedisplayinfo.dbc', 'hmodel': 'dbfilesclient' + BS + 'hdcreaturemodeldata.dbc'}
found = pickle.load(open(CACHE, 'rb'))


def read(name):
    out = None
    for p in found[name]:
        a = mpyq.MPQArchive(p, listfile=True)
        for f in a.files:
            n = f.decode('latin1') if isinstance(f, bytes) else f
            if n.lower() == name:
                data = a.read_file(f)
                if data:
                    out = data
    return out


def parse(data):
    magic, rc, fc, rs, ss = struct.unpack('<4sIIII', data[:20])
    return rc, fc, rs, data[20:20 + rc * rs], data[20 + rc * rs:]


def cstr(strs, off):
    return strs[off:strs.index(b'\0', off)].decode('latin1')


want = {int(x) for x in sys.argv[1:]}
for info, model in (('info', 'model'), ('hinfo', 'hmodel')):
    if names[info] not in found:
        continue
    rc, fc, rs, recs, strs = parse(read(names[info]))
    rc2, fc2, rs2, recs2, strs2 = parse(read(names[model]))
    models = {}
    for i in range(rc2):
        v = struct.unpack('<%dI' % fc2, recs2[i * rs2:(i + 1) * rs2])
        models[v[0]] = cstr(strs2, v[2])
    print(info, rc, 'records')
    for i in range(rc):
        v = struct.unpack('<%dI' % fc, recs[i * rs:(i + 1) * rs])
        if v[0] in want:
            tex = [cstr(strs, x) for x in v[6:9] if 0 < x < len(strs)]
            print(' display', v[0], 'modelid', v[1], 'path', models.get(v[1]), 'scale', round(struct.unpack('<f', struct.pack('<I', v[4]))[0], 3), 'textures', tex)
