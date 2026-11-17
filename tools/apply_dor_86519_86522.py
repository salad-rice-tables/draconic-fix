import os
import sys, pymysql
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
con = pymysql.connect(host='127.0.0.1', port=3306, user='root', password=os.environ.get('DB_PASSWORD', ''), db='world', charset='utf8mb4')
cur = con.cursor()
raw = open(r'C:\WowServer\Custom\sql\20261017_dor_86519_86522.sql', encoding='utf-8').read()
lines = [l for l in raw.split('\n') if not l.strip().startswith('--')]
stmts = [s.strip() for s in ('\n'.join(lines)).split(';') if s.strip()]
n = 0
for s in stmts:
    cur.execute(s)
    n += 1
    print('aff:', cur.rowcount, '|', s[:110].replace('\n', ' '))
con.commit()
print('statements:', n)
print('=== verify ===')
cur.execute("SELECT ID,QuestID,Type,`Order`,StorageIndex,ObjectID,Amount,Flags,Description FROM quest_objectives WHERE QuestID IN (86519,86520,86521,86522,95276) ORDER BY QuestID,`Order`,ID")
for r in cur.fetchall(): print('obj:', r)
cur.execute("SELECT * FROM phase_area WHERE AreaId=15969 AND PhaseId=27428")
print('phase_area:', cur.fetchall())
cur.execute("SELECT ID, Flags FROM hotfixes.phase WHERE ID IN (45789,45791,45793)")
print('hotfix phases:', cur.fetchall())
con.close()
