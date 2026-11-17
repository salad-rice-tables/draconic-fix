"""List the base UI files (Interface/FrameXML, SharedXML, Blizzard and Ascension addons) of every CoA client MPQ and find which archive defines a template.
usage: python coa_mpq_scan.py                 -> data/coa/mpq_ui_all.json (archive -> files)
       python coa_mpq_scan.py find <text> ... -> archives/files whose XML defines a virtual template with this name (reads the archives)"""
import os, sys, re, glob, json
import mpyq

SRC = r'C:\Games\Conquest of Azerothcore\COA\Data'
OUT = r'C:\WowServer\Custom\data\coa\mpq_ui_all.json'
BS = chr(92)
UI = re.compile(r'(?i)^interface/(framexml|sharedxml|addons/blizzard|addons/ascension)')


def archives():
    return sorted(glob.glob(SRC + '/*.MPQ') + glob.glob(SRC + '/enUS/*.MPQ'))


def names(a):
    return [(f.decode('latin1') if isinstance(f, bytes) else f) for f in (a.files or [])]


def scan():
    res = {}
    for p in archives():
        try: a = mpyq.MPQArchive(p, listfile=True)
        except Exception as e: print('skip', os.path.basename(p), str(e)[:50]); continue
        fl = names(a)
        ui = [f for f in fl if UI.match(f.replace(BS, '/'))]
        res[os.path.basename(p)] = ui
        print(os.path.basename(p), len(fl), 'files;', len(ui), 'ui', flush=True)
    json.dump(res, open(OUT, 'w'))


def find(words):
    data = json.load(open(OUT))
    for arc, files in data.items():
        a = mpyq.MPQArchive(os.path.join(SRC, arc) if os.path.exists(os.path.join(SRC, arc)) else os.path.join(SRC, 'enUS', arc), listfile=True)
        for f in files:
            if not f.lower().endswith('.xml'): continue
            try: t = a.read_file(f)
            except Exception: continue
            if not t: continue
            t = t.decode('utf-8', 'ignore')
            for w in words:
                if re.search(r'name="' + re.escape(w) + r'"[^>]*virtual="true"|virtual="true"[^>]*name="' + re.escape(w) + '"', t): print(w, '->', arc, f)


if __name__ == '__main__':
    if sys.argv[1:2] == ['find']: find(sys.argv[2:])
    else: scan()
