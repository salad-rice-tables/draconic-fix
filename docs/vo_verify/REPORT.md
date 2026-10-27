# VO / soundkit / BroadcastText – retail parity audit (2026-10-22, third pass)

Cieľ: overiť **každý** riadok `world.creature_text` proti retailu (text, BroadcastText,
SoundKit) a opraviť všetko, čo sa dá mechanicky dokázať. Server bol počas auditu vypnutý,
takže všetko je overené na DB úrovni + CASC/wago; v hre treba potvrdiť po štarte.

## Zdroje pravdy

| Zdroj | Rozsah | Použitie |
|---|---|---|
| `hotfixes.broadcast_text` (12.1.5.70391 + staršie buildy) | 235 253 riadkov | anglický text, `SoundKitID1/2` |
| `hotfixes.sound_kit` / `sound_kit_entry` | 337 416 kitov / 1 310 132 entries | platnosť kitov a súborov |
| wago CSV 12.1.5.70391 (`BroadcastText`, `SoundKit`, `SoundKitEntry`) | 10 704 BT / 337 416 kitov | nezávislá kontrola |
| `community-listfile.csv` | 285 642 `sound/*` ciest | FileDataID → cesta |
| `tdb1210_world.creature_text` (12.1.0) | 19 962 riadkov | retail baseline |
| **`hotfixes.creature_text`** (retail DB2 snapshot, ruRU, 2026-03-01) | 52 659 riadkov | **nový zdroj**: text/BT/Sound retail štruktúra |
| `world.creature_text` | 52 849 riadkov | náš stav |

`hotfixes.creature_text` je retail snapshot: s TDB 12.1.0 sa zhoduje na 98,1 % v
`BroadcastTextId` a 98,9 % v `Sound` (19 413 spoločných kľúčov). Je to lokalizovaný (ruRU)
export, takže text sa nedá použiť priamo, ale **BT id a Sound id sú retail**.

## Ako server skutočne vyberá text a zvuk

`src/server/game/Texts/CreatureTextMgr.cpp:209-224`:

```
finalSound     = iter->sound;                       // creature_text.Sound
if (bct) if (kit = bct->SoundKitID[gender == FEMALE ? 1 : 0]) finalSound = kit;
```

* `BroadcastText.SoundKitID1` = male/none, `SoundKitID2` = female.
* Ak BT kit != 0, `creature_text.Sound` sa **nikdy nepoužije**.
* Ak BT kit == 0, použije sa `creature_text.Sound`.
* Text: `Text1` pre FEMALE a GENDER_NONE (ak je neprázdny), inak `Text`.

Duplicitné BT id: `DB2DatabaseLoader::Load` načíta najprv custom (`VerifiedBuild = 0`),
potom cache (`VerifiedBuild > 0`); v rámci cache vyhráva **najvyšší build**. Preto audity
počítajú „winner" = max build spomedzi `VerifiedBuild > 0`.

## Čo sa kontrolovalo (10 dimenzií, všetkých 52 849 riadkov)

1. `BroadcastTextId` existuje v `hotfixes.broadcast_text` → **0 visiacich** (43 274 liniek).
2. `creature_text.Text` == text, ktorý klient zobrazí z BT → **0 rozdielov**.
3. `Sound` je platný SoundKit → **0 neplatných**.
4. Efektívny kit (BT kit alebo `Sound`) existuje → **0 neplatných**.
5. Efektívny kit má aspoň jeden súbor → **6 kitov** má FileDataID mimo community listfile,
   ale všetky 6 fíd sú v CASC (`HTTP 200` na wago `/api/casc/<fid>`) → zvuk hrá.
6. Reproduktor: priečinok VO vs meno creatury → párované s aliasmi a generickými bankami.
7. `creature_text.Sound` ukazuje na cudzí konkrétny NPC hlas → 8 140 riadkov, z toho
   drvivá väčšina je **retail dizajn** (zdieľané voice banky; overené proti retail snapshotu).
8. Ženský model + BT iba s mužským kitom → 41 riadkov, retail dáta (rovnaké v snapshote).
9. Hovorený riadok bez zvuku → 28 038; v TDB 12.1.0 aj v retail snapshote **0** takých
   riadkov, ktoré by mali prehrateľný kit → sú to text-only línie.
10. TDB 12.1.0 diff: **0 stratených zvukov**, 41 riadkov naopak vylepšených (TDB kit 0).

## Opravené (5 SQL súborov, 664 riadkov, všetko s `_undo.sql`)

