"""Re-encode the raw CoA icon BLPs in <client>/files/Interface/Icons/coa2 into the palette format Midnight renders (raw ones show a red X)."""
import glob, struct
from PIL import Image
D = r'C:\Games\Wow\World of Warcraft\_retail_\files\Interface\Icons\coa2'


def blp(img, path, size=64):
    img = img.convert('RGBA').resize((size, size), Image.LANCZOS)
    rgb = img.convert('RGB').quantize(256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    pal = rgb.getpalette()[:768]
    pal += [0] * (768 - len(pal))
    palbytes = b''.join(bytes((pal[i * 3 + 2], pal[i * 3 + 1], pal[i * 3], 255)) for i in range(256))
    levels, s = [], size
    while True:
        im = img.resize((s, s), Image.LANCZOS) if s != size else img
        q = im.convert('RGB').quantize(palette=rgb, dither=Image.Dither.NONE)
        levels.append(bytes(q.tobytes()) + bytes(im.getchannel('A').tobytes()))
        if s == 1:
            break
        s //= 2
    offs, o = [], 1172
    for l in levels:
        offs.append(o)
        o += len(l)
    offs += [0] * (16 - len(offs))
    sizes = [len(l) for l in levels] + [0] * (16 - len(levels))
    h = b'BLP2' + struct.pack('<IBBBB', 1, 1, 8, 8, 1) + struct.pack('<II', size, size) + struct.pack('<16I', *offs) + struct.pack('<16I', *sizes) + palbytes
    open(path, 'wb').write(h + b''.join(levels))


ok = skip = 0
for f in glob.glob(D + '/*.blp'):
    d = open(f, 'rb').read(12)
    if d[8] == 1 and d[9] == 1:       # already palette (encoding byte 1) -> nothing to do
        skip += 1
        continue
    try:
        im = Image.open(f)
        im.load()
        blp(im, f)
        ok += 1
    except Exception:
        pass
print('re-encoded', ok, 'already ok', skip)
