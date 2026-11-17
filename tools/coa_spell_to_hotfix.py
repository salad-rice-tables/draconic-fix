"""CoA/Ascension 3.3.5 spell rows -> Midnight (12.1.5) hotfix SQL.
usage: python coa_spell_to_hotfix.py <spells_raw.json> <icons.json> <out_prefix> <push_id>
New spell id = 7000000 + old id. Sub-table row ids = 72000000 + table offset + counter. Undo file generated. Idempotent (DELETE then INSERT)."""
import json, sys, os, csv

raw, icons_p, out, push = sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4])
OFF, ROW0, BUILD = 7000000, 72000000, 69933
WAGO = r'C:\WowServer\Custom\data\wago'
H = {'spell_name': 1187407512, 'spell': 3776013982, 'spell_effect': 4030871717, 'spell_misc': 3322146344,
     'spell_cooldowns': 4193483863, 'spell_categories': 3689412649, 'spell_class_options': 680438657,
     'spell_levels': 501138918, 'spell_power': 2712461791, 'spell_x_spell_visual': 666345498}
sp = json.load(open(raw, encoding='utf-8'))
icons = json.load(open(icons_p, encoding='utf-8'))


def ids(name):
    return {int(r['ID']) for r in csv.DictReader(open(os.path.join(WAGO, name), encoding='utf-8'))}


okCat = ids('SpellCategory.csv')   # a Category id missing from SpellCategory.db2 asserts (crash) on cast
okCast, okDur, okRange, okRad = ids('SpellCastTimes.csv'), ids('SpellDuration.csv'), ids('SpellRange.csv'), ids('SpellRadius.csv')
# stand-ins for Ascension custom visuals: shadow bolt / frostbolt / fireball
VIS = {32: 77979, 16: 64829, 4: 182402}


def sg(v):
    v = int(v) & 0xFFFFFFFF
    return v - (1 << 32) if v >= (1 << 31) else v


def q(s):
    return "'" + str(s if s is not None else '').replace("\\", "\\\\").replace("'", "''") + "'"


def arr(s, n):
    v = [int(x) for x in str(s).strip('{}').split(',') if x != ''] if s else []
    return (v + [0] * n)[:n]


rows = {t: [] for t in H}
hot = []
ctr = {t: (int(sys.argv[5]) if len(sys.argv) > 5 else 0) for t in H}   # optional 5th arg: row-id counter start, so a delta push never reuses row ids
order = list(H)


def nid(t):
    ctr[t] += 1
    return ROW0 + order.index(t) * 100000 + ctr[t]


KNOWN = set(json.load(open('C:/WowServer/Custom/data/coa/all_spells_raw.json', encoding='utf-8'))) | set(sp)   # every converted CoA spell (delta pushes too)


def sid(i):
    return OFF + int(i) if str(i) in KNOWN else int(i)


