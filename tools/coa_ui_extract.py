"""Extract the CoA talent UI addon (Ascension_CoATalents) and CA data lua from the CoA client patch-B.MPQ into data/coa_ui."""
import mpyq, os
BS = chr(92)
D = r'C:\Games\Conquest of Azerothcore\COA\Data\patch-B.MPQ'
OUT = r'C:\WowServer\Custom\data\coa_ui'
os.makedirs(OUT, exist_ok=True)
a = mpyq.MPQArchive(D, listfile=True)
for x in a.files:
    xs = x.decode('latin1') if isinstance(x, bytes) else x
    l = xs.lower()
    if 'ascension_coatalents' in l or l.endswith('framexml' + BS + 'data' + BS + 'characteradvancement.lua') or 'caconnectednodes' in l or 'framexml' + BS + 'characteradvancement' in l:
        d = a.read_file(x)
        open(os.path.join(OUT, l.replace(BS, '__')), 'wb').write(d)
        print(l, len(d))
