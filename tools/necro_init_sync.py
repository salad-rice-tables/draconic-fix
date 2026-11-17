import os
"""Sync lua/coa_init_config.lua + data/necro_init/locations.json with where the objects REALLY stand in the world DB (you move them in game with
.gobject move / .npc move), then rebuild the quest map markers. Run after moving anything, then restart the server (or .reload eluna).
usage: python tools/necro_init_sync.py"""
import json, re, subprocess, pymysql
R = 'C:/WowServer/Custom'
LOC, CFG = f'{R}/data/necro_init/locations.json', f'{R}/lua/coa_init_config.lua'
L = json.load(open(LOC, encoding='utf-8'))
w = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world').cursor()
cfg = open(CFG, encoding='utf-8').read()


def put(key, p):
    global cfg
    new = f'{key} = {{map = {p["map"]}, x = {p["x"]}, y = {p["y"]}, z = {p["z"]}, o = {p.get("o", 0)}}}'
    cfg, n = re.subn(key + r' = \{map = [^}]*\}', new, cfg)
    print(key, 'synced' if n else 'NOT IN CONFIG', p['x'], p['y'])


for key, p in L.items():
    if not isinstance(p, dict) or p.get('kind') not in ('creature', 'gameobject') or 'entry' not in p: continue
    tab = 'creature' if p['kind'] == 'creature' else 'gameobject'
    w.execute(f'select position_x,position_y,position_z,orientation from {tab} where id=%s and map=%s order by guid desc limit 1', (p['entry'], p['map']))
    r = w.fetchone()
    if not r: continue
    p['x'], p['y'], p['z'], p['o'] = [round(float(v), 3) for v in r]
    put(key, p)
for k, src, dx in (('cave_entrance', 'vexthal_corpse', 0), ('return_destination', 'anima_crystal', 2)):   # derived spots follow the objects
    L[k].update(x=round(L[src]['x'] + dx, 3), y=L[src]['y'], z=L[src]['z'])
    put(k, L[k])
json.dump(L, open(LOC, 'w', encoding='utf-8'), indent=2, ensure_ascii=False)
open(CFG, 'w', encoding='utf-8').write(cfg)
subprocess.run(['python', f'{R}/tools/necro_init_poi.py'])
