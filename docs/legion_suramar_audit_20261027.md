# Legion / Suramar spawn & phase audit — 2026-10-27

Read-only audit of `world` (live DB). No rows changed. Companion to
`npc_db_audit_20261026.md`; that report's position parity result does **not** cover Legion.

## 1. Why the 2026-10-26 audit did not validate Legion

| Dataset | Total creature rows | Map 1220 | Zone 7637 (Suramar) |
|---|---:|---:|---:|
| `world.creature` | 702,848 | 32,950 | 6,320 |
| `tdbfull1210.creature` | 262,623 | 867 | 0 |

TDB has 867 Legion spawns and **zero** Suramar zone rows, so "262,620 / 262,623 spawns
within 50 yd of TDB" says nothing about Suramar or the Broken Isles. A true Legion
position/GO parity check needs retail (Wowhead/sniff) data, not TDB.

## 2. Current counts

Map 1220 (Broken Isles), `world`:

| Zone | Area ID | Creatures | Phase 0 | GameObjects | Phase 0 |
|---|---:|---:|---:|---:|---:|
| Suramar | 7637 | 6,320 | 6,138 | 2,322 | 2,162 |
| Stormheim | 7541 | 5,209 | 5,116 | 1,255 | 1,249 |
| Broken Shore | 7543 | 4,830 | 4,353 | **117** | 115 |
| Highmountain | 7503 | 4,306 | 4,009 | 846 | 845 |
| Azsuna | 7334 | 4,280 | 4,076 | 749 | 738 |
| Val'sharah | 7558 | 3,720 | 3,610 | 1,003 | 1,002 |
| Dalaran | 7502 | 874 | 784 | 1,051 | 884 |
| Argus (map 1669) | — | 7,846 | 7,339 | 1,598 | 1,568 |

Suramar sub-areas:

| Area | Creatures | Phase 0 | GameObjects | Phase 0 |
|---|---:|---:|---:|---:|
| Shal'Aran (7928) | 37 | **0** | 149 | **0** |
| The Grand Promenade (7963) | 720 | 706 | 121 | 121 |

**Shal'Aran is 100 % quest-phased.** 33 creatures + 147 GOs sit in phase `41065`;
2 creatures in `41077`; 1 in `41067`; 1 in `41078`; 2 GOs in `41089`. None are phase 0.

## 3. Root cause of "Suramar was empty"

Character `guid 74` **Thalyteil** (level 45, map 1220, zone 7637) is parked at
`(1742.39, 4584.63, 124.015)` — inside Shal'Aran. The character has **no Suramar quests**
(12 rewarded quests total, none in Suramar; only 55660 and 9500001 in progress).

Phase `41065` ("Shal´Aran", the base cave state with Oculeth and all props) is gated by:

```
conditions: SourceTypeOrReferenceId=26, SourceGroup=41065,
            ConditionType=47 (quest status), ConditionValue1=40012,
            ConditionValue2=64 (rewarded), NegativeCondition=0
```

Phase `41077` (Thalyssra/Farodin) is likewise gated on quest `40012` rewarded.
The only Shal'Aran NPC a fresh character gets is Thalyssra in phase `41064`
(`guid 3000116010`, entry 97140) at `(1706.66, 4625.23, 124.006)` — 54 yd from
where the character is parked — because `41064` is active while `40012` is *not*
rewarded (negative condition).

So the cave's 37 NPCs and 149 GOs are all invisible until the intro chain is done:

```
Khadgar 90417 (Dalaran, phase 0)
  -> 39985 / 39986 / 39987 "Trail of Echoes"
  -> phases 41060 / 41061 / 41062
  -> 41064 (Thalyssra visible) -> 40012 "An Old Ally"
  -> 41065 / 41077 (Shal'Aran populated)
```

This is **quest-phase gating, not missing spawns**. The character was in Suramar
out of sequence (teleport/GM), so the cave legitimately looked empty.

Important nuance: the **city itself is not empty** — Grand Promenade has 706 phase-0
creatures and 121 phase-0 GOs. If the user was in Shal'Aran (as the saved position
shows), the "empty Suramar" impression comes from the cave, not the whole zone.

