# BfA phasing audit and dead-phase stopgap (2026-11-07)

Scope: Battle for Azeroth maps 1642 (Zandalar), 1643 (Kul Tiras), 1718
(Nazjatar), 2268 (Mechagon), `world.creature` and `world.gameobject`, against
retail `hotfixes.phase_area` / `phase` and wago `AreaTable.csv`.

## Result

Most BfA phasing is correct. Phases are counted as reachable when the mapped
area is on the same continent as the spawn map. `creature.zoneId = 0` is not
proof that an NPC is invisible: for example `121599` King Rastakhan has
`zoneId=0`, but phase `44983` is mapped to Zuldazar `8499`.

After the batch below:

| map | creature spawns | phased | phase 0 | OK | OK_MAP | ORPHAN_ALL | OTHER_MAP |
|---|---:|---:|---:|---:|---:|---:|---:|
| 1642 Zandalar | 33020 | 5154 | 27866 | 3293 | 1743 | 101 | 17 |
| 1643 Kul Tiras | 35905 | 4924 | 30981 | 3297 | 1281 | 344 | 2 |
| 1718 Nazjatar | 5370 | 261 | 5109 | 44 | 216 | 1 | 0 |
| 2268 Mechagon | 42 | 42 | 0 | 38 | 4 | 0 | 0 |

`ORPHAN_ALL` is dominated by phase `50` (`Gilneas Lev 6`): 401 spawns / 126
entries, but 121 entries already have another phase. Only five entries are
unique to phase 50: `120169`, `132691`, `136183`, `138408`, `141838`.

Zuldazar area `8499`: 13,083 creature spawns / 1,518 entries; 1,440 phased.
Before the batch, 73 spawns used dead phases: 59 phase 50, 13 phase 9464,
1 phase 9465. After fixing Nokano, 72 remain.

## Applied batch

`20261107_bfa_dead_phase_quests.sql` (+ `_undo.sql`) sets 34 unique
quest-critical spawns from dead phases to phase 0:

| entry | rows | old phase | quest link |
|---|---:|---:|---|
| 127669 Nokano | 1 | 9464 | Q47442 Curse of Jani |
| 130879 Vigil Hill Refugee | 22 | 49405 | Q49405 objective |
| 141078 Vigil Hill Refugee | 1 | 49405 | ender Q49405, starter Q49869/Q52431 |
| 132985 Zandalari Soldier | 8 | 133122 | Q50081 objective x6 |
| 136183 Crushtacean | 1 | 50 | Q51901 objective |
| 141838 Galeheart | 1 | 50 | Q49741 objective |

Evidence for "dead": phases 9464/49405/133122/50 have no row in
`world.phase_area` or `hotfixes.phase_area`, no `player_condition.PhaseID`,
no `area_trigger.PhaseID`, no phase aura in `hotfixes.spell_effect`
(`EffectAura` 261/262/263), and no script reference. These were the only BfA
spawns of each NPC, so the quests could not see their target.

Verification: 34/34 GUIDs have `PhaseId=0`; 34/34 match the pre-change TSV.
Post-fix audit: `NPC_PHASE_ORPHAN` 0; `ORPHAN_ALL` 480 -> 446.

## Deferred

- `135966` Faithless Scrollkeeper: 15 Vol'dun spawns (8501, areas 8875/9346)
  use phase 41649, which is mapped only to Stormsong 9042. Wrong map; not
  quest-linked directly (kill credit 135969 is used by Q50750/51957/51963).
- `135900` Rastari Enforcer: 12 Zuldazar spawns in phase 9464; not quest-linked.
- `130880`/`130889`: other unique phase 49405 spawns; non-quest.
- `150332` Zelling's Boat / `150516` Jailer Hatewell: phase 54958, Q54958;
  may be scene actors/summons.
- `120169` Princess Talanji, `132691` Caravan Brutosaur, `138408` Mindslaved
  Berserker: unique phase 50, no quest link.
- `138417` Burning Flames: 13 phase 19866 spawns; likely visual.
- `134976` Krag'wa the Huge: 1 phase 10613 spawn; no quest link.
- Q51200 The Black Sheep: condition phase 44310/area 9042 exists, but no
  `phase_area` row and no spawn with phase 44310.

## False positives

`NO_STARTER` 1203, `NO_ENDER` 1127, `OBJ_NO_CREDIT` 1187 are inflated by
world quests / bonus objectives (QuestInfoID 109/135/259/260) and summoned
NPCs such as Kua'fon 133678/133679/135296. Do not use them as a bug count.

## Files

- Audit before: `docs/bfa_audit_20261107.{md,json,csv}`
- Audit after: `docs/bfa_audit_20261107_afterfix.{md,json,csv}`
- SQL: `sql/20261107_bfa_dead_phase_quests.sql`, `_undo.sql`
- Backup: `sql/20261107_bfa_dead_phase_quests_before.tsv`
- Tools: `tools/oc_bfa_audit.py`, `tools/oc_bfa_phase_check.py`

Restart worldserver to load the `creature` changes. Test Q47442,
Q49405 -> Q49869/Q52431, Q50081, Q51901, Q49741, and check for early/duplicate
visibility before replacing phase 0 with a proper `phase_area` + condition.
