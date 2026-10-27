# -*- coding: utf-8 -*-
"""
gen_legacy_20261018.py -- Legacy of the Amani (92901-93012) retail cleanup + chain activation.

Builds:
  C:\\WowServer\\Custom\\sql\\20261018_legacy_retail_cleanup.sql      (+ _undo.sql)
  C:\\WowServer\\Custom\\sql\\20261018_legacy_chain.sql               (+ _undo.sql)

Run:
  python gen_legacy_20261018.py            -> build files + print summary (dry run)
  python gen_legacy_20261018.py --apply    -> build + apply to world DB

Sources of truth:
  - tdb1210_world (TDB 12.1.0, VerifiedBuild 69497) = retail quest_template/objectives
  - Wowhead/Warcraft Wiki texts (Completion/Progress) parsed from wiki_sections.txt
  - wago CSV (QuestPOIBlob/Point) for quest area markers
  - wago CSV + probes for spawn positions [APPROX where noted]
"""
import csv
import io
import os
import re
import sys
import datetime
import pymysql

SQL_DIR = r"C:\WowServer\Custom\sql"
WIKI = r"C:\Users\brani\AppData\Local\Temp\opencode\wiki_sections.txt"
WAGO = r"C:\WowServer\Custom\data\wago"

QUESTS = [92901, 92904, 92907, 92951, 92952, 92953, 92954, 92955, 92957, 92958, 93010, 93011, 93012]

STARTERS = {92901: 255659, 92904: 255660, 92907: 256260, 92955: 256260, 92957: 253834, 92958: 253833,
            92952: 253833, 92953: 253805, 92951: 253806, 92954: 253806, 93010: 253806, 93011: 253840, 93012: 259778}
ENDERS = {92901: 255659, 92904: 256260, 92907: 256260, 92955: 253834, 92957: 253832, 92958: 253833,
          92952: 253805, 92953: 253804, 92951: 253804, 92954: 253806, 93010: 253840, 93011: 259778, 93012: 253848}

PREV = {92901: 92900, 92904: 92901, 92907: 92904, 92955: 92907, 92957: 92955, 92958: 92955,
        92952: 92957, 92953: 92952, 92951: 92952, 92954: 92953, 93010: 92954, 93011: 93010, 93012: 93011}
# parallel branches -> extra condition rows (quest must be completed|rewarded)
EXTRA_COND = {92952: 92958, 92954: 92951}

NPCFLAG3 = [253804, 253805, 253806, 253832, 253833, 253834, 253840, 253841, 253848, 255659, 255660, 256260, 259778]
NPCFLAG1 = [255448, 256011, 256329]

# creature spawns: (entry, phase, x, y, z, o, spawntimesecs)
CREATURE_SPAWNS = [
    # Talonstrike Terrace (terasa) - phase 0
    (253806, 0, 6113.9, -7620.5, 80.0, 0.7, 300),
    (253804, 0, 6107.6, -7621.6, 80.0, 5.0, 300),
    (253805, 0, 6109.4, -7626.5, 80.0, 1.6, 300),
    # Numazon kemp - phase 0
    (253834, 0, 5975.9, -7127.2, 184.0, 1.8, 300),
    (253832, 0, 5981.6, -7124.0, 184.0, 3.5, 300),
    (253833, 0, 5979.2, -7131.4, 184.0, 2.4, 300),
    # Warlord's Stair - phase 0
    (253840, 0, 5052.0, -6899.5, 248.0, 3.6, 300),
    (253841, 0, 5058.5, -6893.0, 248.0, 4.0, 300),   # Kinduru pri oltari (93011 "speak")
    (253841, 0, 5048.0, -6896.0, 248.0, 2.0, 300),   # Kinduru - retail kopia pozicia
    # Atal'Aman - phase 0
    (259778, 0, 4323.4, -7611.0, 161.0, 4.2, 300),
    (253848, 0, 4221.0, -7560.0, 168.0, 2.0, 300),
    # Patracie miesto (area 16194) - phase 46735
    (256329, 46735, 5344.0, -6144.0, 256.0, 2.2, 300),
    # Hex masters - phase 0
    (256576, 0, 6061.4, -7811.2, 35.0, 3.9, 300),
    (256582, 0, 5831.0, -7802.0, 22.0, 1.3, 300),
    (256583, 0, 6028.3, -7698.2, 31.0, 5.5, 300),
]
# Injured Amani Warriors (255448) - phase 46731, 16x (amount 15 + rezerva)
WARRIORS = [
    (128.3, 755.1, 1162.0), (168.3, 805.5, 1149.0), (184.1, 856.1, 1149.5), (229.3, 795.7, 1156.9),
    (294.2, 875.0, 1170.6), (218.9, 876.3, 1160.8), (121.7, 796.3, 1150.5), (138.8, 812.5, 1149.5),
    (230.4, 839.3, 1151.4), (263.4, 808.5, 1162.4), (265.7, 884.5, 1171.0), (201.3, 885.4, 1161.5),
    (324.2, 984.5, 1177.2), (331.8, 979.3, 1177.0), (343.4, 975.0, 1177.0), (327.5, 943.7, 1177.2),
]

