# Quest 92061 Rising Storm — full fix (2026-10-10)

Chain: `89388 Voidstorm (optional)` → `92061 Rising Storm` → `86543 Homecoming` → `86549 No Fear of the Dark`.
General pattern: `docs/gossip_credit_quest_pattern.md`. This file = exact procedure for this quest.

## 1. Verified sources

- Wowhead tooltip API (`nether.wowhead.com/tooltip/quest|npc/{id}`): 92061, 235787, 250580,
  250587, 239944, 235405, 235411 — giver/ender/objectives/zones/coords.
- Warcraft Wiki `Rising_Storm`, `Magisters'_Terrace:_Homecoming`, `Voidstorm_storyline` —
  texts, says, rewards, progression (cites Wowhead quest=92061/86543).
- Guide (weak source, starter 89388 only): noobtoboss `how-to-get-to-voidstorm`.
- Core sources: `GossipDef.cpp` (GossipOptionID auto-generation), `NPCHandler.cpp:344`
  (Eluna hook runs BEFORE SmartAI), `Player.cpp` (OptionNpc enum — 3 = Trainer!),
  `GossipDef.h` (LanguageID 0 = Universal, 7 = Common), `SmartScriptMgr.cpp` (entryorguid sign).
- Direct Wowhead pages are 403-blocked — use tooltip API + Wiki, never WebFetch.

## 2. Fix files (in order, all + `_undo.sql`)

| File | Purpose |
|---|---|
| `20261010_rising_storm_wiki.sql` | Template: Completion, Progress (AreaDescription), 234000 (23g40s), next→86543; menus 40410/40411 + texts + buttons; creature_text; smart credits; old 40363 placeholders removed (40367 is a retail taxi menu!) |
| `20261010_abyss_wiki2.sql` | Starter 89388→235411; 86543 Completion + next→86549; Lor'themar/Umbric says (approach/accept/Terrace) |
| `20261010_abyss_wiki3.sql` | Relink `250580→40410`, `250587→40411` (without the link the button does not exist!) |
| `20261010_lorthemar_46726.sql` | Lor'themar spawn into phase 46726 (guid 3001001104, copy of 3000207578) |
| `20261010_abyss_phases.sql` | Umbric 239944 spawn into 46726 (guid 3001001106). Bellamy spawn 3001001105 DELETED in wiki4! |
| `20261010_abyss_wiki4.sql` | Bellamy via retail friendly 9100622 (faction 35): link to 40411, credit+say; red 250587 (faction 14) link back, spawn deleted |
| `20261010_abyss_wiki5.sql` | Deleted Oathstone auto-credits on open (250580-id100, 9100622-id100/101) — credit ONLY after button |
| `20261010_abyss_wiki6.sql` | Ambient/approach says (Turalyon group1, Bellamy group1, hello-event, no credit) |
| `20261010_abyss_wiki7.sql` | Deleted SmartAI TALK rows after button (says go through Eluna, anti-duplication) |
| `20261010_gossip_optionid_fix.sql` | `GossipOptionID = MenuID` (40410/40411) — otherwise SmartAI `(menu,action)` never matches |
| `20261010_broadcast_lang_fix.sql` | `LanguageID 7→0` (Common scrambles for Horde: "Ver nostyec ruftos") |
| `20261010_abyss_english.sql` | deDE/frFR locale rows (template/objectives/offer/request, 18 pcs) → EN; undo generated from live data |
| `20261011_evil91967.sql` | 91967 menus/buttons/credits/scene (see quest note) |
| `20261011_evil_optionid.sql` + `..._warlock.sql` | Unique button IDs + warlock submenu for 91967 |
| `20261011_citizens.sql` | Talking civilians (2 Wiki texts) + ambient yells during 92061 |
| `lua/rising_storm_chatter.lua` | PRIMARY path: Eluna select → `KilledMonsterCredit` + own say immediately + cross say after 3000 ms, cooldown 180 s/player |
| `lua/you_know_this_evil.lua` | Same pattern for 91967 (menu-gated credits, Anduin 8-line scene) |
| `20261009_rising_storm.sql` | OLD placeholder file — neutralized (rows deleted above), do not run |

## 3. Key traps (why it took so long)

1. Missing `creature_template_gossip` link → button does not exist at all.
2. `OptionNpc=3` = Trainer → click sent a trainer request. Must be 0.
3. `GossipOptionID=0` → core generates negative IDs → SmartAI `(40410,0)` never matches; duplicates in one menu → client sends only the first button.
4. Eluna select-hook runs before SmartAI → credit through Eluna (`KilledMonsterCredit`, pattern from `campaigns.lua`).
5. Oathstone auto-credits on open bypassed buttons → delete for quest objectives.
6. SmartAI `entryorguid` must be POSITIVE (template); negative = spawn guid → row never loads.
7. `LanguageID=7` + Horde player = scrambled text.
8. deDE/frFR locale rows (broken encoding) → overwrite with EN.
9. Phases: correct quest phase `45749 'Rising Storm'`; player in phase 46726 saw neither Lor'themar nor Umbric → additive spawns. Retail conditional phases (`conditions` type 26 + `QUESTSTATE` 47) cover the rest.
10. Twins: same name ≠ entry (250587 faction 14 vs 9100622 faction 35) — always verify faction + tooltip.
11. Bellamy's only spawn was on Void-map 2912, not in Silvermoon.

## 4. Mandatory verification after deploy

```sql
SELECT * FROM creature_template_gossip WHERE CreatureID IN (250580,9100622); -- 40410/40411
SELECT MenuID,GossipOptionID,OptionID,OptionNpc FROM gossip_menu_option WHERE MenuID IN (40410,40411);
SELECT entryorguid,id,event_type,event_param1,action_type FROM smart_scripts WHERE entryorguid IN (250580,9100622);
SELECT guid,PhaseId FROM creature WHERE guid IN (3001001104,3001001106);
```
Restart `tools/restart_world.ps1` → `ready` in Server.log, empty `DBErrors`,
Eluna `Successfully loaded rising_storm_chatter.lua`.
In-game test: EN text → click → credit + own say + cross say after 3 s → `?` at Lor'themar.

## 5. Knowingly unfinished (follow-up)

- Duskglow scene 86543 (Arator/Lothraxion/Maella gossip, entries unverified).
- Gear-choice rewards 86543 (only 2/6 IDs verified: 251115, 260312).
- Bellamy facing (guess 0.0, POI gives no facing).
- Same dead-button/locale bugs in `20261009_deepening_shadows.sql` (40105/40134/40189, LanguageID 7).
- Extra starters (92061/239944, 86543/235411) left alone — harmless, deleting is risky.
- `3001001103` from `20261009_voidstorm_givers.sql` missing in DB (never applied?).
- `92897 The Preparations Are Complete` has no starter/ender at all.
- Citizens gossip split (Citizens vs Residents) is an assumption — Wiki blocks are indistinguishable.
