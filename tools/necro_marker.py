"""Class-campaign marker: a teal copy of the Campaign ("journey") shield, installed over the retail *Important* quest marker models.
Retail Campaign (journey) markers stay untouched; the Necromancer quests use QuestInfoID 9011 (Modifiers 0x400 = Important) so the client draws the Important marker.
Needs wow.tools.local running on :5000 (reads the local client) once, to extract the originals into data/casc_extract.
Revert: delete _retail_/mappings/necro_marker.txt (+ files/Interface/Buttons/necro_marker_* and talktome*important*), restart the client."""
import colorsys, os, struct, subprocess
from PIL import Image
R = r'C:\Games\Wow\World of Warcraft\_retail_'
X = r'C:\WowServer\Custom\data\casc_extract'
OUT = R + r'\files\Interface\Buttons'
SH = (165 - 52) / 360     # yellow -> necrotic blue-green
SRC_TEX = [130872, 3492754, 3492764, 3486411, 3492765, 5389685, 4688261]
NEWID = {t: 9800001 + i for i, t in enumerate(SRC_TEX)}
MODELS = {5217338: (3486398, 'talktome_important.m2'), 5217340: (3486399, 'talktomequestion_important.m2'),
          5217339: (4688180, 'talktome_important_faded.m2'), 5217341: (3486410, 'talktomequestion_important_grey.m2')}

def get(fid, ext):
    p = os.path.join(X, f'{fid}.{ext}')
    if not os.path.exists(p) or os.path.getsize(p) == 0:
        subprocess.run(['curl', '-s', '-o', p, f'http://127.0.0.1:5000/casc/fdid?filedataid={fid}&filename=a.{ext}&download=1'], check=True)
    return open(p, 'rb').read()

def tint565(c, SH=SH):
    r, g, b = ((c >> 11) & 31) / 31, ((c >> 5) & 63) / 63, (c & 31) / 31
    h, s, v = colorsys.rgb_to_hsv(r, g, b); r, g, b = colorsys.hsv_to_rgb((h + SH) % 1, s, v)
    return (round(r * 31) << 11) | (round(g * 63) << 5) | round(b * 31)

def recolor(blp, SH=SH):                      # DXT1/3/5 BLP2: shift the hue of every colour block endpoint, keep indices / alpha untouched
    b = bytearray(blp); assert b[:4] == b'BLP2' and b[8] == 2, 'expected DXT BLP2'
    step, skip = (8, 0) if b[10] == 0 else (16, 8)
    offs = struct.unpack('<16I', b[20:84]); sz = struct.unpack('<16I', b[84:148])
    for o, s in zip(offs, sz):
        for p in range(o + skip, o + s, step):
            if p + 8 > len(b): break
            c0, c1, idx = struct.unpack('<HHI', b[p:p + 8]); n0, n1 = tint565(c0, SH), tint565(c1, SH)
            if c0 > c1:
                if n0 == n1: n0 = min(65535, n1 + 1)
                if n0 < n1: n0, n1 = n1, n0; idx ^= 0x55555555
            elif n0 > n1: n0, n1 = n1, n0
            b[p:p + 8] = struct.pack('<HHI', n0, n1, idx)
    return bytes(b)

def retarget(m2, NEWID=NEWID):                      # swap the texture FileDataIDs in the TXID chunk
    b = bytearray(m2); k = b.find(b'TXID'); n = struct.unpack('<I', b[k + 4:k + 8])[0] // 4
    for j in range(n):
        o = k + 8 + 4 * j; t = struct.unpack('<I', b[o:o + 4])[0]
        if t in NEWID: b[o:o + 4] = struct.pack('<I', NEWID[t])
    return bytes(b)

# profile: (target hue, first new texture FileDataID, mapping file, {replaced marker model FDID: (journey model to clone, file name)})
J_BANG, J_Q, J_FADED, J_QGREY = 3486398, 3486399, 4688180, 3486410
PROFILES = {
    'class': (165, 9800001, 'necro_marker.txt', {5217338: (J_BANG, 'talktome_important.m2'), 5217340: (J_Q, 'talktomequestion_important.m2'),
                                                5217339: (J_FADED, 'talktome_important_faded.m2'), 5217341: (J_QGREY, 'talktomequestion_important_grey.m2')}),
    # Hero (custom) campaigns: Legendary marker type (quest FlagsEx 0x100), purple
    'hero': (280, 9800101, 'hero_marker.txt', {650616: (J_BANG, 'talktome_legendary.m2'), 650619: (J_Q, 'talktome_questionlegendary.m2'),
                                              3489738: (J_BANG, 'talktomeorange_new.m2'), 3491680: (J_Q, 'talktome_new_questionlegendary.m2'),
                                              5152919: (J_QGREY, 'talktome_new_questionlegendary_grey.m2'), 5152920: (J_BANG, 'talktomeorange_new_grey.m2'),
                                              5152921: (J_FADED, 'talktomeorange_new_faded.m2'), 5155014: (J_FADED, 'talktomeorange_new_trivial.m2'),
                                              5155015: (J_QGREY, 'talktome_new_questionlegendary_trivial.m2')}),
    # Meta ("wrapper") campaigns: QuestInfo Modifiers 0x800, red
    'meta': (350, 9800201, 'meta_marker.txt', {5374191: (J_BANG, 'talktome_wrapper.m2'), 5374193: (J_Q, 'talktomequestion_wrapper.m2'),
                                              5374192: (J_FADED, 'talktome_wrapper_faded.m2'), 5374194: (J_QGREY, 'talktomequestion_wrapper_grey.m2')}),
}
if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    for prof, (hue, base, mapfile, models) in PROFILES.items():
        sh = (hue - 52) / 360; ids = {t: base + i for i, t in enumerate(SRC_TEX)}; lines = []
        for t, n in ids.items():
            open(os.path.join(OUT, f'necro_marker_{n}.blp'), 'wb').write(recolor(get(t, 'blp'), sh)); lines.append(f'{n};Interface/Buttons/necro_marker_{n}.blp')
        for tgt, (src, name) in models.items():
            open(os.path.join(OUT, name), 'wb').write(retarget(get(src, 'm2'), ids)); lines.append(f'{tgt};Interface/Buttons/{name}')
        open(os.path.join(R, 'mappings', mapfile), 'w').write(chr(10).join(lines) + chr(10)); print(prof, len(lines), 'lines')
