# NPC / world DB audit — 2026-10-26

**Scope:** all creature spawns in `world.creature` (702,848 rows, 82,343 distinct entries, 530 maps) and `world.creature_template` (232,684 rows).
**Baseline:** `tdbfull1210.creature` (262,623 retail spawns), wago `Map.csv` + `Phase_12.1.5.70391.csv`, core `dbc/enUS/Map.db2`.
**Mode:** read-only; no DB changes were made.

---

## Verdict

| Check | Result |
|---|---|
| Spawn → `creature_template` | **PASS** — 0 orphan spawns |
| Spawned template → `creature_template_model` | **PASS** — 0 missing models |
| Empty NPC names | **PASS** — 0 |
| Positions vs retail | **PASS** — 262,620 / 262,623 within 50 yd; 1 at 51.2 yd; 2 TDB-only rows |
| Phases | **Mostly intentional divergence** — 246,495 phase-identical; 6,292 Normal→0; 5,579 quest phases flattened; 2,346 added; 1,908 remapped |
| Zero / invalid positions | **1 bad row** — Zo'phex `175616`, map 2441 Tazavesh, `(0,0,0)` |
| Duplicate exact-position spawns | **2,397 groups / 4,286 excess rows** (2,274 / 3,413 excluding trigger bunnies) |
| Quest NPC coverage | **775 starter / 1,007 ender entries with no spawn** → 1,391 / 1,975 quests |
| Orphan `creature_addon` rows | **2,945** (cosmetic cleanup) |

**Bottom line:** the static NPC layer is complete and positionally faithful to retail. The real gaps are (a) quest NPCs deliberately removed by the 2026-10-18 "Harandar retail-only" purge and not restored, and (b) a long tail of quest NPCs with no spawn across older content.

---

## 1. Completeness

- `creature`: 702,848 rows, 82,343 distinct entries, 530 maps.
- `creature_template`: 232,684.
- **0** spawns lack a template.
- **0** spawned templates lack a `creature_template_model` row.
- **0** spawned templates have an empty name.
- 2,194 templates have no model — none are spawned, so harmless.
- 150,341 templates are never spawned — normal for a full retail template import.
- `creature_addon`: 92,052 rows; **2,945 orphans** point at GUIDs that no longer exist (leftovers from deleted spawns).
- 1,311 spawns have `PhaseId` / `PhaseGroup` NULL (custom rows); 5 have empty `spawnDifficulties`.

## 2. Positions

Method: for every TDB spawn, find the nearest world spawn of the same `(map, entry)` and measure 3D distance.

| Metric | Count |
|---|---|
| TDB spawns compared | 262,623 |
| World match within 50 yd | 262,620 (99.999 %) |
| Match 50–150 yd | 1 |
| Match > 150 yd | 0 |
| No world spawn of that entry on the map | 2 |

- **1 borderline:** Underlight Nibbler `41916`, map 0 — 51.2 yd from the retail position.
- **2 TDB-only:** Scouting Map `240523`, `244550` (map 0) — world has 0 spawns. Both sit at ~`(8457, -4616)`, next to the Hagar's Invitation starter `253640` at `(8457.01, -4624.12)`; likely removed object-like scouting maps.
- **1 zero-position spawn:** `guid 8000341`, Zo'phex `175616`, map 2441 (Tazavesh), `(0,0,0)`, phase 0. Should be deleted or repositioned.
- **5 maps absent from wago `Map.csv`** (338 spawns): 1470 (329), 1180 (5), 2100 (2), 451 (1), 1178 (1). These are instance/scenario maps; verify they exist in the client DB2 before treating as errors (the CSV export is not guaranteed complete).

## 3. Phases

