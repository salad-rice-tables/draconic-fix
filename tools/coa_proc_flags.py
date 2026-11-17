import os
"""Reads ProcFlags (+ chance / charges) of every CoA spell from the CoA client Spell.dbc and writes them into hotfixes.spell_aura_options
(ProcTypeMask1 = 3.3.5 procFlags; the Midnight proc flag bits 0..24 have the same layout) for the +7000000 spells. Server side only.
usage: python coa_proc_flags.py [dry] | undo   (undo removes ProcTypeMask1 again and the rows this script inserted, ids 75600000+)"""
import pickle, struct, sys
import mpyq
import pymysql

BS = chr(92)
NAME = 'dbfilesclient' + BS + 'spell.dbc'
BASE = 75600000
c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True); q = c.cursor()
if len(sys.argv) > 1 and sys.argv[1] == 'undo':
    q.execute("delete from spell_aura_options where ID between %s and %s", (BASE, BASE + 999999)); print('removed rows', q.rowcount)
    q.execute("update spell_aura_options set ProcTypeMask1=0 where SpellID between 7000000 and 7999999"); print('cleared masks', q.rowcount); sys.exit()
SRC = 'C:/Games/Conquest of Azerothcore/COA/Data'
import glob
data = None
for p in sorted(glob.glob(SRC + '/*.MPQ') + glob.glob(SRC + '/enUS/*.MPQ')):
    try:
        a = mpyq.MPQArchive(p, listfile=True)
    except Exception:
        continue
    for f in (a.files or []):
        n = f.decode('latin1') if isinstance(f, bytes) else f
        if n.lower() == NAME:
            d = a.read_file(f)
            if d:
                data = d; print('Spell.dbc from', p.split('/')[-1])
magic, rc, fc, rs, ss = struct.unpack('<4sIIII', data[:20])
print('records', rc, 'fields', fc)
recs = data[20:20 + rc * rs]
rows = {}
for i in range(rc):
    v = struct.unpack('<%dI' % fc, recs[i * rs:(i + 1) * rs])
    rows[v[0]] = (v[35], v[36], v[37])   # procFlags, procChance, procCharges
print('with procFlags:', sum(1 for r in rows.values() if r[0]))
dry = len(sys.argv) > 1 and sys.argv[1] == 'dry'
upd = ins = 0
q.execute("select max(ID) from spell_aura_options where ID between %s and %s", (BASE, BASE + 999999)); n = (q.fetchone()[0] or BASE - 1) + 1
for sid, (flags, chance, charges) in rows.items():
    if not flags:
        continue
    new = 7000000 + sid
    q.execute("select ID from spell_name where ID=%s", (new,))
    if not q.fetchone():
        continue
    q.execute("select ID from spell_aura_options where SpellID=%s", (new,))
    r = q.fetchall()
    ch = min(chance, 100) if 0 < chance < 200 else 0
    if r:
        if not dry:
            q.execute("update spell_aura_options set ProcTypeMask1=%s where SpellID=%s and ProcTypeMask1=0", (flags & 0xFFFFFFFF, new))
        upd += 1
    else:
        if not dry:
            q.execute("insert into spell_aura_options (ID,DifficultyID,CumulativeAura,ProcCategoryRecovery,ProcChance,ProcCharges,SpellProcsPerMinuteID,ProcTypeMask1,ProcTypeMask2,SpellID,VerifiedBuild) values (%s,0,0,0,%s,%s,0,%s,0,%s,69933)",
                      (n, ch, charges, flags & 0xFFFFFFFF, new))
        n += 1; ins += 1
print('updated', upd, 'inserted', ins, '(dry)' if dry else '')
