# VO audit 2 — 2026-10-22

Druhý audit `world.creature_text` proti retail zdrojom (TDB 12.1.0 + BroadcastText/SoundKit 12.1.5.70391)
po globálnom VO sweepe z 2026-10-21. Odpovedá na otázku: *zabudol som na niečo? Majú všetky creatury —
aj zo starších datadiskov — správne soundkity a BroadcastTexty?*

## Metóda

| nástroj | čo robí |
|---|---|
| `tools/vo_audit_full.py` | Celý svet: 52 849 riadkov, 44 732 hovorených (typ 12/14/15). Kit→VO zložka z `hotfixes.sound_kit_entry` + `community-listfile.csv` (5 780 zložiek, 165 815 kitov). Vlastná zložka creatury podľa mena (+ `femaleName`), effective kit = BT kit[gender], inak `creature_text.Sound`. |
| `tools/vo_audit_tdb.py` | Diff proti `tdb1210_world.creature_text` (19 962 retail riadkov z TDB 12.1.0); kategorizácia regresií. |
| `tools/vo_fix_audit2.py` | Stavia opravný SQL z nálezov oboch audítov. |

## Čo sa našlo a opravilo

`sql/20261022_vo_audit2_fix.sql` — **1 127 zmenených riadkov + 3 inserty**, záloha
`world.bak_20261022_vo_audit2_ct`, undo `sql/20261022_vo_audit2_undo.sql`.

1. **583 riadkov umlčaných** — prvý sweep vynuloval `Sound`, hoci TDB 12.1.0 tam má kit a BT kit nemá
   (Whitemane 5838/5840, Kelris 5802–5804, Grimlok 5853/5854, …). Obnovené z TDB.
   `we_silent_tdb_voice` 565 → **0**, `REGRESSION_own_silenced` 18 → **0**.
2. **Lorna Crowley 38768 g0** — BT 69734 niesol Anduinov kit (`anduinwrynn`); TDB má `Sound` 19697
   (`lorna`). Opravené na BT 0 / Sound 19697 / text „Father!".
3. **3 chýbajúce riadky Luma Skymother 25697** (Ahune event) doplnené z TDB (BT 24893/24894/24895).
4. **51 visiacich BroadcastTextId** (v 12.1.5 neexistujú; Sylvanas 444510–444517, Koltira 451120–451123, …)
   → BT 0, text ostal.
5. **417 tichých riadkov** presne (normalizovane) zladených s BT vo vlastnej VO zložke → link + audio.
6. **71 textových rozdielov** `Text` vs BT display text → zladené. 4 sound-only riadky (prázdny text
   aj v BT) ponechané.
7. **24 riadkov, kde TDB má cudzí kit** a my máme správny vlastný (Jaina/Sylvanas/Falric/Marwyn…) —
   potvrdenie, že sweep opravil aj chyby v TDB.

## Stav po oprave

| metrika | hodnota |
|---|---|
| `creature_text` riadkov | 52 849 |
| hovorených (12/14/15) | 44 732 |
| s efektívnym kitom | 16 219 |
| `Sound <> 0` | 16 327 |
| `BroadcastTextId <> 0` | 43 388 |
| ruské texty | **0** |
| visiace BT | **0** |
| Text vs BT mismatch | **0** |
| neplatné `Sound` | **0** |
| TDB regresie | **0** |

**928 „foreign" riadkov (330 creatúr)** = aliasy a zdieľané banky, nie bugy:
Brann→`brann`, Nefarius→`nefarian`, Kael'thas→`princekaelthas`, Uther→`utherlightbringer`,
Liam→`liam`, Lorna→`lorna`, Echo of Tyrande→`tyrandewhisperwind`, Computer→`archivumsystem`.
Všetky sú buď kryté TDB, alebo nesú kit priamo z retail BroadcastTextu.

**Zostáva na ASR fázu:** 75 fuzzy kandidátov (0,85–0,99) a **5 892 riadkov** na 2 278 creaturách,
kde existuje vlastná VO zložka, ale žiadny BT text-match. Top zóny: TheForbiddenReach 26,
Azsuna 36, Valsharah 29, Highmountain 28, Stormheim 23, Talador 23.

## Staré datadisky — kontrola

TDB overlap: **19 962 riadkov, 0 regresií**. Ikonickí bossovia (linked / spoken):

| creature | meno | linked/spoken |
|---|---|---|
| 11502 | Ragnaros | 8/8 |
| 22917 | Illidan Stormrage (BT) | 19/19 |
| 25315 | Kil'jaeden (Sunwell) | 13/14 |
| 16980 | The Lich King | 6/6 |
| 17968 | Archimonde (Hyjal) | 13/13 |
| 32871 | Algalon the Observer | 19/19 |
| 19622 | Kael'thas Sunstrider (BT) | 19/19 (alias `princekaelthas`) |
| 33288 | Yogg-Saron | 6/7 |
| 15990 | Kel'Thuzad (Naxx) | 22/25 |
| 11583 | Nefarian (BWL) | 6/16 |

Ticho pri Nefarianovi 11583 (class-cally), Onyxii 10184, Garroshovi 25237 a Gul'danovi 17008
je **aj v TDB** (BT bez kitu, `Sound` 0) — nie je to regresia sweepu. Nefarianove class-cally
sú dobrý testovací prípad pre ASR (súbory `sound/creature/nefarian/vo_*` existujú).

## Súbory

- `docs/vo_audit2/REPORT.md` — tento report
- `docs/vo_audit2/changes.csv` — 1 127 zmien (action, old/new text/BT/Sound, dôvod)
- `docs/vo_audit2/restore_all.csv` — 583 obnovených Sound z TDB
- `docs/vo_audit2/gaps.csv`, `partial.csv`, `all_creatures.csv` — worklisty ASR fázy
- `docs/vo_audit2/tdb_diff.csv` — plný diff proti TDB
- `docs/vo_audit2/summary.json` — agregáty + zóny + ikony
- `sql/20261022_vo_audit2_fix.sql`, `sql/20261022_vo_audit2_undo.sql`

## Verifikácia

- SQL aplikované (mysql exit 0), 1 127/1 127 riadkov sa líši od zálohy.
- `.reload creature_text` cez SOAP OK, `DBErrors.log` **0 B**, server uptime 36 min bez chýb.
- Opakovaný audit: 0 RU, 0 visiacich BT, 0 text mismatch, 0 TDB regresií.


## Nadv?zuj?ce reporty (2026-10-22)

- `MISSING.md` ? glob?lna ASR fronta + Midnight preh?ad ??o nem?me".
- `MIDNIGHT.md` ? Midnight detail: 3 532 entry, 16 s textom, 3 plne hovoriace,
  3 516 bez riadku, 238 menovan?ch bez riadkov, autofill pl?n 1 452 BT / 49 post?v.
- `midnight_autofill_plan.csv`, `midnight_creatures.csv`, `midnight_missing_named.csv`,
  `midnight_quests.csv` ? worklisty (read-only, neaplikovan?).