for key, s in sorted(sp.items(), key=lambda kv: int(kv[0])):
    new = OFF + int(key)
    desc = s['description'] or ''
    rows['spell_name'].append(f"({new}, {q(s['name'])}, {BUILD})")
    rows['spell'].append(f"({new}, {q(s['rank_text'])}, {q(desc)}, {q(s['buff_text'] or desc)}, {BUILD})")
    hot += [(H['spell_name'], new), (H['spell'], new)]
    a = arr(s['attributes'], 8) + [0] * 9
    cast = int(s['cast_time_ms'] or 0)
    dur = int(s['duration_ms'] or 0)
    rng = int(s['range_id'] or 0)
    fdid = icons.get(key, {}).get('fileDataID', 134400)
    mid = nid('spell_misc')
    rows['spell_misc'].append(
        f"({mid}, {', '.join(str(sg(x)) for x in a[:17])}, 0, {cast if cast in okCast else 0}, {dur if dur in okDur else 0}, 0, "
        f"{rng if rng in okRange else 0}, {int(s['school_mask'] or 1)}, 0, 0, 0, {fdid}, 0, 0, 0, 0, 0, {new}, {BUILD})")
    hot.append((H['spell_misc'], mid))
    effs = json.loads(s['effects']) if isinstance(s['effects'], str) else s['effects']
    dmg = False
    for n, e in enumerate(effs):
        eid = nid('spell_effect')
        bp = int(e['base_points']) + (1 if int(e['die_sides']) == 1 else 0)
        m = (e.get('spell_class_mask') or [0, 0, 0]) + [0, 0, 0, 0]
        trig = sid(e['trigger_spell']) if e['trigger_spell'] else 0
        misc1 = e['misc_value']
        if e['id'] == 28 and misc1:
            misc1 = OFF + int(misc1)  # summon: creature entry moves to the CoA creature range
        rad = e['radius_index'] if e['radius_index'] in okRad else 0
        if e['id'] == 2 or (e['id'] == 6 and e['aura'] in (3, 89)):
            dmg = True
        rows['spell_effect'].append(
            f"({eid}, {e['aura']}, 0, {n}, {e['id']}, {e['amplitude']}, 0, {int(e['aura_period'])}, {e['bonus_coefficient']}, "
            f"{e['chain_amplitude']}, {e['chain_targets']}, {e['item_type']}, {e['mechanic']}, 0, 0, {e['real_points_per_level']}, "
            f"{trig}, 0, 1, 0, 0, 0, 1, {bp}, 0, 0, {misc1}, {e['misc_value_b']}, {rad}, 0, {sg(m[0])}, {sg(m[1])}, {sg(m[2])}, 0, "
            f"{e['implicit_target_a']}, {e['implicit_target_b']}, {new}, {BUILD})")
        hot.append((H['spell_effect'], eid))
    if s['recovery_time_ms'] or s['gcd_ms']:
        i = nid('spell_cooldowns')
        rows['spell_cooldowns'].append(f"({i}, 0, 0, {int(s['recovery_time_ms'] or 0)}, {int(s['gcd_ms'] or 0)}, 0, {new}, {BUILD})")
        hot.append((H['spell_cooldowns'], i))
    i = nid('spell_categories')
    rows['spell_categories'].append(
        f"({i}, 0, {int(s['category'] or 0) if int(s['category'] or 0) in okCat else 0}, {int(s['damage_class'] or 0)}, 0, {int(s['dispel_type'] or 0)}, {int(s['mechanic'] or 0)}, 0, 0, 0, {new}, {BUILD})")
    hot.append((H['spell_categories'], i))
    ff = arr(s['spell_family_flags'], 4)
    i = nid('spell_class_options')
    rows['spell_class_options'].append(f"({i}, {new}, 0, {int(s['spell_family_id'] or 0)}, {sg(ff[0])}, {sg(ff[1])}, {sg(ff[2])}, {sg(ff[3])}, {BUILD})")
    hot.append((H['spell_class_options'], i))
    i = nid('spell_levels')
    rows['spell_levels'].append(f"({i}, 0, {int(s['max_level'] or 0)}, 0, {int(s['base_level'] or 0)}, {int(s['spell_level'] or 0)}, {new}, {BUILD})")
    hot.append((H['spell_levels'], i))
    if int(s['power_cost'] or 0) or float(s['power_cost_percent'] or 0):
        pt = int(s['power_type'])
        pct = float(s['power_cost_percent'] or 0)
        if pt == 0 and not pct:
            pct = round(int(s['power_cost']) / 80.0, 2)  # 3.3.5 absolute mana -> % of base mana (tunable)
        cost = 0 if pt == 0 else int(s['power_cost'])
        i = nid('spell_power')
        rows['spell_power'].append(f"({i}, 0, {cost}, 0, 0, 0, 0, {pct if pt == 0 else 0}, 0, 0, 0, {pt}, 0, 0, {new}, {BUILD})")
        hot.append((H['spell_power'], i))
    sm = int(s['school_mask'] or 1)
    if dmg and cast and sm in VIS:
        i = nid('spell_x_spell_visual')
        rows['spell_x_spell_visual'].append(f"({i}, 0, {VIS[sm]}, 1, 0, 0, 0, 0, 0, 0, 0, 0, {new}, {BUILD})")
        hot.append((H['spell_x_spell_visual'], i))

