# Session 2026-10-12: systematic quest/spawn audit + fixes

## DB baseline (verified live)
- world.creature 701 052, gameobject 209 591; 49 158 quests
- Full TDB 12.1.0.26091 imported to `tdbfull1210` (262 623 / 104 080) â€” proven SPARSE
  (Elwynn 122 vs our 1 900), NOT usable as parity reference. Parity SQLs SUPERSEDED.

## Applied fixes (all with _undo.sql, verified in DB)
1. `20261012_zulaman_86809_dead_ender.sql` â€” dead ender 236141 removed (covered by 236126)
2. `20261012_zulaman_245646_broken_z.sql` â€” undermap spawn z 0.0 â†’ 139.91
3. `20261012_zulaman_86717_add_starter.sql` â€” Wiki giver Zul'jarra 236559 added (additive)
4. `20261012_cleanup_dangling_questlinks.sql` â€” 871 rows to nonexistent quests (459 IDs nowhere)
5. `20261012_cleanup_redundant_enders.sql` â€” 6 redundant dead enders (Kyle Radue, Wrathion, Miju, 466128)
6. `20261012_cleanup_go_90094_90095.sql` â€” 3 wrong-table GO links (Anima crystals)
7. `20261012_city_import_sw_org.sql` â€” 49 retail spawns (SW 26 NPC, Org 3 NPC) from TDB, new guids
8. `20261012_dungeon_mask_default.sql` â€” 81 invisible spawns (1754/2097/2993, mask 0) â†’ default mask
9. `20261012_dedup_exact.sql` â€” 4 302 + 12 242 exact duplicates; leftovers match TDB counts (retail-legit)

## Audits (generated)
- `docs/midnight_full_audit.json/.md` â€” 21 114 refs / 1 648 questlines; gaps also missing in full TDB (= retail design / newer than 12.1.0)
- `docs/dead_links_full.json`, `redundant_dead_links.json`, `tdb_gap_fixlist.json`
- `docs/dungeon_boss_worklist.md` â€” boss IDs for empty maps (in-game placement)
- `tools/midnight_full_audit.py` â€” re-runnable full audit

## BLOCKED (evidence, no guessing)
- 94871/86708/89402/89193 no starter: Wiki giver Scouting Map (Silvermoon); our 4 GO IDs are
  Shadowlands objects (map 2222 = Bastion/Ardenweald per AreaTable), Wowhead 404s them,
  full TDB has no starters either, no sniff data (Tools/sniff has only the tool).
  Workaround: `.quest add`. Needs: retail GO ID + Silvermoon coords (sniff).
- 86914/89034 choice rewards: 14 IDs verified, held (10-vs-6 slots, missing hotfix item data).
- 86874 texts: no Wiki page, no invention. 95008 beta-dup + 94993 Umbric ender: kept (harmless).

## Pending restarts / manual
- Worldserver restart needed (masks, spawns). Sunshine restart needs admin (user).

## Texty 2026-10-13 (Wiki batche A-H, F/G, P1-P4)
- Doplnené: 71 offer + 821 completion + ~440 progress (SQL 20261013_wiki_textfill{,2,3,4}.sql + undá).
- Zvyšné prázdne (649 offer / 1364 completion v 86-96k) nemajú Wiki stránku (DNT/test/stub, overené po jednom).
- Mismatchy sniff-vs-Wiki sa plošne neprepisujú (parafrázy medzi buildmi).

