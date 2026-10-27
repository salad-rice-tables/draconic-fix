# WORLD audit report 2026-10-16 — Classic → Midnight (expanzie 0–11)

Nástroj: `Custom/tools/world_audit.py` (retail zdroje: wago CSV Map/AreaTable/
QuestPOIBlob/DungeonEncounter/UiMapAssignment + TDB staging `tdbfull1210` =
TC TDB 335.26091, overené latest 2026-10-16). TC upstream porovnanie vstavané:
každý flag má verdikt OUR-BUG (TDB to má, my nie) vs retail-design? (chýba aj
v TDB) vs needs-review. Výstupy: `audit_exp{0,12,345,678910,11}.json`.

## Rozsah: 1184 máp, ~22 500 POI questov, 1330 encounterov

| expanzia | máp | POI questov | encounterov | OUR-BUG |
|---|---|---|---|---|
| 0 Classic | 130 | 5561 | 249 | 330 |
| 1+2 TBC/WotLK | 69 | 2258 | 232 | 38 |
| 3+4+5 Cata/MoP/WoD | 367 | 1996 | 227 | 43 |
| 6–10 Legion→TWW | 563 | 12047 | 527 | 183 |
| 11 Midnight | 55 | 705 | 93 | 18 |

## Opravené dnes

- **8→1 objektívy**: `20261016_allareas_fix.sql` (+undo) — len q29406 (sirota
  252339←90471, template 90471 neexistuje). Zvyšných 12 SKIP: retail questy majú
  LIVE custom klony (vzor ID×100+1), ktoré vlastnia tie isté objective-ID —
  retail kópie by zdvojili ponuky (bug-trieda z 10-10). Pozri Knowledge.
- **2792 raid**: 7 bossov nasadených (TDB coords z mapy 230).
- **EcoDome script**: A'wazj 241375→237514 (TDB-verified).

## Klasifikácia zvyšku (612 research queue)

1. **MISSING quest_template + NOT IN TDB** (11+ v Midnight, viac inde): retail
   novší ako TDB snapshot alebo DNT — len Wiki/Wowhead research po jednom.
2. **Giver bez spawnu aj v TDB** (väčšina "OUR-BUG"): fázované/scriptované
   spawnuty alebo riedke TDB — overiť Wiki (giver chain) alebo GM session.
3. **Custom-klon pattern** (ID×100+1, giver×100+1): audit ich hlási ako
   "chýbajúce" retail verzie, ale hrateľné sú klony — NEFIXOVAŤ retail kópiami.
4. **needs-review tisíce** (offer texty, objektívy s klonom): dávkový Wiki
   proces (Completion→offer, overený 10-13: 821 textov).

## Ďalej (navrhované poradie)

1. GM placement session: `dungeon_gm_placement_20261016.md` (Mechagon 2, Taahbat,
   2574/2930/2774/2987/1592) — súradnice retail % + `.go zonexy` v sheete.
2. Research queue po Wiki storyline dávkach (1 stránka = celý chain).
3. needs-review offer-texty dávkovo z Wiki Completion.
4. Hráčsky test prihlásenia na 12.1.5 + `.diag` z questových zón.