| Súbor | Riadkov | Čo robí |
|---|---|---|
| `20261022_vo_verify.sql` | 225 | 113× `clear_bt` (BT bol cudzia/placeholder línia), 73× `set_sound` (vlastný VO kit s presne rovnakým textom), 26× `relink_prefix` (skrátený fragment → plná retail línia z vlastného priečinka), 12× `align_text` (parafráza → text BT), 1× `relink_bt` (Lor'themar 235787: BT 283069 → 283068, kit 300626) |
| `20261022_vo_verify_align.sql` | 26 | text 26 relinkovaných fragmentov zladený s plnou líniou BT |
| `20261022_vo_verify_chicken.sql` | 1 | Chicken 620 g1/0 mala BT 5140 = „Skinning"; BT odpojené, retail text `%s looks at you expectantly.` |
| `20261022_vo_retail_sound.sql` | 412 | doplnený retail `Sound` pre riadky, ktoré boli ticho (366× rovnaká línia podľa BT, 46× vlastný voice priečinok) |

Zálohy: `world.bak_20261022_vo_verify_ct`, `world.bak_20261022_vo_retail_sound_ct`
(52 849 riadkov každá).

Príklady:

* Ji Firepaw 56418 g0/3: text „If we lose the healers" + BT 27288 (zlá línia) →
  BT 66063 celá línia + kit 27288 `jifirepaw`.
* Ysondre 14887, Emeriss 14889, Shade of Hate 35503, Liam 38474, Tenwu 63616:
  ticho → vlastný kit z `ysondre` / `emeriss` / `shade` / `liam` / `tenwu`.
* Geargrinder Gizmo 36600 g1/0 „Yeah" s BT 1 („Help help! I'm being repressed!") → BT 0.
* Lady Blaumeux 16065, Prince Malchezaar 15690, Aysa 61792, Tichondrius 103685:
  doplnený retail Sound (`dameblaumeux`, `princemalchezzar`, `aysacloudsong`, …).

## Stav po opravách

| Metrika | Pred | Po |
|---|---|---|
| `creature_text` riadkov | 52 849 | 52 849 |
| hovorených (type 12/14/15) | 44 732 | 44 732 |
| s prehrateľným zvukom | 16 292 | **16 694** |
| s BT linkou | 43 274 | 43 274 |
| text ≠ zobrazený BT text | 152 | **0** |
| visiaci BT | 0 | 0 |
| neplatný Sound / kit | 0 | 0 |
| zhoda s retail snapshotom (identických riadkov) | 32 822 | **32 939** |
| TDB 12.1.0 stratené zvuky | 0 | 0 |

Overenie: `vo_verify_retail.py` (posledný beh), `vo_verify_final.py` (vzorka kitov →
CASC `HTTP 200`, wago definícia typu `10/17` = dialog), `_final_stats.py`.

## Čo zostáva (a prečo to nie je bug)

* **28 038 hovorených riadkov bez zvuku** – TDB 12.1.0 ani retail snapshot na tých istých
  kľúčoch nemajú prehrateľný kit. Sú to text-only línie (napr. „Stormwind City Guard").
* **8 140 „cudzí" reproduktor** – retail zdieľa voice banky: koboldi → `skywhisker_scrapper`,
  démoni „You dare?!" → `eredar_summoner_*`, `Coming at ya!` → `human_male`. Rovnaké
  Sound id má aj retail snapshot.
* **841 combat-sound-as-speech** – klasické boss línie sú v súboroch `*_aggro` / `*_death`
  (Thaddius, Medivh); je to ich VO, nie efekt.
* **41 gender_voice** – BT má iba mužský kit, model je ženský; retail dáta.
* **286 tdb_text_diff** – 124 len interpunkcia, 100 parafráza / poradie v random skupine,
  62 iná formulácia (zoznam v `issues.csv`, kategória `tdb_text_diff`). Zobrazovaný text
  ide z BT a je konzistentný; BT linky sedia s retailom (`wago` 0 rozdielov).
* **6 kitov s neznámou cestou** – súbor v CASC existuje, chýba len v community listfile.
* **487 riadkov retail snapshotu chýba u nás / 677 našich navyše** – custom/skriptované
  riadky, nie retail `creature_text`.

## Otvorené fronty (mimo tohto auditu)

* **Midnight**: `midnight_autofill_plan.csv` 1 452 replays / 49 postáv sa neaplikoval –
  vyžaduje ASR overenie textu pred zápisom.
* **ASR front**: 5 892 riadkov bez zhody textu s BT – bez transkripcie sa nedá bezpečne
  priradiť kit.

## Ako aplikovať / vrátiť

```sql
-- poradie (všetko už aplikované)
20261022_vo_verify.sql
20261022_vo_verify_align.sql
20261022_vo_verify_chicken.sql
20261022_vo_retail_sound.sql
```

Undo v opačnom poradí (`*_undo.sql`). Server bol vypnutý – pri štarte si `creature_text`
načíta sám; ak beží, stačí `.reload creature_text` (BT/sound_kit sa nemenili).

## Skripty

* `Custom/tools/vo_verify_retail.py` – 10-dimenzionálny audit (read-only).
* `Custom/tools/vo_analyze.py` – hľadanie kandidátov (tiché riadky, reproduktor).
* `Custom/tools/vo_fix_retail.py` – stavba fix plánu (`plan2.csv`).
* `Custom/tools/vo_fix_apply.py` – aplikácia + SQL/undo + verifikácia.
* `Custom/tools/vo_align_text.py` – zladenie textov po relinku.
* `Custom/tools/vo_retail_sound_plan.py` / `vo_retail_sound_apply.py` – retail Sound.
* `Custom/tools/vo_verify_final.py` – dôkazný beh (text + kit + CASC + wago).
* `Custom/tools/_retail_ct_diff.py`, `_retail_parity.py`, `_agreement.py` – retail snapshot analýza.
