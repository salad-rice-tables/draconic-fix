import os
"""Q 9330014 'Initiation of Death': three objectives (Join the Initiates / Wait for Archon to complete the initiation / Report to Archon) + map markers. Idempotent.
Credits are given by lua/coa_initiation_scene.lua (1,2) and the Archon gossip (3). Needs a worldserver restart (quest_poi is loaded at startup) -- or .reload quest_template."""
import pymysql
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
Q, B = 9330014, 69933
OBJ = [(93300014, 9330321, 'Join the Initiates'), (93300114, 9330322, 'Wait for Archon Vel\'moth to complete the initiation'), (93300214, 9330323, 'Report to Archon Vel\'moth')]
W.execute('delete from quest_objectives where QuestID=%s', (Q,))
for i, (oid, cr, d) in enumerate(OBJ):
    W.execute('insert into quest_objectives (ID,QuestID,Type,`Order`,StorageIndex,ObjectID,Amount,ConditionalAmount,Flags,Flags2,ProgressBarWeight,ParentObjectiveID,Visible,Description,VerifiedBuild) values (%s,%s,0,%s,%s,%s,1,0,0,0,0,0,1,%s,%s)', (oid, Q, i, i, cr, d, B))
def box(cx, cy, r): return [(cx - r, cy - r), (cx + r, cy - r), (cx + r, cy + r), (cx - r, cy + r)]
TRIG, ARCH = (1079, -3045), (1036, -3021)          # trigger area / Archon (spec coordinates)
BLOBS = [(-1, 0, TRIG, 14), (0, 93300014, TRIG, 14), (1, 93300114, ARCH, 10), (2, 93300214, ARCH, 6)]
W.execute('delete from quest_poi where QuestID=%s', (Q,)); W.execute('delete from quest_poi_points where QuestID=%s', (Q,))
for idx, (oi, oid, c, r) in enumerate(BLOBS):
    W.execute('insert into quest_poi values (%s,0,%s,%s,%s,0,2222,1536,0,1,0,0,0,0,0,%s)', (Q, idx, oi, oid, B))
    for j, (x, y) in enumerate(box(c[0], c[1], r)): W.execute('insert into quest_poi_points values (%s,%s,%s,%s,%s,3285,%s)', (Q, idx, j, x, y, B))
W.execute('update quest_template set LogDescription=%s, QuestCompletionLog=%s where ID=%s', ('Join the new Initiates at the academy, wait for Archon Vel\'moth to finish the initiation, then report to him.', 'Report to Archon Vel\'moth.', Q))
print('ok')