## 4. Quest / gameobject gaps (real content gaps)

### 4.1 Missing quest enders (no spawn anywhere)

Suramar (6):

| Quest | Title | Ender entry | Name |
|---|---|---|---|
| 40129 | Repairing the Source | 98736 | Deactivated Construct |
| 40674 | Jars for Jandvik | 101049 | Dagmyr |
| 44057 | A "Noble" Event | 100635 | Skyseer Ghrent |
| 44073 | Help from Within | 112547 | Tempomancer Virinya |
| 44080 | Friend of the Animals | 112627 | Curious Manasaber |
| 44176 | The Conveniences of Home | 113284 | Traveler's Banking Chest |

Other Legion zones: Stormheim 1, Highmountain 3, Azsuna 2, Val'sharah 1,
Broken Shore 0.

### 4.2 Type=2 gameobject objectives with a template but **no spawn**

| Zone | Quests | GO entries |
|---|---:|---:|
| Suramar | 6 | 12 |
| Highmountain | 14 | 13 |
| Broken Shore | 10 | 15 |
| Stormheim | 4 | 4 |
| Azsuna | 7 | 11 |
| Val'sharah | 3 | 3 |

Suramar list:

| Quest | Title | GO entry | Name |
|---|---|---|---|
| 42082 | The Shattered Locus | 249405 / 249413 / 249414 | Energetic Shard |
| 42230 | The Valewalker's Burden | 251047 | Fal'adora Beacon |
| 44002 | Undersea Survey | 253085–253088 | Surveying Pylons (N/E/W/S) |
| 44811 | Help on the Way | 266285 | The Magistrix Will Fall! |
| 44812 | Running on Empty | 266298 / 266301 | Purified Water / Shal'dorei Foodstuff |
| 44867 | Contain their Advance | 266996 | Marching Orders |

Plus `245487` (quest 40749 "A Token of Remembrance") has **no template at all**.
Most other missing GO objectives in Highmountain (63 entries) also lack templates
(12.x-only IDs not present in world or TDB).

### 4.3 Non-credit creature objectives without spawns

Raw count: Suramar 78 quests / 112 entries; Highmountain 270 / 146;
Stormheim 61 / 122; Azsuna 48 / 104; Val'sharah 50 / 88; Broken Shore 31 / 44.
This list is noisy (scenario copies, phase versions like Thalyssra 99482 /
Oculeth 101782, kill-credit proxies). Treat it as a review queue, not 1:1 missing NPCs.

### 4.4 Gameobject integrity

- 1 GO row without a template.
- 68 GO rows at `(0,0,0)`.
- 2,701 orphan rows in `gameobject_addon`.
- Broken Shore has only **117 GOs** for the whole zone (67 area 8554, 49 area 8336).
- Grand Promenade has 121 GOs, mostly 71 chairs, 18 supply caches, 11 benches —
  sparse versus retail city dressing.

## 5. Recommendations

1. **Do not claim Legion parity from TDB.** It has 867 map-1220 spawns and 0 in
   Suramar. Use Wowhead/sniff data for position and GO parity.
2. **Suramar hub:** if the goal is "retail feel when entering Shal'Aran", either
   (a) require the intro chain (current design — correct for normal play), or
   (b) add a small phase-0 fallback (Thalyssra/Oculeth/Khadgar) for GMs/testers,
   or (c) make `41065` unconditional. (c) is risky: it would show post-quest NPCs
   before the quest and can duplicate spawns.
3. **Add the missing quest GO spawns**: 12 Suramar, 13 Highmountain, 15 Broken Shore,
   4 Stormheim, 11 Azsuna, 3 Val'sharah. Coordinates from Wowhead; verify with
   `.gobject near` in-game.
4. **Broken Shore props:** 117 GOs is clearly low; add zone dressing and quest objects.
5. **City dressing:** Suramar City needs more props (lamps, stalls, banners, crates),
   not just chairs/benches.