- 597,617 spawns (85 %) are `PhaseId = 0` (always visible).
- 1,311 rows have NULL `PhaseId` / `PhaseGroup`.
- Against TDB:
  - **246,495** TDB spawns have a same-phase world copy within 50 yd.
  - **6,292** retail `169` ("Normal") → world `0` — benign: 0 is the realm's always-visible normal state.
  - **5,579** retail quest phases → world `0` (flattened). Same spawn position (distance 0.0), i.e. deliberate flattening so quest NPCs stay visible. Concentrations:
    - map 0 phase `327` "Isorath Nightmare" — 679 (Twilight Highlands Iso'rath questline; `phase_area` for 327 = 0).
    - map 648 Kezan — phases 170–184, 378–383; ~2,000 rows. World keeps phase 0 copies plus partial chapter phases (378/383/384).
    - map 654 Lost Isles — phases 186–190; ~1,000 rows.
    - map 571 phase 177, map 1 phase 194, etc.
  - **2,346** spawns have a custom phase where TDB has none — alive-world phasing (Arathi `41119`, Tirisfal `41881`, `50005`).
  - **1,908** remapped to custom phase IDs (e.g. Kezan `188` → `40402` "Quest Slowing the Inevitable") — deliberate rebuild.
- 64,475 spawns use phase IDs absent from the retail Phase DB2 — custom server-side phasing. `phase_name` is missing for 927 spawns / 102 `phase_area` rows; cosmetic only.

**Interpretation:** the phase differences are overwhelmingly the realm's deliberate "keep quest content visible" policy, not corruption. The only place worth a visual check is Kezan/Lost Isles, where retail chapter phases and phase-0 copies coexist.

## 4. Duplicate spawns

- 2,397 exact `(entry, map, x, y, z)` groups / 4,286 excess rows.
- Excluding bunny / trigger / cover templates: **2,274 groups / 3,413 excess rows**.
- Top excess: Falling Boulder 198, Unstable Corruption 188, Oomlot Warrior 154, Reanimated Corpse 128, Poison Spitter 80, Twilight Candidate 71, Bloodfang Stalker 59, Raging Invader 58, Gilnean Crow 50, Forsaken Invader 47.
- Some are legitimate event/AoE stacks (falling boulders), but exact-same-position duplicates of ordinary NPCs should be reviewed. Earlier dedup backups (`creature_backup_duplicates`, `backup_20261012_dedup_creature`) exist.

## 5. Quest NPC coverage

- **775** quest-starter creature entries and **1,007** quest-ender entries have no row in `creature`.
- Affected: **1,391** starter quests / **1,975** ender quests.
- By quest ID:
  - `< 60000`: 896 starter quests / 553 NPCs (old content; likely retired/out of scope).
  - `60000–79999`: 393 / 187.
  - `80000–89999`: 85 / 35.
  - `>= 90000`: **17 starter quests / 12 NPCs**; **29 ender quests / 19 NPCs**.
- Some `>= 90000` rows are covered by Eluna dynamic spawns (Atal'Utek `coiled_spawner.lua` spawns `262798`, `262880`; Harandar intro uses `245879`), so they are not all bugs.

### 5.1 Critical: Harandar chain 92895 → 92904 is broken

On 2026-10-18 `20261018_harandar_retail_only.sql` deleted **all** custom map-2694 spawns (`guid >= 3000000000`), backing them up to `backup_20261018_harandar_creature_custom` (3,578 rows). `20261018_legacy_chain.sql` re-added many chain NPCs but **not** the Den of Echoes starters/enders.

Live spawn counts:

| NPC | Entry | Role | Spawns |
|---|---|---|---|
| Orweyna | 253654 | ender 92895; starter 92899 | **0** |
| Loa Speaker Kinduru | 253651 | ender 92899; starter 92900 | **0** |
| Loa Speaker Kinduru | 253790 | starter 92900 | **0** |
| Zul'jan | 253653 | ender 92900 | **0** |
| Orweyna | 255659 | starter + ender 92901 | **0** |
| Zul'jan | 255660 | starter 92904 | **0** |

`253640` (starter of 92895) is spawned on map 0 at `(8457.01, -4624.12, 48.26)`, phase `46726` — so 92895 can be accepted but **not turned in**. Quests 92899, 92900, 92901 and 92904 are fully dead. The Lua files `historylesson92899.lua`, `afavor92900.lua`, `hagar92895.lua` hook creatures that do not exist.

**Options:**
1. Restore the six Den NPCs from `backup_20261018_harandar_creature_custom` or the original `20261011_*.sql` spawns (phases 46727/46728/46729), then reload.
2. Or retire the chain: remove the quest links, Lua hooks and `npcflag` bits.

### 5.2 Other `>= 90000` unspawned quest NPCs

Starters (17 quests / 12 NPCs):

- `91462` To the Central Tower — `248309` [Do not use] Unbound Arcanweave
- `91829` One by One — `250295` Blood Elf Spy
- `91830` Intercepted — `250295` Blood Elf Spy
- `91831` Keys Are Optional — `250295` Blood Elf Spy
- `92899` History Lesson — `253654` Orweyna
- `92900` A Favor for Kinduru — `253651`, `253790` Loa Speaker Kinduru
- `92901` Revisionist History — `255659` Orweyna
- `92904` Return to Zul'Aman — `255660` Zul'jan
- `95520` Purging the Vaults — `262798` Warleader Abdumati
- `96338` Port of Entry — `265166` Lightveil Scout
- `96440` Victory Within Hindsight — `265166` Lightveil Scout
- `97640` Vaults of Atal'Utek: One Coin Too Many — `262798` Warleader Abdumati
- `98388` Into the Vaults of Atal'Utek — `262798` Warleader Abdumati
- `98428` Vaults of Atal'Utek: The Altar of Corrosion — `262880` Er'inye
- `98515` Vaults of Atal'Utek: A Toxic Tour — `262798` Warleader Abdumati
- `4204800` Champion: Mylune — `133525` Resonance Totem
- `90690000` Charge of the Vanguard — `230523` KC

Enders (29 quests / 19 NPCs) additionally include `245944` Assisting Bloodknight (90553/90554/90556), `246021`/`246022` Gehl Harrowtongue (90765/90766), `252807` Vanguard Paladin (91146/91147), `259115` [DNT] kill credit (91606), `256206` Sentient Voidwalker (91885), `249456` Cindy Springstock (92028), `250450` Fixer So'kir (92331/92332), `248658` Chel the Chip (94361), `259298` Tekkan (94937), `265166` Lightveil Scout (96310) plus the Harandar entries above.

Several of these are companion / credit / summoned NPCs, not static quest givers — check per quest before adding spawns.

## 6. Notes / non-issues

- **`hotfixes.map` has only 22 rows — not a bug.** The core loads the full `Map.db2` from `dbc/enUS/`, then applies the hotfixes overlay (`DB2Stores.cpp`, `LoadStores` → `storage->Load(db2Path...)` then `LoadFromDB`). The 22 rows are custom map overrides.
- Custom phase IDs (`50005`, `41119`, `41881`, `40396`, `44947`, …) are server-side phasing; absence from retail `Phase.db2` is expected.
- `phase_area` missing for a creature phase is normal when the phase is applied by conditions/spells rather than by area.

---

## Recommended actions (not applied)

| # | Priority | Action |
|---|---|---|
| 1 | **High** | Restore the six Den of Echoes NPCs (253651, 253653, 253654, 253790, 255659, 255660) or retire the 92895–92904 chain. |
| 2 | Medium | Delete/reposition `guid 8000341` (Zo'phex, `0,0,0`, map 2441). |
| 3 | Medium | Review exact-position duplicate groups, starting with ordinary NPCs (not boulders/triggers). |
| 4 | Low | Clean 2,945 orphan `creature_addon` rows. |
| 5 | Low | Audit the `< 60000` unspawned quest NPC list only if old-world quests are in scope. |
| 6 | Verify | Visual check of Kezan/Lost Isles phasing and Iso'rath (map 0 phase 327) if chapter states matter. |

## See also

- `legion_suramar_audit_20261027.md` — Legion / Suramar addendum. TDB does not cover
  Legion (867 map-1220 spawns, 0 in Suramar), so the position parity result above does
  not apply there.