# smart_scripts rows: (source_type, entryorguid, id, event_type, action_type, param1, param2, comment)
SMART_ROWS = [
    (1, 616622, 200, 64, 33, 256334, 0, "92907: Woodworking Tool -> KC 256334 (tool found) [zaloha k Eluna]"),
    (1, 616622, 201, 64, 33, 256358, 0, "92907: Woodworking Tool -> KC 256358 (wood gathered)"),
    (1, 616628, 200, 64, 33, 256335, 0, "92907: Woodworking Supplies -> KC 256335 (supplies found)"),
    (1, 616628, 201, 64, 33, 256358, 0, "92907: Woodworking Supplies -> KC 256358 (wood gathered)"),
    (1, 567906, 200, 64, 33, 259822, 0, "93012: Kinduru's Mortar -> KC 259822 (herbs ground)"),
    (0, 256329, 200, 64, 153, 0, 0, "92907: Befuddled Amani Mask -> TalkTo kredit 467385 (Repair Started)"),
    (0, 256329, 201, 64, 33, 256221, 0, "92907: Befuddled Amani Mask -> KC 256221 (mask caught)"),
    (0, 255448, 200, 64, 33, 255402, 0, "92901: Injured Amani Warrior -> KC 255402 (assisted)"),
    (0, 256576, 200, 6, 33, 256623, 0, "92953: Hex Master Jintagga died -> KC 256623 (hex master slain)"),
    (0, 256576, 201, 6, 33, 256584, 0, "92953: Hex Master Jintagga died -> KC 256584"),
    (0, 256582, 200, 6, 33, 256623, 0, "92953: Hex Master Soye'mal died -> KC 256623 (hex master slain)"),
    (0, 256582, 201, 6, 33, 256585, 0, "92953: Hex Master Soye'mal died -> KC 256585"),
    (0, 256583, 200, 6, 33, 256623, 0, "92953: Hex Master Uy'okan died -> KC 256623 (hex master slain)"),
    (0, 256583, 201, 6, 33, 256586, 0, "92953: Hex Master Uy'okan died -> KC 256586"),
    (0, 253840, 200, 64, 33, 259717, 0, "93011: Zul'jan (Warlord's Stair) -> KC 259717 (speak)"),
    (0, 253841, 200, 64, 33, 256640, 0, "93011: Kinduru -> KC 256640 (speak after defense)"),
    (0, 253834, 200, 64, 33, 259032, 0, "92952: Zul'jan (Numazon) -> KC 259032 (optional objective)"),
    (0, 253806, 210, 64, 33, 259030, 0, "92952: Zul'jan (Talonstrike) -> KC 259030 (required objective)"),
    (0, 253806, 220, 64, 33, 259396, 0, "92954: Zul'jan -> KC 259396 (dungeon briefing)"),
    (0, 253804, 200, 64, 33, 259421, 0, "92954: Kinduru -> KC 259421 (listened to Kinduru)"),
    (0, 253848, 200, 64, 33, 256648, 0, "93012: Zul'jarra -> KC 256648 (speak to Zul'jarra)"),
]

