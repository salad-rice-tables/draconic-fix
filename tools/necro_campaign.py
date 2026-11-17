"""Necromancer initiation = a real Campaign (campaign "!" over quest givers, Campaign group in the quest log) + Q1 retitled "A Disturbance on a Hidden Path".
Idempotent. Hotfix rows copy the pattern of the existing custom campaigns 9001-9010 (conditions 9001000-9001002 are reused: prerequisite / stalled / completed).
Needs ONE worldserver restart (QuestMgr builds the campaign tables at startup) and the client DBCache.bin deleted.
Undo: sql/20261113_necro_campaign_undo.sql (written by this script)."""
import json, os, pymysql
ROOT = r'C:\WowServer\Custom'
CAMP, PUSH, UID0, BUILD = 9011, 1960010, 4100140000, 69933
QUESTS = [9330011, 9330012, 9330013, 9330014, 9330015]
H_CAMPAIGN, H_CXQL, H_QLXQ = 3656496423, 13326836, 2361489494   # TableHash, same order the 9001 rows were pushed in
Q1 = dict(LogTitle='A Disturbance on a Hidden Path',
          LogDescription='Follow the Hidden Path beyond the Valley of Trials and investigate the necromantic disturbance. Speak with the Tome of Oblivion you find there.',
          QuestDescription='Something has disturbed the balance of death in this region.\n\nI have sensed a strange necromantic presence along the Hidden Path, beyond the Valley of Trials. Its nature is unfamiliar, yet powerful.\n\nFollow the path and investigate. I want to know what has entered this land.',
          QuestCompletionLog='Follow the Hidden Path and read the Tome of Oblivion.')

# 1. text source of truth (build script + generator read this) and the live quest row
p = os.path.join(ROOT, 'data', 'necro_init', 'quests.json')
j = json.load(open(p, encoding='utf-8')); j['9330011'].update(Q1)
json.dump(j, open(p, 'w', encoding='utf-8'), indent=1, ensure_ascii=False)
W = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='world', autocommit=True).cursor()
H = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True).cursor()
W.execute('select LogTitle, LogDescription, QuestDescription, QuestCompletionLog from quest_template where ID=9330011'); old = W.fetchone()
W.execute('update quest_template set LogTitle=%s, LogDescription=%s, QuestDescription=%s, QuestCompletionLog=%s where ID=9330011',
          (Q1['LogTitle'], Q1['LogDescription'], Q1['QuestDescription'], Q1['QuestCompletionLog']))
W.execute("delete from quest_template_locale where ID=9330011")   # a stale translation would hide the new text

# 2. campaign rows
# conditions: 9001000-2 are LEVEL-gated (min level 10), a level 1 Necromancer fails them -> no campaign "!". Prerequisite / Stalled = 0 (always met),
# Completed = new condition 9011002 (quest 9330015 rewarded), cloned from 9001002.
COND = CAMP * 1000 + 2
H.execute('delete from player_condition where ID=%s', (COND,))
H.execute('create temporary table _pc select * from player_condition where ID=9001002')
H.execute('update _pc set ID=%s, CurrentCompletedQuestID1=%s', (COND, QUESTS[-1]))
H.execute('insert into player_condition select * from _pc'); H.execute('drop temporary table _pc')
pre, stall, comp = 0, 0, COND
for t, k in (('campaign', 'ID'), ('campaign_x_quest_line', 'ID')):
    H.execute(f'delete from {t} where {k}=%s', (CAMP,))
H.execute('delete from quest_line_x_quest where ID between %s and %s', (CAMP * 10, CAMP * 10 + 9))
H.execute('insert into campaign (ID, Title, Description, UiTextureKitID, RewardQuestID, Prerequisite, Stalled, Completed, OnlyStallIf, UiQuestDetailsThemeID, Flags, DisplayPriority, SortAsNormalQuest, UseMinimalHeader, VerifiedBuild) '
          'values (%s,%s,%s,5767,0,%s,%s,%s,0,73,0,1311,0,0,%s)',
          (CAMP, 'The Necromancer Path', "A fallen necromancer's last task, a crystal humming with Maldraxxi anima, and a House that wants answers.", pre, stall, comp, BUILD))
