# Legacy of the Amani (92895–93012) — stav a worklist (2026-10-18)

Questline patche 12.0.7 (súčasť Midnight "Revelations" kampane), ktorý ústí do 12.1
"Curse of Ula'tek" (Coiled Isle). Zdroje: Warcraft Wiki (`Curse_of_Ula%27tek_campaign`,
`A_Favor_for_Kinduru`), `midnight_full_audit.md` (10/12), `all_startend.json` (Wowhead), vo série klienta.

## Hotovo (quest v DB + lua scéna nasadená)

| ID | Quest | Poznámka |
|---|---|---|
| 92897 | The Preparations Are Complete | objective doplnený (`20261009_quest_92897_objective.sql`) |
| 92895 | Hagar's Invitation | `hagar92895.lua` (accept scéna, rootway, arrival do Denu) |
| 92899 | History Lesson | `historylesson92899.lua` (insight kredity + says, movie button) |
| 92900 | A Favor for Kinduru | `afavor92900.lua` (elf/troll stay-awhile scény, join, Den); SQL `20261011_afavor92900.sql` |

Dabing: vo_1207 séria (373 súborov, patch 12.0.7) — kity ZAPOJENÉ 2026-10-18 (transkripcia + fuzzy
match + cross-verify `verify_kits.py` 33/33): 92895 4 línie, 92899 7 línií (talanji "troops" lore bez VO),
92900 24 línií (elf 10, troll 10, join 2, den 1). Commit `331fc3f`.

## Zostáva implementovať (audit 10/12: no starter / no ender / no offer-reward text)

| ID | Quest | start -> end (all_startend.json) | dáta |
|---|---|---|---|
| 92901 | Revisionist History | Orweyna 253675 -> Orweyna 255659 | má KC markery |
| 92904 | Return to Zul'Aman | Zul'jan 255660 -> Zul'jan 253788 | rootway + terrace KC |
| 92907 | Amani Answers | Zul'jan 253788 -> Zul'jan 256363 | box/mask/tools KC |
| 92955 | The Tablets of Numazon | ? | dotiahnuť z Wowhead |
| 92957 | There's the Rub | Zul'jan 253834 -> Kinduru 253832 | v all_startend.json |
| 92958 | Brain Drain | ? | dotiahnuť z Wowhead |
| 92952 | Mission to Maisara | ? | dotiahnuť z Wowhead |
| 92953 | Memories of Malacrass | ? | dotiahnuť z Wowhead |
| 92951 | Digging Deeper | ? | dotiahnuť z Wowhead |
| 92954 | Maisara Caverns: Master of Souls | ? | dungeon quest |
| 93010 | The Serpent Shrine | ? | dotiahnuť z Wowhead |
| 93011 | Legacy of the Amani | ? | dotiahnuť z Wowhead |
| 93012 | Dead End | ? | koniec reťazca |
| 98541 | (bez názvu) [Legacy of the Amani] | — | MISSING quest_template úplne |

### KC markery z all_startend.json

- **92901**: 258654 Ancient visionstone activated, 253769 Enemy of the Amani, 253770 Destroyer of the Amani,
  255402 KC: Amani Rescued [DNT], 253709 KC: 50% Bar Fill [DNT], 255556 Play 50% Dialogue,
  255558 Summoning completed, 255593 Summoning started
- **92904**: 260813 Take the Rootway to Zul'Aman, 256012 Arrive at Talonstrike Terrace
- **92907**: 256086/258778/256088 First/Second/Third box searched, 256221 Befuddled Amani Mask caught,
  256253 Give the Befuddled Amani Mask to Kinduru, 256334/256335 Woodworking Tool/Supplies collected,
  KC: Tools / KC: Spare Wood / KC: Proxy Wood [DNT]
- **92957**: Zul'jan 253834, Kinduru 253832, Kinduru's Mortar (object 628271)

## Dabing v klientovi (vo série pre Legacy + 12.1)

- **vo_1207_** (373 súborov) = dabing Legacy prologu: lorthemar_theron 3, lady_liadrin 3, vereesa_windrunner 6,
  rokhan 5, queen_talanji 4, zekhan 3, shandris_feathermoon 1, first_arcanist_thalyssra 1, den_welcomer 1,
  orweyna 18, magister_umbric 16, zuljan 39, zuljarra 12, loa_speaker_kinduru 25, befuddled/enchanted_amani_mask 8+7,
  hex_lord/hex ženy, elder_sunhorn, aedh_firebeard, riftblade_maella, decimus, rommath, zekhan... — fid→kit map:
  `docs/legacy_vo1207_kits.md` (generuje sa z whisper_f3 + SoundKitEntry CSV).
- **vo_121_** (481) + **vo_1215_** (195) = dabing 12.1 Curse of Ula'tek: zuljarra 77+46, orweyna 53+10,
  liadrin 33+34, lorthemar 6+46, magister_umbric 35, dakzor 31+5, arator 30+16, taklejo 25+7,
  astalor_bloodsworn 18, nekzali_the_soulcoiler 12, lord_antenorian 11, captain_tokka 5, hex_lord_malacrass 5,
  breath_of_ulatek 2, blood_of_ulatek 1, sszorak 2, vashnik 2, morzahi 1, nymrissa_wavecaller 2, ...
  (pre budúce 12.1 questy; transkripcia zatiaľ nespustená)
- **vo_1205_** (43): ranger_captain_lilatha 21, kulamara_the_fierce 20 (12.0.5 obsah)

Kity: `docs/wago_csv/SoundKitEntry_12.1.5.70391.csv` (vo_1207 fid 7708057+ -> kit 337042+).

## Dátové zdroje pre implementáciu

1. `all_startend.json` — starter/ender + KC linky (Wowhead scrape).
2. Wowhead quest stránky pre chýbajúce IDs (objektívy, texty, odmeny).
3. wago CSV (QuestV2, QuestObjective) + `hotfixes.quest_template` — stav až po štarte MySQL.
4. `SNIFF_POSTUP.md` — presný retail import 12.1 cez packet sniff (čaká na hráča, `.pkt` ešte nie je).
