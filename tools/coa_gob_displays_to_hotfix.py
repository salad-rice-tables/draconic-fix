import os
"""CoA gameobject displays (CoA client GameObjectDisplayInfo.dbc) -> Midnight hotfixes.gameobject_display_info, same display id as in CoA.
Input : data/coa/worldforged_display_map.json (display id -> [retail FileDataID, geobox]) made from the CoA DBC + the community listfile.
Rows  : hotfixes.gameobject_display_info (ID, GeoBox*, FileDataID, ...) + hotfix_data (push 1952300, TableHash 1829768651).
usage : python coa_gob_displays_to_hotfix.py [apply|undo]   (restart the world server or .reload hotfixes afterwards; clients with a warm cache get the push id once)"""
import sys, json
sys.path.append("C:/Users/<user>/AppData/Roaming/Python/Python314/site-packages")
import pymysql

PUSH, HASH, BUILD, UBASE = 1952300, 1829768651, 69933, 3800000000
MAP = r'C:\WowServer\Custom\data\coa\worldforged_display_map.json'
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True)
h = c.cursor()


def undo():
    h.execute("select RecordID from hotfix_data where ID=%s and TableHash=%s", (PUSH, HASH)); ids = [r[0] for r in h.fetchall()]
    if ids: h.execute("delete from gameobject_display_info where ID in %s", (tuple(ids),))
    h.execute("delete from hotfix_data where ID=%s and TableHash=%s", (PUSH, HASH)); print('removed', len(ids), 'displays')


def apply():
    m = json.load(open(MAP)); undo(); n = 0
    h.execute("select ID from gameobject_display_info where ID in %s", (tuple(int(k) for k in m),)); have = {r[0] for r in h.fetchall()}
    for k, (fdid, box) in sorted(m.items(), key=lambda kv: int(kv[0])):
        d = int(k)
        if d in have: continue   # never overwrite a Midnight row
        h.execute("insert into gameobject_display_info (ID,GeoBoxMinX,GeoBoxMinY,GeoBoxMinZ,GeoBoxMaxX,GeoBoxMaxY,GeoBoxMaxZ,FileDataID,ObjectEffectPackageID,OverrideLootEffectScale,OverrideNameScale,AlternateDisplayType,ClientCreatureDisplayInfoID,ClientItemID,Unknown1100,VerifiedBuild) values (%s,%s,%s,%s,%s,%s,%s,%s,0,1.0,1.0,0,0,0,0,%s)", (d, *box, fdid, BUILD))
        h.execute("insert into hotfix_data (ID,UniqueID,TableHash,RecordID,Status,VerifiedBuild) values (%s,%s,%s,%s,1,%s)", (PUSH, UBASE + d, HASH, d, BUILD)); n += 1
    print('inserted', n, 'displays')


if __name__ == '__main__':
    undo() if sys.argv[1:2] == ['undo'] else apply()