H.execute('insert into campaign_x_quest_line (ID, CampaignID, QuestLineID, OrderIndex, VerifiedBuild) values (%s,%s,%s,0,%s)', (CAMP, CAMP, CAMP, BUILD))
for i, q in enumerate(QUESTS):
    H.execute('insert into quest_line_x_quest (ID, QuestLineID, QuestID, OrderIndex, Flags, Unknown1110, VerifiedBuild) values (%s,%s,%s,%s,0,0,%s)', (CAMP * 10 + i, CAMP, q, i, BUILD))
H.execute('delete from hotfix_data where Id=%s', (PUSH,))
rows = [(3108775943, COND), (H_CAMPAIGN, CAMP), (H_CXQL, CAMP)] + [(H_QLXQ, CAMP * 10 + i) for i in range(len(QUESTS))]
for n, (h, rid) in enumerate(rows):
    H.execute('insert into hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild) values (%s,%s,%s,%s,1,%s)', (PUSH, UID0 + n, h, rid, BUILD))
# the quest_line row itself is not hotfixable (no quest_line table here); 9001-9010 work the same way

undo = ("-- undo necro campaign\nDELETE FROM hotfixes.hotfix_data WHERE Id=%d;\nDELETE FROM hotfixes.player_condition WHERE ID=%d;\nDELETE FROM hotfixes.campaign WHERE ID=%d;\nDELETE FROM hotfixes.campaign_x_quest_line WHERE ID=%d;\n"
        "DELETE FROM hotfixes.quest_line_x_quest WHERE ID BETWEEN %d AND %d;\nUPDATE world.quest_template SET LogTitle=%r, LogDescription=%r, QuestDescription=%r, QuestCompletionLog=%r WHERE ID=9330011;\n"
        % ((PUSH, COND, CAMP, CAMP, CAMP * 10, CAMP * 10 + 9) + tuple(old)))
open(os.path.join(ROOT, 'sql', '20261113_necro_campaign_undo.sql'), 'w', encoding='utf-8').write(undo)
print('done: quest 9330011 renamed, campaign', CAMP, 'with', len(QUESTS), 'quests, push', PUSH)

# 3. class-campaign marker: QuestInfo 9011 with Modifiers 0x400 (= "Important"), the client then draws the Important marker, which tools/necro_marker.py
#    replaces with the teal campaign shield. Retail Campaign (journey) markers stay stock.
QI = 9011
H.execute('delete from quest_info where ID=%s', (QI,))
H.execute('insert into quest_info (ID, InfoName, Type, Modifiers, Profession, VerifiedBuild) values (%s,%s,0,1024,0,%s)', (QI, 'Class Campaign', BUILD))
H.execute('delete from hotfix_data where Id=%s and UniqueId=%s', (PUSH, UID0 + 20))
H.execute('insert into hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild) values (%s,%s,756143922,%s,1,%s)', (PUSH, UID0 + 20, QI, BUILD))
W.execute('update quest_template set QuestInfoID=%s where ID between 9330011 and 9330015', (QI,))
open(os.path.join(ROOT, 'sql', '20261113_necro_campaign_undo.sql'), 'a', encoding='utf-8').write(
    "DELETE FROM hotfixes.quest_info WHERE ID=9011;\nDELETE FROM hotfixes.hotfix_data WHERE Id=1960010 AND UniqueId=%d;\nUPDATE world.quest_template SET QuestInfoID=0 WHERE ID BETWEEN 9330011 AND 9330015;\n" % (UID0 + 20))
print('class campaign marker: QuestInfoID', QI)