6. **Cleanup:** 68 zero-position GOs, 2,701 GO addon orphans, 1 template-less GO row.
7. **Phase design (systemic):** in `PhaseShift::UpdateUnphasedFlag`, any non-cosmetic
   phase with `DefaultReferences == 0` clears `Unphased`, and `CanSee` then hides all
   phase-0 objects. Custom scene phases should either be **cosmetic** (flags |= 0x10)
   or bound to the exact sub-area, otherwise a quest phase empties the surrounding world.

## 6. Verification notes

- `worldserver` startup log `Server_2026-10-26_21-12-26.log`: 702,848 creatures loaded,
  no map-1220 / phase errors.
- `phase_area` area 7637: 209 rows, 202 conditioned. `SourceEntry=0` conditions in
  `conditions` apply to every area the phase is bound to (`ConditionMgr::addToPhases`),
  so they are not "unconditional".
- All figures above are direct `world` queries on 2026-10-27; the characters DB was
  read only for quest state.

## 7. Implementation 2026-10-27 (DB applied)

### 7.1 Suramar batch 1 - 12 missing quest GO entries

SQL: `Custom/sql/20261027_suramar_missing_quest_gos.sql` (+ `_undo.sql`).
All rows: map 1220, zone 7637, `PhaseId=0`, `spawnDifficulties='0'`,
`spawntimesecs=300`, `state=1`, `animprogress=255`, `size=-1`, `visibility=256`.

| Quest | Object | Name | Amount | Spawns | Area | GUID | Position |
|---:|---:|---|---:|---:|---:|---|---|
| 42082 | 249405 | Energetic Shard | 13 | 1 | 8158 Shattered Locus | 990000000102000001 | 2189.33, 5491.67, 1.60 |
| 42082 | 249413 | Energetic Shard | 13 | 1 | 8158 Shattered Locus | 990000000102000002 | 2206.75, 5500.25, 1.65 |
| 42082 | 249414 | Energetic Shard | 13 | 1 | 8158 Shattered Locus | 990000000102000003 | 2187.50, 5463.25, 1.60 |
| 42230 | 251047 | Fal'adora Beacon | 1 | 1 | 8163 Temple of Fal'adora | 990000000102000004 | 2370.00, 5443.00, 41.00 |
| 44002 | 253085 | Northern Surveying Pylon | 1 | 1 | 7917 Azuregale Bay | 990000000102000005 | 1373.00, 2294.00, -85.50 |
| 44002 | 253086 | Eastern Surveying Pylon | 1 | 1 | 7917 Azuregale Bay | 990000000102000006 | 1109.00, 2242.00, -139.00 |
| 44002 | 253087 | Western Surveying Pylon | 1 | 1 | 7917 Azuregale Bay | 990000000102000007 | 1348.00, 2525.00, -101.80 |
| 44002 | 253088 | Southern Surveying Pylon | 1 | 1 | 7917 Azuregale Bay | 990000000102000008 | 835.00, 2197.00, -85.40 |
| 44811 | 266285 | The Magistrix Will Fall! | 8 | 1 | 7970 Evermoon Commons | 990000000102000009 | 603.62, 4016.00, 39.55 |
| 44812 | 266298 | Magically Purified Water | 3 | 1 | 8149 Twilight Vineyards | 990000000102000010 | 1388.00, 3386.17, 135.38 |
| 44812 | 266301 | Shal'dorei Foodstuff | 5 | 1 | 8149 Twilight Vineyards | 990000000102000011 | 1283.83, 3174.67, 137.91 |
| 44867 | 266996 | Marching Orders | 17 | 1 | 8503 Felborne Outpost | 990000000102000012 | 1400.00, 2950.00, 112.05 |

