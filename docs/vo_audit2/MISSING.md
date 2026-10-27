# Čo nemáme — globálny prehľad + Midnight

Dátum: 2026-10-22. Read-only audit. Doplňuje `REPORT.md` (opravy z 22. 10.)
a `MIDNIGHT.md` (Midnight detail).

## 1. Globálna ASR fronta (staré datadisky + zvyšok sveta)

`gaps.csv` = creatury s vlastnou VO zložkou, ale bez BT text-matchu:

| metrika | hodnota |
|---|---:|
| creatúr | 2 278 |
| hovorených riadkov | 6 035 |
| z nich s kitom | 1 101 |
| tichých (bez kitu) | 4 934 |
| **unfixable → ASR** | **5 892** |
| fixable (text-match) | 41 |
| z toho presných | 2 |

Top zóny: `Azsuna` 36, `Valsharah` 29, `Highmountain` 28,
`TheForbiddenReach` 26, `Stormheim` 23, `Talador` 23,
`ShadowmoonValleyDR` 22, `Voldun` 22, `SpiresOfArak` 20,
`StormwindCity` 19, `PlaguelandsTheScarletEnclave` 19.

(`REPORT.md` uvádza 5 892 — to je presne `unfixable`; 6 035 je všetko spoken
vrátane 41 fixable a 102 už čiastočne pokrytých.)

## 2. Midnight — hlavná diera

Plný detail v `MIDNIGHT.md`. Zhrnutie:

| metrika | hodnota |
|---|---:|
| Midnight entry >= 230000 | 3 532 |
| s `creature_text` | 16 |
| plne hovoriacich | 3 (Kystia 11, Danul 1, Oorla 1) |
| bez jediného riadku | 3 516 |
| menovaných s vlastnou VO zložkou a 0 riadkami | 238 |
| kandidátskych replík v ich zložkách | 1 452 / 49 postáv |
| Midnight questov | 2 229 |
| questov s hovoriacim NPC v DB | 10 (system/DNT/prey) |

Build **66102** = Midnight: 5 164 textových BroadcastTextov, z toho len 20
použitých v `creature_text`. To je kvantitatívny dôkaz, že chýba takmer celý
Midnight dabing, nie len zopár riadkov.

## 3. „Nemáme" podľa typu

| typ | počet | stav |
|---|---:|---|
| chýbajúce riadky (menovaní Midnight NPC) | 238 entry / 3 516 creatúr | plán 1 452 BT hotový, neaplikovaný |
| chýbajúce audio (globálne) | 4 934 tichých spoken riadkov | ASR / dohľadať kit |
| chýbajúce BT (Midnight scope) | 2 | Umbric 246156, Vyraz 159894 — custom, netreba vyrábať |
| chýbajúce TDB spawny | 29 | Swine/Crab/Bee/Squirrel na starých mapách; **0 Midnight** |
| chýbajúce template | 0 | TDB 227 633 = world 227 633 |

## 4. Čo s tým

1. **Midnight scény**: z `midnight_autofill_plan.csv` postaviť Eluna scény po
   vetvách (Silvermoon, Amani, Harandar). Poradie podľa BT ID, pauzy
   `KIT_LEN * 1000 + gap`, `HSeq` v `harandar_kit_len.lua` len aditívne.
2. **ASR**: 5 892 unfixable riadkov — Parakeet TDT 0.6B v3 + forced alignment;
   Canary-Qwen-2.5B len na ťažké prípady. Začať top zónami a Nefarianom 11583.
3. **TDB spawny**: 29 chýbajúcich critterov dohnať len ak ich chceš v hre
   (nemajú vplyv na texty).
4. **Autofill**: neaplikovať hromadne do group 0 — sú to scénické repliky.
   Až po dohodnutí GroupID / scén.

## Súbory

- `docs/vo_audit2/MISSING.md` — tento report
- `docs/vo_audit2/MIDNIGHT.md` — Midnight detail
- `docs/vo_audit2/gaps.csv`, `partial.csv`, `all_creatures.csv` — ASR fronta
- `docs/vo_audit2/midnight_*.csv` — Midnight worklisty
- `tools/vo_audit_midnight.py` — generátor Midnight auditu
