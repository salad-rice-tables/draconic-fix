# Midnight (12.x) — audit textov a hlasov

Dátum: 2026-10-22. Read-only audit `world.creature_text` pre Midnight obsah.
Nadväzuje na `REPORT.md` (druhý globálny audit) a dopĺňa chýbajúcu dimenziu:
**creatury, ktoré nemajú žiadne riadky** — nielen tie so zlým kitom.

## Rozsah a metóda

Scope Midnight creatúr = zjednotenie:

- spawny na 14 Midnight mapách z `AreaTable_12.1.5.70391.csv`
  (`12Eversong*`, `121ZulAman*`, `12Silvermoon*`, `12IsleOfQuelDanas*`, `12IntroQuellDanas`, …):
  `2694, 2711, 2769, 2771, 2813, 2858, 2907, 2912, 2916, 2923, 2953, 3009, 3022, 3071`
- `creature_template.RequiredExpansion = 11`
- NPC Midnight questov `90000–99999` (starter, ender, objektív typu 0)

Výsledok: **3 765** creature ID, z toho **3 679** existuje v `creature_template`;
**3 532** má entry >= 230000 (vlastný Midnight rozsah).

Hlas sa počíta ako efektívny kit: `BroadcastText.SoundKitID1/2` podľa genderu,
inak `creature_text.Sound`. Vlastná VO zložka = zhoda mena/submenu s niektorou
z 5 780 zložiek `sound/creature/<slug>/` z `SoundKitEntry` + `community-listfile.csv`.

## Súhrn

| metrika | hodnota |
|---|---|
| Midnight creatúr v scope (existujúce template) | 3 679 |
| z toho entry >= 230000 | 3 532 |
| s akýmkoľvek `creature_text` | 47 |
| z toho entry >= 230000 | 16 |
| plne hovoriacich (kit + BT) | **3** |
| bez jediného riadku (entry >= 230000) | **3 516** |
| menovaných s vlastnou VO zložkou a 0 riadkami | **238** |
| kandidátskych Midnight replík v ich zložkách | **1 452** (49 postáv) |
| Midnight questov 90000–99999 | 2 229 |
| questov aspoň s 1 hovoriacim NPC v `creature_text` | **10** (všetko system/DNT/prey) |
| riadkov bez audia v Midnight scope | 24 |
| riadkov bez BroadcastTextu v Midnight scope | 2 |

Poznámka k 238: je to strict filter (similarita ≥ 0,62 alebo zhodný token,
`own_files ≥ 20`). Aj tak medzi nimi zostávajú shared/generic banky
(`Voidcrawler`, `Trigore`, `Shadowguard Mech`). Pre autofill sa preto používa
len **49 kanonických postáv**, ktoré majú v zložke reálne BroadcastTexty
s buildom 66102.

## Kto naozaj hovorí

Iba tri Midnight entry majú kompletný hlas:

| creature | meno | riadky | kit | BT |
|---|---|---:|---:|---:|
| 234648 | Kystia Manaheart | 11 | 11 | 11 |
| 237865 | Danul | 1 | 1 | 1 |
| 237866 | Oorla | 1 | 1 | 1 |

Kystia je dôkaz, že build **66102** v `hotfixes.broadcast_text` je Midnight:
všetkých jej 17 kandidátskych BT má tento build. Celkovo má build 66102
**5 164** textových BT, ale v `creature_text` je použitých len **20**.
To je hlavná diera: **99,6 % Midnight BroadcastTextov nemá žiadnu creatures row.**

Ďalších 13 Midnight entry má riadky, ale bez kompletného hlasu (text-only,
chýbajúci kit alebo BT): Turalyon 250580, Orweyna 253654, Lor'themar 235787,
Umbric 239944 + 249272 + 246156, Kinduru 253651 + 253790, Senn 248628,
Amias Bellamy 250587, Dak'zor 253829, Nibbles 234660, Suspicious Citizen 246154.

## Menovaní bez riadkov — top 20

`midnight_autofill_plan.csv` obsahuje 1 452 replík pre 49 hlavných postáv.
Stĺpce: `creature, name, folder, bt, build, text`; každý BT je doložený
z vlastnej VO zložky a má build 66102. Plán **nie je aplikovaný** — repliky
sú scénické dialógy, nie barky; vložiť ich do group 0 by ich premiešalo.

