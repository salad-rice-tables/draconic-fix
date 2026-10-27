# Quest 92061 Rising Storm — kompletný fix (10. 10. 2026)

Reťazec: `89388 Voidstorm (optional)` → `92061 Rising Storm` → `86543 Homecoming` → `86549 No Fear of the Dark`.
Všeobecný vzor: `docs/gossip_credit_quest_pattern.md`. Tento súbor = presný postup pre tento quest.

## 1. Zdroje (overené)

- Wowhead tooltip API (`nether.wowhead.com/tooltip/quest|npc/{id}`): 92061, 235787, 250580,
  250587, 239944, 235405, 235411 — giver/ender/objective/zóny/súradnice.
- Warcraft Wiki `Rising_Storm`, `Magisters'_Terrace:_Homecoming`, `Voidstorm_storyline` —
  texty, say, odmeny, progresia (czituje Wowhead quest=92061/86543).
- Guide (slabý zdroj, len starter 89388): noobtoboss `how-to-get-to-voidstorm`.
- Zdrojáky jadra: `GossipDef.cpp` (GossipOptionID autogenerácia), `NPCHandler.cpp:344`
  (Eluna hook beží PRED SmartAI), `Player.cpp` (OptionNpc enum — 3 = Trainer!),
  `GossipDef.h` (LanguageID 0 = Universal, 7 = Common).
- Wowhead priame stránky sú 403-blocknuté — nepoužívať WebFetch, len tooltip API + Wiki.

## 2. Súbory fixov (v poradí, všetky + `_undo.sql`)

| Súbor | Účel |
|---|---|
| `20261010_rising_storm_wiki.sql` | Template: Completion, Progress(AreaDescription), 234000 (23g40s), next→86543; menu 40410/40411 + texty + buttony; creature_text; smart kredity+say; zmazanie placeholderov 40363/40367-opt |
| `20261010_abyss_wiki2.sql` | Starter 89388→235411; 86543 Completion + next→86549; Lor'themar/Umbric say (approach/accept/Terrace) |
| `20261010_abyss_wiki3.sql` | Relink `250580→40410`, `250587→40411` (bez linku button neexistuje!) |
| `20261010_lorthemar_46726.sql` | Spawn Lor'themara do fázy 46726 (guid 3001001104, kópia 3000207578) |
| `20261010_abyss_phases.sql` | Spawn Umbrica 239944 do 46726 (guid 3001001106). Bellamy-spawn 3001001105 ZRUŠENÝ vo wiki4! |
| `20261010_abyss_wiki4.sql` | Bellamy cez retail friendly 9100622 (faction 35): link na 40411, kredit+say; červený 250587 (faction 14) link späť, spawn zmazaný |
| `20261010_abyss_wiki5.sql` | Zmazanie Oathstone auto-kreditov pri otvorení (250580-id100, 9100622-id100/101) — kredit LEN po buttone |
| `20261010_abyss_wiki6.sql` | Ambient/approach say (Turalyon group1, Bellamy group1, hello-event, bez kreditu) |
| `20261010_abyss_wiki7.sql` | Zmazanie SmartAI TALK riadkov po buttone (say idú Elunou, anti-duplicita) |
| `20261010_gossip_optionid_fix.sql` | `GossipOptionID = MenuID` (40410/40411) — inak SmartAI `(menu,action)` nikdy nesedí |
| `20261010_broadcast_lang_fix.sql` | `LanguageID 7→0` (Common scrambluje Horde: „Ver nostyec ruftos") |
| `20261010_abyss_english.sql` | deDE/frFR locale riadky (template/objectives/offer/request, 18 ks) → EN; undo generované z live dát |
| `lua/rising_storm_chatter.lua` | PRIMÁRNA cesta: Eluna select → `KilledMonsterCredit` + vlastný say hneď + krížový say o 3000 ms, cooldown 180 s/hráč |
| `20261009_rising_storm.sql` | STARÝ placeholder súbor — neutralizovaný (riadky zmazané vyššie), nespúšťať |

## 3. Kľúčové nástrahy (prečo to dlho nešlo)

1. Link `creature_template_gossip` chýbal → button vôbec neexistoval.
2. `OptionNpc=3` = Trainer → klik posielal trainer request. Má byť 0.
3. `GossipOptionID=0` → jadro generuje záporné ID → SmartAI `(40410,0)` nikdy nesedí.
4. Eluna select-hook beží pred SmartAI → kredit cez Elunu (`KilledMonsterCredit`, vzor `campaigns.lua`).
5. Oathstone auto-kredity pri otvorení obchádzali button → zmazať pre questové objektívy.
6. `LanguageID=7` + Horde hráč = scramblovaný text.
7. deDE/frFR locale riadky (rozbité kódovanie) → prepísať EN.
8. Fázy: správna fáza questu `45749 'Rising Storm'`; hráč vo fáze 46726 nevidel Lor'themara/Umbrica → aditívne spawny.
9. Dvojníci: rovnaké meno ≠ entry (250587 faction 14 vs 9100622 faction 35) — vždy overiť faction + tooltip.
10. Bellamy mal jediný spawn na Void-mape 2912, nie v Silvermoone.

## 4. Overenie po nasadení (povinné)

```sql
SELECT * FROM creature_template_gossip WHERE CreatureID IN (250580,9100622); -- 40410/40411
SELECT MenuID,GossipOptionID,OptionID,OptionNpc FROM gossip_menu_option WHERE MenuID IN (40410,40411);
SELECT entryorguid,id,event_type,event_param1,action_type FROM smart_scripts WHERE entryorguid IN (-250580,-9100622);
SELECT guid,PhaseId FROM creature WHERE guid IN (3001001104,3001001106);
```
Reštart `tools/restart_world.ps1` → `ready` v Server.logu, `DBErrors` prázdny,
Eluna `Successfully loaded rising_storm_chatter.lua`.
Herný test: EN text → klik → kredit + vlastný say + krížový say o 3 s → `?` u Lor'themara.

## 5. Vedome nedorobené (follow-up)

- Citizen yelly (10+ `Silvermoon Citizen` entries, treba správne vo fáze 45749 + ambient).
- Duskglow scéna 86543 (Arator/Lothraxion/Maella gossip, entry neoverené).
- Gear-choice odmeny 86543 (overené ID len 2/6: 251115, 260312).
- Bellamyho orientácia (odhad 0.0, POI smer nedáva).
- Rovnaké mŕtve-button/locale bugy v `20261009_deepening_shadows.sql` (40105/40134/40189, LanguageID 7).
- Extra starteri (92061/239944, 86543/235411) ponechaní — neškodia, mazanie je risk.
- `3001001103` z `20261009_voidstorm_givers.sql` v DB chýba (nikdy neaplikované?).
- `92897 The Preparations Are Complete` nemá starter/ender vôbec.