COLS = {
    'spell_name': '`ID`, `Name`, `VerifiedBuild`',
    'spell': '`ID`, `NameSubtext`, `Description`, `AuraDescription`, `VerifiedBuild`',
    'spell_misc': '`ID`, ' + ', '.join(f'`Attributes{i}`' for i in range(1, 18)) + ', `DifficultyID`, `CastingTimeIndex`, `DurationIndex`, `PvPDurationIndex`, `RangeIndex`, `SchoolMask`, `Speed`, `LaunchDelay`, `MinDuration`, `SpellIconFileDataID`, `ActiveIconFileDataID`, `ContentTuningID`, `ShowFutureSpellPlayerConditionID`, `SpellVisualScript`, `ActiveSpellVisualScript`, `SpellID`, `VerifiedBuild`',
    'spell_effect': '`ID`, `EffectAura`, `DifficultyID`, `EffectIndex`, `Effect`, `EffectAmplitude`, `EffectAttributes`, `EffectAuraPeriod`, `EffectBonusCoefficient`, `EffectChainAmplitude`, `EffectChainTargets`, `EffectItemType`, `EffectMechanic`, `EffectPointsPerResource`, `EffectPosFacing`, `EffectRealPointsPerLevel`, `EffectTriggerSpell`, `BonusCoefficientFromAP`, `PvpMultiplier`, `Coefficient`, `Variance`, `ResourceCoefficient`, `GroupSizeBasePointsCoefficient`, `EffectBasePoints`, `ScalingClass`, `TargetNodeGraph`, `EffectMiscValue1`, `EffectMiscValue2`, `EffectRadiusIndex1`, `EffectRadiusIndex2`, `EffectSpellClassMask1`, `EffectSpellClassMask2`, `EffectSpellClassMask3`, `EffectSpellClassMask4`, `ImplicitTarget1`, `ImplicitTarget2`, `SpellID`, `VerifiedBuild`',
    'spell_cooldowns': '`ID`, `DifficultyID`, `CategoryRecoveryTime`, `RecoveryTime`, `StartRecoveryTime`, `AuraSpellID`, `SpellID`, `VerifiedBuild`',
    'spell_categories': '`ID`, `DifficultyID`, `Category`, `DefenseType`, `DiminishType`, `DispelType`, `Mechanic`, `PreventionType`, `StartRecoveryCategory`, `ChargeCategory`, `SpellID`, `VerifiedBuild`',
    'spell_class_options': '`ID`, `SpellID`, `ModalNextSpell`, `SpellClassSet`, `SpellClassMask1`, `SpellClassMask2`, `SpellClassMask3`, `SpellClassMask4`, `VerifiedBuild`',
    'spell_levels': '`ID`, `DifficultyID`, `MaxLevel`, `MaxPassiveAuraLevel`, `BaseLevel`, `SpellLevel`, `SpellID`, `VerifiedBuild`',
    'spell_power': '`ID`, `OrderIndex`, `ManaCost`, `ManaCostPerLevel`, `ManaPerSecond`, `PowerDisplayID`, `AltPowerBarID`, `PowerCostPct`, `PowerCostMaxPct`, `OptionalCostPct`, `PowerPctPerSecond`, `PowerType`, `RequiredAuraSpellID`, `OptionalCost`, `SpellID`, `VerifiedBuild`',
    'spell_x_spell_visual': '`ID`, `DifficultyID`, `SpellVisualID`, `Probability`, `Flags`, `Priority`, `SpellIconFileID`, `ActiveIconFileID`, `ViewerUnitConditionID`, `ViewerPlayerConditionID`, `CasterUnitConditionID`, `CasterPlayerConditionID`, `SpellID`, `VerifiedBuild`',
}
newids = ','.join(str(OFF + int(k)) for k in sp)
sql = [f"-- CoA Necromancer spells -> Midnight hotfixes (generated by coa_spell_to_hotfix.py). push {push}. Undo: {os.path.basename(out)}_undo.sql",
       f"DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = {push};"]
undo = [f"DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = {push};"]
for t in H:
    k = 'ID' if t in ('spell_name', 'spell') else 'SpellID'
    d = f"DELETE FROM `hotfixes`.`{t}` WHERE `{k}` IN ({newids});"
    sql.append(d)
    undo.append(d)
for t, r in rows.items():
    if r:
        sql.append(f"INSERT INTO `hotfixes`.`{t}` ({COLS[t]}) VALUES\n" + ",\n".join(r) + ";")
sql.append("INSERT INTO `hotfixes`.`hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES\n"
           + ",\n".join(f"({push}, {3000000000 + (push - 1950000) * 10000 + n}, {h}, {rid}, 1, {BUILD})" for n, (h, rid) in enumerate(hot)) + ";")
open(out + '.sql', 'w', encoding='utf-8').write("\n".join(sql) + "\n")
open(out + '_undo.sql', 'w', encoding='utf-8').write("\n".join(undo) + "\n")
print('spells', len(sp), {t: len(r) for t, r in rows.items()}, 'hotfix rows', len(hot))