| creature | meno | BT 66102 | spawn map |
|---|---|---:|---|
| 235393 | Arator | 239 | 2771 |
| 236155 | Zul'jarra | 117 | — |
| 237210 | Orweyna | 93 | 2694 |
| 236692 | Lady Liadrin | 86 | 2858 |
| 235411 | Magister Umbric | 70 | 2771 |
| 235389 | Alleria Windrunner | 68 | 2771 |
| 235394 | Lothraxion | 66 | 2771 |
| 242381 | Valeera Sanguinar | 64 | — |
| 236789 | Alonsus Faol | 53 | 2858 |
| 235392 | Decimus | 44 | 2771 |
| 253653 | Zul'jan | 42 | — |
| 246231 | Astalor Bloodsworn | 42 | — |
| 236896 | Lor'themar Theron | 42 | 2858 |
| 236906 | High Exarch Turalyon | 32 | 2858 |
| 238531 | Riftblade Maella | 31 | 2771 |
| 239525 | Ruia | 26 | 2694 |
| 237341 | Halduron Brightwing | 26 | 2694 |
| 244521 | Kul'amara the Fierce | 23 | — |
| 242704 | Dundun | 23 | — |
| 247374 | Ziadan | 18 | 2771 |

Pri Aratorovi je 239 replík (medián 60 znakov), pri Orweyne 93, pri Zul'jarre 117 —
sú to celé questové scény, napr. `283168 A void beast! Look out!`,
`282950 Harandar is a dangerous place.`, `285131 This ritual only imitates…`.
Preto patria do Eluna scén s poradím, nie do náhodného group 0.

## Questy

Z 2 229 Midnight questov má aspoň jedno hovoriace NPC len 10 — a všetky sú
systemové/DNT/prey, nie príbehové:

`90087, 90093, 90109, 90114, 90128, 90759, 90760, 91009, 91026, 91030`

Príbehové questy (Harandar intro 90957–90961, Amani 929xx, …) nemajú
`creature_text` vôbec — Harandar intro je pokryté Eluna scénami, nie DB.
To je správne pre prvých 5–6 questov, ale zvyšok Midnight na scény čaká.

## Čo je naozaj fixovateľné hneď

- **24 riadkov bez audia** v Midnight scope: väčšina sú custom Fel event moby
  (`95xxx` v Ashenvale/Teldrassil) a staré creatury (Vashj 162487, Azgalor 93719,
  Apocron 121124, Mawsworn 177161/177162/177285). Ich text je custom alebo bez
  BT; hromadne ich nedopĺňať.
- **2 riadky bez BT**: Umbric 246156 (custom replika, `Sound=300619`) a
  Baron Vyraz 159894 (3 hovorené riadky, 1 kit). Bez retail BT ich netreba vyrábať.
- **TDB spawny**: `tdb1210_world.creature` a `world.creature` majú zhodný počet
  262 623. 177 GUIDov sa líši; 583 sa našlo ako prečíslované (rovnaká creatura,
  mapa, súradnice). **29 naozaj chýba** — sú to Swine/Mature Swine (map 1),
  Sandyback Crab/Crawler, Hermit Crab, Honey Bee, Valley Cottontail/Squirrel,
  Animated Droplet (mapy 1643/1864). **Žiadny Midnight spawn nechýba.**

## Súbory

- `docs/vo_audit2/MIDNIGHT.md` — tento report
- `docs/vo_audit2/midnight_creatures.csv` — všetkých 3 679 creatúr v scope
- `docs/vo_audit2/midnight_missing.csv` — 926 chýbajúcich (raw, vrátane šumu)
- `docs/vo_audit2/midnight_missing_named.csv` — 238 menovaných po strict filtri
- `docs/vo_audit2/midnight_autofill_plan.csv` — 1 452 replík / 49 postáv (ne aplikované)
- `docs/vo_audit2/midnight_autofill_summary.csv` — počty na postavu
- `docs/vo_audit2/midnight_quests.csv` — pokrytie 2 229 questov

## Odporúčaný ďalší krok

1. Vybrať jednu vetvu (napr. Silvermoon: Arator / Alleria / Liadrin / Turalyon /
   Lothraxion) a z `midnight_autofill_plan.csv` postaviť Eluna scénu s poradím
   podľa BT ID a pauzami `KIT_LEN * 1000 + gap`.
2. Potom to isté pre Amani vetvu (Zul'jarra, Zul'jan, Kinduru, Kul'amara).
3. Autofill do `creature_text` použiť len tam, kde replika nie je súčasťou scény
   (krátke barky), alebo až keď bude známe GroupID zo scény.
4. Paralelne ASR pre 5 892 „unfixable" riadkov z `gaps.csv` (viď `MISSING.md`).