# loot rows: (creature_entry, item, chance, comment)
LOOT_ROWS = [
    (236180, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (236181, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (236184, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (236185, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (248768, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (248771, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (248756, 262752, 35, "92951 Vilebranch Scroll [APPROX 35%]"),
    (236180, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (236181, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (236184, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (236185, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (248768, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (248771, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (248756, 262659, 35, "92958 Vilebranch Hex Fetish [APPROX 35%]"),
    (248605, 262791, 100, "92954 Malacrass's Notes (Rak'tul, 100%, QuestRequired)"),
]

CLEAN_HEADER = """-- =====================================================================
-- 20261018_legacy_retail_cleanup.sql
-- Legacy of the Amani (92901-93012): navrat k retail datum (TDB 12.1.0, VerifiedBuild 69497).
-- Co robi:
--  1) quest_template 13 questov -> presne TDB hodnoty (ContentTuning, RewardXP/MoneyDifficulty,
--     RewardBonusMoney=0, RewardSpell, vsetky texty LogDescription/QuestDescription/...)
--     -> odstranuje custom Claude-made texty a reward cisla.
--  2) quest_objectives -> TDB riadky (odstranuje custom 46683600/46683601 a vsetky custom objective riadky).
--  3) quest_request_items (Progress texty) + quest_offer_reward (Completion texty) z Warcraft Wiki.
--  4) smart_scripts: maze rozbity stub 256011 (event 62 -> action 62 teleport, param 912047043).
-- Poradie: spustit PRED 20261018_legacy_chain.sql.
-- Undo: 20261018_legacy_retail_cleanup_undo.sql
-- =====================================================================
SET NAMES utf8mb4;
"""

CHAIN_HEADER = """-- =====================================================================
-- 20261018_legacy_chain.sql
-- Legacy of the Amani (92901-93012): aktivacia celeho chainu.
-- Co robi:
--  1) creature_queststarter/ender pre 13 questov (retail priradenie z Wowhead mapy+faz).
--  2) npcflag: questgiver/gossip priznaky pre nove NPC (nizsie zoznam).
--  3) Nove spawny NPC (retail entry na POI poziciach; [APPROX] kde ide o odhad).
--  4) Nove gameobjecty: Woodworking Tool/Supplies (fork custom 616622/616628) + Ancient Amani Tablet.
--  5) PhaseId 0 pre Kinduru's Mortar a 3 ohne v Atal'Aman (fazy 45677/45679 visia na quest 86666).
--  6) quest_template_addon PrevQuestID + conditions (vetvy 92952/92954).
--  7) quest_poi/quest_poi_points import z wago CSV (retail markery).
--  8) creature_loot_template: Vilebranch Scroll/Hex Fetish [APPROX 35%] + Malacrass's Notes 100%.
--  9) smart_scripts kredity (gossip 64 / death 6) + TALKTO 467385 (action 153).
-- Vyzaduje: lua_scripts/legacy_amani_chain.lua (rootway, boxy, ohne, vlny, skip menu, milestone loot).
-- Undo: 20261018_legacy_chain_undo.sql
-- =====================================================================
SET NAMES utf8mb4;
"""


class Sql:
    def __init__(self, conn):
        self.conn = conn
        self.fwd = []
        self.undo = []

    def add(self, fwd, undo=None):
        self.fwd.append(fwd)
        if undo:
            self.undo.append(undo)

    def L(self, v):
        if v is None:
            return "NULL"
        lit = self.conn.literal(v)
        return lit.decode("utf-8") if isinstance(lit, bytes) else str(lit)

    def q(self, sql, args=None):
        cur = self.conn.cursor()
        cur.execute(sql, args)
        return cur.fetchall()


def strip_wiki(s):
    if not s:
        return s
    s = re.sub(r"\{\{[^}]*\}\}", "", s)
    s = re.sub(r"\[\[([^\]|]+)\|([^\]]+)\]\]", r"\2", s)
    s = re.sub(r"\[\[([^\]]+)\]\]", r"\1", s)
    s = s.replace("&nbsp;", " ").replace("&#39;", "'").replace("&quot;", '"').replace("&amp;", "&")
    return s.strip()


def parse_wiki():
    txt = io.open(WIKI, encoding="utf-8").read()
    out = {}
    for m in re.finditer(r"={5,}\s*(\d+)\s*={5,}(.*?)(?=={5,}\s*\d+\s*={5,}|\Z)", txt, re.S):
        qid = int(m.group(1))
        body = m.group(2)
        secs = {}
        for sm in re.finditer(r"--- ([A-Za-z ]+):\s*\n(.*?)(?=\n--- [A-Za-z ]+:|\Z)", body, re.S):
            secs[sm.group(1).strip()] = strip_wiki(sm.group(2))
        out[qid] = secs
    return out


def main():
    apply = "--apply" in sys.argv
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    conn = pymysql.connect(host="127.0.0.1", port=3306, user="root", password="admin",
                           charset="utf8mb4", cursorclass=pymysql.cursors.DictCursor, autocommit=True)
    s = Sql(conn)
    wiki = parse_wiki()

    def header(title, kind, undo=False):
        return ("-- =====================================================================\n"
                "-- 20261018_legacy_%s.sql%s\n"
                "-- Vygenerovane: %s (gen_legacy_20261018.py) -- %s\n"
                "-- =====================================================================\n"
                "SET NAMES utf8mb4;\n" % (kind, " [UNDO]" if undo else "", now, title))

    # =========================================================
    # CLEANUP
    # =========================================================
    wcols = [r["Field"] for r in s.q("SHOW COLUMNS FROM world.quest_template")]
    tcols = [r["Field"] for r in s.q("SHOW COLUMNS FROM tdb1210_world.quest_template")]
    shared = [c for c in tcols if c in wcols and c != "ID"]
    restored, missing = 0, []
    for qid in QUESTS:
        tw = s.q("SELECT * FROM tdb1210_world.quest_template WHERE ID=%s", (qid,))
        ww = s.q("SELECT * FROM world.quest_template WHERE ID=%s", (qid,))
        if not tw:
            missing.append(qid)
            continue
        tw, ww = tw[0], ww[0]
        diffs = [c for c in shared if tw[c] != ww[c]]
        if not diffs:
            continue
        setf = ", ".join("`%s`=%s" % (c, s.L(tw[c])) for c in diffs)
        setu = ", ".join("`%s`=%s" % (c, s.L(ww[c])) for c in diffs)
        s.add("-- quest %d: %d stlpcov obnovenych z TDB (%s)" % (qid, len(diffs), ", ".join(diffs[:8]) + ("..." if len(diffs) > 8 else "")),
              None)
        s.add("UPDATE `world`.`quest_template` SET %s WHERE `ID`=%d;" % (setf, qid),
              "UPDATE `world`.`quest_template` SET %s WHERE `ID`=%d;" % (setu, qid))
        restored += 1 if diffs else 0
    if missing:
        print("POZOR: TDB nema quest_template pre:", missing)

    # quest_objectives
    ocols = [r["Field"] for r in s.q("SHOW COLUMNS FROM tdb1210_world.quest_objectives")]
    ocol_list = ", ".join("`%s`" % c for c in ocols)
    obj_counts = {}
    for qid in QUESTS:
        wrows = s.q("SELECT * FROM world.quest_objectives WHERE QuestID=%s", (qid,))
        trows = s.q("SELECT * FROM tdb1210_world.quest_objectives WHERE QuestID=%s ORDER BY ID", (qid,))
        obj_counts[qid] = (len(wrows), len(trows))
        if not wrows and not trows:
            continue
        s.add("-- quest %d: objectives world=%d -> TDB=%d" % (qid, len(wrows), len(trows)))
        s.add("DELETE FROM `world`.`quest_objectives` WHERE `QuestID`=%d;" % qid)
        if wrows:
            vals = ",\n".join("(%s)" % ", ".join(s.L(r[c]) for c in ocols) for r in wrows)
            s.undo.append("INSERT INTO `world`.`quest_objectives` (%s) VALUES\n%s;" % (ocol_list, vals))
        else:
            s.undo.append("-- quest %d: ziadne povodne objectives" % qid)
        for r in trows:
            s.add("INSERT INTO `world`.`quest_objectives` (%s) VALUES (%s);" % (ocol_list, ", ".join(s.L(r[c]) for c in ocols)),
                  None)
        if trows:
            s.undo.append("DELETE FROM `world`.`quest_objectives` WHERE `QuestID`=%d AND ID IN (%s);"
                          % (qid, ", ".join(str(r["ID"]) for r in trows)))

    # quest_request_items (Progress) - len chýbajúce
    have_ri = {r["ID"] for r in s.q("SELECT ID FROM world.quest_request_items WHERE ID IN (%s)" % ",".join(map(str, QUESTS)))}
    for qid in QUESTS:
        if qid in have_ri:
            continue
        prog = (wiki.get(qid) or {}).get("Progress")
        if not prog:
            continue
        s.add("INSERT INTO `world`.`quest_request_items` (`ID`, `CompletionText`) VALUES (%d, %s);" % (qid, s.L(prog)),
              "DELETE FROM `world`.`quest_request_items` WHERE `ID`=%d;" % qid)

    # quest_offer_reward (Completion)
    have_or = {r["ID"]: r["RewardText"] for r in s.q("SELECT ID, RewardText FROM world.quest_offer_reward WHERE ID IN (%s)" % ",".join(map(str, QUESTS)))}
    for qid in QUESTS:
        comp = (wiki.get(qid) or {}).get("Completion")
        if not comp:
            continue
        if qid in have_or:
            s.add("UPDATE `world`.`quest_offer_reward` SET `RewardText`=%s WHERE `ID`=%d;" % (s.L(comp), qid),
                  "UPDATE `world`.`quest_offer_reward` SET `RewardText`=%s WHERE `ID`=%d;" % (s.L(have_or[qid]), qid))
        else:
            s.add("INSERT INTO `world`.`quest_offer_reward` (`ID`, `RewardText`) VALUES (%d, %s);" % (qid, s.L(comp)),
                  "DELETE FROM `world`.`quest_offer_reward` WHERE `ID`=%d;" % qid)

    # smart_scripts cleanup: broken 256011 stub
    stub = s.q("SELECT * FROM world.smart_scripts WHERE source_type=0 AND entryorguid=256011")
    scol = [r["Field"] for r in s.q("SHOW COLUMNS FROM world.smart_scripts")]
    scol_list = ", ".join("`%s`" % c for c in scol)
    if stub:
        s.add("-- rozbity Rootway stub (event 62 -> teleport param 912047043), riesi Eluna")
        s.add("DELETE FROM `world`.`smart_scripts` WHERE `source_type`=0 AND `entryorguid`=256011;")
        vals = ",\n".join("(%s)" % ", ".join(s.L(r[c]) for c in scol) for r in stub)
        s.undo.append("INSERT INTO `world`.`smart_scripts` (%s) VALUES\n%s;" % (scol_list, vals))

    cleanup_fwd = header("RETAIL CLEANUP", "retail_cleanup") + "\n" + "\n".join(s.fwd) + "\n"
    cleanup_undo = header("RETAIL CLEANUP", "retail_cleanup", undo=True) + "\n" + "\n".join(reversed(s.undo)) + "\n"

    # =========================================================
    # CHAIN
    # =========================================================
    c = Sql(conn)

    # 1) starters/enders
    cur_rows = lambda tab: c.q("SELECT * FROM world.%s WHERE quest IN (%s)" % (tab, ",".join(map(str, QUESTS))))
    qs_cols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.creature_queststarter")]
    for tab, mapping in (("creature_queststarter", STARTERS), ("creature_questender", ENDERS)):
        old = cur_rows(tab)
        if old:
            vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in qs_cols) for r in old)
            c.undo.append("INSERT INTO `world`.`%s` (%s) VALUES\n%s;" % (tab, ", ".join("`%s`" % x for x in qs_cols), vals))
        c.add("DELETE FROM `world`.`%s` WHERE `quest` IN (%s);" % (tab, ",".join(map(str, QUESTS))))
        for qid in QUESTS:
            c.add("INSERT INTO `world`.`%s` (`quest`, `id`) VALUES (%d, %d);" % (tab, qid, mapping[qid]))
        c.undo.append("DELETE FROM `world`.`%s` WHERE `quest` IN (%s);" % (tab, ",".join(map(str, QUESTS))))

    # 2) npcflag
    for entry, flag in [(e, 3) for e in NPCFLAG3] + [(e, 1) for e in NPCFLAG1]:
        old = c.q("SELECT npcflag FROM world.creature_template WHERE entry=%s", (entry,))
        if not old:
            print("POZOR: creature_template nema entry", entry)
            continue
        c.add("UPDATE `world`.`creature_template` SET `npcflag`=`npcflag`|%d WHERE `entry`=%d;" % (flag, entry),
              "UPDATE `world`.`creature_template` SET `npcflag`=%s WHERE `entry`=%d;" % (c.L(old[0]["npcflag"]), entry))

    # 3) creature spawns
    base = 3510002001
    used = {r["guid"] for r in c.q("SELECT guid FROM world.creature WHERE guid BETWEEN %d AND %d" % (base, base + 400))}
    g = base
    spawn_guids = []
    for (entry, phase, x, y, z, o, secs) in CREATURE_SPAWNS:
        while g in used:
            g += 1
        spawn_guids.append(g)
        c.add("INSERT INTO `world`.`creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`MovementType`,`ScriptName`,`VerifiedBuild`) "
              "VALUES (%d,%d,0,0,0,'0',0,%d,0,%.4f,%.4f,%.4f,%.4f,%d,0,0,'',0);" % (g, entry, phase, x, y, z, o, secs))
        g += 1
    for (x, y, z) in WARRIORS:
        while g in used:
            g += 1
        spawn_guids.append(g)
        c.add("INSERT INTO `world`.`creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`MovementType`,`ScriptName`,`VerifiedBuild`) "
              "VALUES (%d,255448,2694,0,0,'0',0,46731,0,%.4f,%.4f,%.4f,%.2f,30,0,0,'',0);" % (g, x, y, z, (g % 628) / 100.0))
        g += 1
    c.undo.append("DELETE FROM `world`.`creature` WHERE `guid` IN (%s);" % ",".join(map(str, spawn_guids)))

    # 4) GO spawns: tools/supplies + tablety
    go_base = 3510003001
    used_go = {r["guid"] for r in c.q("SELECT guid FROM world.gameobject WHERE guid BETWEEN %d AND %d" % (go_base, go_base + 400))}
    # tablet entry: prvy volny v 616700-616799
    used_tpl = {r["entry"] for r in c.q("SELECT entry FROM world.gameobject_template WHERE entry BETWEEN 616700 AND 616799")}
    tablet = None
    for e in range(616700, 616800):
        if e not in used_tpl:
            tablet = e
            break
    assert tablet, "ziadny volny GO entry v 616700-616799"
    print("Tablet GO entry:", tablet)

    # tablet body z 92957 POI (objIdx == 0)
    blobs = list(csv.DictReader(io.open(os.path.join(WAGO, "QuestPOIBlob.csv"), encoding="utf-8-sig")))
    pts_all = list(csv.DictReader(io.open(os.path.join(WAGO, "QuestPOIPoint.csv"), encoding="utf-8-sig")))
    pts_by_blob = {}
    for pt in pts_all:
        pts_by_blob.setdefault(pt["QuestPOIBlobID"], []).append(pt)
    tablet_pts = []
    for b in blobs:
        if int(b["QuestID"]) == 92957 and int(b["ObjectiveIndex"]) == 0:
            for pt in sorted(pts_by_blob.get(b["ID"], []), key=lambda p: int(p["ID"])):
                tablet_pts.append((float(pt["X"]), float(pt["Y"]), float(pt["Z"])))
    tablet_pts = tablet_pts[:8]
    if len(tablet_pts) < 4:
        print("POZOR: malo tablet POI bodov:", len(tablet_pts))

    gg = go_base
    go_guids = []
    go_spawns = [("tools", 616622, 46735, 5345.2, -6078.0, 257.6, 1.0),
                 ("supplies", 616628, 46735, 5340.4, -6161.2, 257.6, 4.0)]
    for (x, y, z) in tablet_pts:
        go_spawns.append(("tablet", tablet, 0, x, y, z, 0.0))
    for (tag, entry, phase, x, y, z, o) in go_spawns:
        while gg in used_go:
            gg += 1
        go_guids.append(gg)
        c.add("INSERT INTO `world`.`gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) "
              "VALUES (%d,%d,0,0,0,'0',0,%d,0,%.4f,%.4f,%.4f,%.4f,0,0,0,0,300,255,1,'',0); -- %s" % (gg, entry, phase, x, y, z, o, tag))
        gg += 1
    c.undo.append("DELETE FROM `world`.`gameobject` WHERE `guid` IN (%s);" % ",".join(map(str, go_guids)))

    # 5) phase fixy: mortar + 3 ohne -> 0 (fazy viazu na quest 86666); box duplikaty -> 46735
    for guid, new_phase, note in (
        (990000000101166776, 0, "Kinduru's Mortar - viditelny vzdy"),
        (990000000101167876, 0, "ohen 1 (Atal'Aman) - viditelny vzdy"),
        (990000000101167877, 0, "ohen 2 (Atal'Aman) - viditelny vzdy"),
        (990000000101167878, 0, "ohen 3 (Atal'Aman) - viditelny vzdy"),
        (990000000101167838, 46735, "box duplikat (5332,-6123) -> phase 46735"),
        (990000000101167839, 46735, "box duplikat (5330,-6121) -> phase 46735"),
    ):
        old = c.q("SELECT PhaseId FROM world.gameobject WHERE guid=%s", (guid,))
        if not old:
            print("POZOR: gameobject guid chyba", guid)
            continue
        c.add("UPDATE `world`.`gameobject` SET `PhaseId`=%d WHERE `guid`=%d; -- %s" % (new_phase, guid, note),
              "UPDATE `world`.`gameobject` SET `PhaseId`=%s WHERE `guid`=%d;" % (c.L(old[0]["PhaseId"]), guid))

    # 5b) GO template normalizacie: custom tool/supplies/mortar -> SmartAI (+ Data19=0)
    for entry, zero_d19 in ((616622, True), (616628, True), (567906, False)):
        old = c.q("SELECT AIName, Data19 FROM world.gameobject_template WHERE entry=%s", (entry,))
        if not old:
            print("POZOR: gameobject_template nema entry", entry)
            continue
        if zero_d19:
            c.add("UPDATE `world`.`gameobject_template` SET `AIName`='SmartAI', `Data19`=0 WHERE `entry`=%d; -- tool/supplies: SmartAI + Data19 cleanup" % entry,
                  "UPDATE `world`.`gameobject_template` SET `AIName`=%s, `Data19`=%s WHERE `entry`=%d;" % (c.L(old[0]["AIName"]), c.L(old[0]["Data19"]), entry))
        else:
            c.add("UPDATE `world`.`gameobject_template` SET `AIName`='SmartAI' WHERE `entry`=%d; -- mortar SmartAI" % entry,
                  "UPDATE `world`.`gameobject_template` SET `AIName`=%s WHERE `entry`=%d;" % (c.L(old[0]["AIName"]), entry))

    # 6) tablet template
    tcols_go = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.gameobject_template")]
    vals = {col: 0 for col in tcols_go if col.startswith("Data")}
    vals.update({"entry": tablet, "type": 10, "displayId": 2652, "name": "Ancient Amani Tablet", "IconName": "Interact",
                 "castBarCaption": "", "unk1": "", "size": 1.0, "ContentTuningId": 0, "RequiredLevel": 0,
                 "AIName": "", "ScriptName": "", "StringId": None, "VerifiedBuild": 0})
    collist = ", ".join("`%s`" % col for col in tcols_go)
    c.add("INSERT INTO `world`.`gameobject_template` (%s) VALUES (%s);" % (collist, ", ".join(c.L(vals[col]) for col in tcols_go)),
          "DELETE FROM `world`.`gameobject_template` WHERE `entry`=%d;" % tablet)

    # 7) quest_template_addon
    acols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.quest_template_addon")]
    old_addon = c.q("SELECT * FROM world.quest_template_addon WHERE ID IN (%s)" % ",".join(map(str, QUESTS)))
    acl = ", ".join("`%s`" % x for x in acols)
    c.add("DELETE FROM `world`.`quest_template_addon` WHERE `ID` IN (%s);" % ",".join(map(str, QUESTS)))
    c.undo.append("DELETE FROM `world`.`quest_template_addon` WHERE `ID` IN (%s);" % ",".join(map(str, QUESTS)))
    for qid in QUESTS:
        c.add("INSERT INTO `world`.`quest_template_addon` (`ID`, `PrevQuestID`) VALUES (%d, %d); -- %s" % (qid, PREV[qid], "chain"))
    if old_addon:
        vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in acols) for r in old_addon)
        c.undo.append("INSERT INTO `world`.`quest_template_addon` (%s) VALUES\n%s;" % (acl, vals))

    # 8) conditions (vetvy)
    old_cond = c.q("SELECT * FROM world.conditions WHERE SourceTypeOrReferenceId=19 AND SourceEntry IN (%s)" % ",".join(map(str, EXTRA_COND.keys())))
    ccols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.conditions")]
    ccl = ", ".join("`%s`" % x for x in ccols)
    cvals = {col: 0 for col in ccols}
    cvals.update({"SourceTypeOrReferenceId": 19, "SourceGroup": 0, "SourceId": 0, "ElseGroup": 0,
                  "ConditionTypeOrReference": 47, "ConditionTarget": 0, "ConditionValue2": 66, "ConditionValue3": 0,
                  "ConditionStringValue1": "", "NegativeCondition": 0, "ErrorType": 0, "ErrorTextId": 0, "ScriptName": ""})
    c.add("DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry` IN (%s);" % ",".join(map(str, EXTRA_COND.keys())))
    c.undo.append("DELETE FROM `world`.`conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry` IN (%s);" % ",".join(map(str, EXTRA_COND.keys())))
    for qid, req in EXTRA_COND.items():
        cv = dict(cvals)
        cv["SourceEntry"] = qid
        cv["ConditionValue1"] = req
        cv["Comment"] = "Legacy of the Amani: quest %d vyzaduje %d complete|rewarded" % (qid, req)
        c.add("INSERT INTO `world`.`conditions` (%s) VALUES (%s);" % (ccl, ", ".join(c.L(cv[col]) for col in ccols)))
    if old_cond:
        vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in ccols) for r in old_cond)
        c.undo.append("INSERT INTO `world`.`conditions` (%s) VALUES\n%s;" % (ccl, vals))

    # 9) 93012 reward item (Akiki) - wiki: 268557; RewardSpell 0 (TDB 1281585 nie je v hotfixes)
    old_r = c.q("SELECT RewardItem1, RewardAmount1, RewardSpell FROM world.quest_template WHERE ID=93012")
    if old_r:
        c.add("UPDATE `world`.`quest_template` SET `RewardItem1`=268557, `RewardAmount1`=1, `RewardSpell`=0 WHERE `ID`=93012; -- wiki reward (Akiki)",
              "UPDATE `world`.`quest_template` SET `RewardItem1`=%s, `RewardAmount1`=%s, `RewardSpell`=%s WHERE `ID`=93012;" % (c.L(old_r[0]["RewardItem1"]), c.L(old_r[0]["RewardAmount1"]), c.L(old_r[0]["RewardSpell"])))

    # 10) quest_poi import
    my_blobs = [b for b in blobs if int(b["QuestID"]) in QUESTS]
    my_blobs.sort(key=lambda b: int(b["ID"]))
    old_poi = c.q("SELECT * FROM world.quest_poi WHERE QuestID IN (%s)" % ",".join(map(str, QUESTS)))
    old_pop = c.q("SELECT * FROM world.quest_poi_points WHERE QuestID IN (%s)" % ",".join(map(str, QUESTS)))
    poi_cols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.quest_poi")]
    pop_cols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.quest_poi_points")]
    poi_cl = ", ".join("`%s`" % x for x in poi_cols)
    pop_cl = ", ".join("`%s`" % x for x in pop_cols)
    c.add("DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (%s);" % ",".join(map(str, QUESTS)))
    c.add("DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (%s);" % ",".join(map(str, QUESTS)))
    c.undo.append("DELETE FROM `world`.`quest_poi` WHERE `QuestID` IN (%s);" % ",".join(map(str, QUESTS)))
    c.undo.append("DELETE FROM `world`.`quest_poi_points` WHERE `QuestID` IN (%s);" % ",".join(map(str, QUESTS)))
    per_q_idx = {}
    npoi = 0
    for b in my_blobs:
        qid = int(b["QuestID"])
        idx = per_q_idx.get(qid, 0)
        per_q_idx[qid] = idx + 1
        row = {col: 0 for col in poi_cols}
        row.update({"QuestID": qid, "BlobIndex": idx, "Idx1": idx,
                    "ObjectiveIndex": int(b["ObjectiveIndex"]), "QuestObjectiveID": int(b["ObjectiveID"]),
                    "QuestObjectID": 0, "MapID": int(b["MapID"]), "UiMapID": int(b["UiMapID"]),
                    "Priority": 0, "Flags": int(b["Flags"]),
                    "PlayerConditionID": int(b["PlayerConditionID"]),
                    "NavigationPlayerConditionID": int(b["NavigationPlayerConditionID"]), "VerifiedBuild": 0})
        c.add("INSERT INTO `world`.`quest_poi` (%s) VALUES (%s);" % (poi_cl, ", ".join(c.L(row[col]) for col in poi_cols)))
        npoi += 1
        for pi, pt in enumerate(sorted(pts_by_blob.get(b["ID"], []), key=lambda p: int(p["ID"]))):
            prow = {col: 0 for col in pop_cols}
            prow.update({"QuestID": qid, "Idx1": idx, "Idx2": pi,
                         "X": int(pt["X"]), "Y": int(pt["Y"]), "Z": int(pt["Z"]), "VerifiedBuild": 0})
            c.add("INSERT INTO `world`.`quest_poi_points` (%s) VALUES (%s);" % (pop_cl, ", ".join(c.L(prow[col]) for col in pop_cols)))
    if old_poi:
        vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in poi_cols) for r in old_poi)
        c.undo.append("INSERT INTO `world`.`quest_poi` (%s) VALUES\n%s;" % (poi_cl, vals))
    if old_pop:
        vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in pop_cols) for r in old_pop)
        c.undo.append("INSERT INTO `world`.`quest_poi_points` (%s) VALUES\n%s;" % (pop_cl, vals))

    # 11) loot
    loot_cols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.creature_loot_template")]
    loot_cl = ", ".join("`%s`" % x for x in loot_cols)
    nloot = 0
    for (entry, item, chance, comment) in LOOT_ROWS:
        diff = c.q("SELECT LootID FROM world.creature_template_difficulty WHERE Entry=%s ORDER BY DifficultyID LIMIT 1", (entry,))
        lootid = (diff[0]["LootID"] if diff and diff[0]["LootID"] else entry)
        exist = c.q("SELECT COUNT(*) n FROM world.creature_loot_template WHERE Entry=%s AND Item=%s", (lootid, item))[0]["n"]
        if exist:
            print("loot existuje, preskakujem:", lootid, item)
            continue
        row = {col: None for col in loot_cols}
        row.update({"Entry": lootid, "ItemType": 0, "Item": item, "Chance": float(chance), "QuestRequired": 1,
                    "LootMode": 1, "GroupId": 0, "MinCount": 1, "MaxCount": 1, "Comment": comment})
        c.add("INSERT INTO `world`.`creature_loot_template` (%s) VALUES (%s);" % (loot_cl, ", ".join(c.L(row[col]) for col in loot_cols)))
        c.undo.append("DELETE FROM `world`.`creature_loot_template` WHERE `Entry`=%d AND `Item`=%d;" % (lootid, item))
        nloot += 1

    # 12) smart_scripts rows
    ss_cols = [r["Field"] for r in c.q("SHOW COLUMNS FROM world.smart_scripts")]
    ss_cl = ", ".join("`%s`" % x for x in ss_cols)
    nsai = 0
    for (st, entry, sid, ev, ac, p1, p2, comment) in SMART_ROWS:
        old = c.q("SELECT * FROM world.smart_scripts WHERE source_type=%s AND entryorguid=%s AND id=%s" % (st, entry, sid))
        c.add("DELETE FROM `world`.`smart_scripts` WHERE `source_type`=%d AND `entryorguid`=%d AND `id`=%d;" % (st, entry, sid))
        row = {col: 0 for col in ss_cols}
        row.update({"source_type": st, "entryorguid": entry, "id": sid, "link": 0, "Difficulties": "",
                    "event_type": ev, "event_phase_mask": 0, "event_chance": 100, "event_flags": 0,
                    "event_param_string": "", "action_type": ac, "action_param1": p1, "action_param2": p2,
                    "action_param_string": None, "target_type": 7, "target_param_string": None,
                    "comment": comment})
        c.add("INSERT INTO `world`.`smart_scripts` (%s) VALUES (%s);" % (ss_cl, ", ".join(c.L(row[col]) for col in ss_cols)))
        if old:
            vals = ",\n".join("(%s)" % ", ".join(c.L(r[col]) for col in ss_cols) for r in old)
            c.undo.append("INSERT INTO `world`.`smart_scripts` (%s) VALUES\n%s;" % (ss_cl, vals))
        c.undo.append("DELETE FROM `world`.`smart_scripts` WHERE `source_type`=%d AND `entryorguid`=%d AND `id`=%d;" % (st, entry, sid))
        nsai += 1

    chain_fwd = header("CHAIN", "chain") + "\n" + "\n".join(c.fwd) + "\n"
    # undo poradie otocit (neskorsie operacie prve)
    chain_undo = header("CHAIN", "chain", undo=True) + "\n" + "\n".join(reversed(c.undo)) + "\n"

    # zapis suborov
    for name, content in (("20261018_legacy_retail_cleanup.sql", cleanup_fwd),
                          ("20261018_legacy_retail_cleanup_undo.sql", cleanup_undo),
                          ("20261018_legacy_chain.sql", chain_fwd),
                          ("20261018_legacy_chain_undo.sql", chain_undo)):
        with io.open(os.path.join(SQL_DIR, name), "w", encoding="utf-8", newline="\n") as f:
            f.write(content)
        print("zapisane:", name, len(content), "znakov")

    print("---")
    print("quest_template restore:", restored, "questov | TDB chyba:", missing)
    print("objectives world->TDB:", obj_counts)
    print("POI blobs:", npoi, "| loot riadkov:", nloot, "| smart riadkov:", nsai)
    print("spawn guidov:", spawn_guids[0], "-", spawn_guids[-1], "| GO guidov:", go_guids[0], "-", go_guids[-1])
    print("tablet entry:", tablet, "| tablet bodov:", len(tablet_pts))

    if apply:
        print("=== APLIKUJEM CLEANUP ===")
        cur = conn.cursor()
        for stmt in s.fwd:
            if stmt.strip().startswith("--") or stmt.strip() == "":
                continue
            cur.execute(stmt)
        print("cleanup OK,", len(s.fwd), "statementov")
        print("=== APLIKUJEM CHAIN ===")
        for stmt in c.fwd:
            if stmt.strip().startswith("--") or stmt.strip() == "":
                continue
            cur.execute(stmt)
        print("chain OK,", len(c.fwd), "statementov")
        print("=== APLIKOVANE ===")
    conn.close()


if __name__ == "__main__":
    main()