Verification: 12/12 rows present. 9/12 are within 15 yd of a real ground spawn;
`249413`, `249414`, `266301` are 17-23 yd from the nearest spawn at the same level
(Shardmaiden Z 1.652 / Ancient Seed Z 1.592 / Tattered Silkwing Z 137.414). `251047`
has an explicit `quest_poi_points` Z=41 for the Temple of Fal'adora upper level; it is
0.15 yd in XY from the Portal to Shal'Aran but 22.9 yd above it, which is intentional,
not a floating object. The Shattered Locus has stacked levels (surface Z ~1.6, cave
Z ~-25, upper Z ~97); the shards were placed on the surface level next to Farodin
(Z 1.592) and the upper Shardmaiden / Crystallized Bough spawns. No GO overlap within
2 yd (and none within 2 yd with |dz| < 5); `266298` is 2.54 yd from a chair.

### 7.2 Broken Shore - 44 quest props + 9 dressing props (53 rows)

SQL: `Custom/sql/20261027_broken_shore_props.sql` (+ `_undo.sql`).
GUID range `990000000102100001`-`990000000102100053`. Quest props are anchored to the
actual target creatures, not to the `quest_poi_points` outline.

| Quest | Object | Name | Amount | Spawns | Area | Anchor |
|---:|---:|---|---:|---:|---:|---|
| 45178 | 267224 | Afflicted by the Fel Egg | 12 | 12 | 8587 Deadwood Landing | Wounded Captive (12 of 59) |
| 45542 | 267953 | Vital Supplies | 10 | 1 | 8550 The Hijacked Portal | fixed POI point |
| 45792 | 268626 | Fel Crystal | 5 | 5 | 8506 Felfire Pass | Felfire Supplicant (5 of 35) |
| 45934 | 267600 | Saltwater Crane Egg | 12 | 12 | 8576 Jagged Cove | Saltwater Crane (12 of 13) |
| 46126 | 267778 | Harpy Nest | 5 | 5 | 8587 Deadwood Landing | Bladefury Enforcer (Z > 5) |
| 46180 | 267846 | Raw Fel | 1 | 1 | 8602 Dark Stockades | fixed POI point |
| 46180 | 269131 | Raw Fel | 1 | 1 | 8602 Dark Stockades | fixed POI point |
| 46180 | 269136 | Raw Fel | 1 | 1 | 8602 Dark Stockades | fixed POI point |
| 46308 | 267041 | Fel-Infused Gunpowder Cache | 1 | 1 | 8542 Moonlight Ascent | fixed POI point |
| 46308 | 268428 | Fel Fire Bomb | 4 | 4 | 8542 Moonlight Ascent | Felblade Sentry (Z > 115) |
| 45970 | 268411 | Darkspear Bow | 25 | 1 | 8555 Screaming Cliffs | fixed POI centroid (sample) |

Dressing props reuse existing Broken Shore templates:

| Object | Name | Spawns | Areas |
|---:|---|---:|---|
| 252050 | Legion Brazier | 3 | 8587, 8506, 8550 |
| 266899 | Fel Fire | 2 | 8506, 8542 |
| 269028 | Fel Rune | 2 | 8602, 8555 |
| 265572 | Prison Cage | 1 | 8587 |
| 252049 | Soul Harvester | 1 | 8602 |

Verification: 53/53 rows have a real creature/GO within 20 yd at `|dz| <= 5`; 0 overlaps
with existing GOs within 2 yd. Per-area: 8506 7, 8542 6, 8550 2, 8555 2, 8576 12,
8587 19, 8602 5. The first pass used POI vertices and produced 29/53 no-ground rows; the
second pass uses creature anchors and produces 0/53.

Caveats: the Broken Shore quests are World Quests (`QuestType` 2/3, `QuestInfoID`
109/111/135, `Flags` 65536). The static phase-0 copies make the objects present but do
not implement retail WQ phase parity. Deferred: `268517` Fel Spreader (5, no POI),
`269154` Libram (17, no POI), `268409`/`268410` weapons (25 each, no POI), and the full
25x count for `268411`.

`Q42082` and `Q44867` remain blocked: creature `105585` has 0 spawns and `115961` /
`115962` have 0 spawns; the shard/order counts are still 1 vs 13/17. Add the missing
creatures and the full counts together.

DB changes were applied only; `worldserver` was not restarted in this pass. The rows load
on the next start. Verify with `.gobject near` and a quest character.
