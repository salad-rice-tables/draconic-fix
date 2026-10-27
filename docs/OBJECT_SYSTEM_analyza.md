# Analýza gameobjectov, fáz, ciest a systémov – podľa Wowheadu

Zdroj: `Custom/sql/*.sql` (105 súborov) + `Custom/lua` (41 súborov) + `Custom/REGISTRY.md`.
Wowhead logika: GO `type` (10 goober = klikací), `map/zoneId/areaId` (kontinent/zóna),
fáza `phaseId`, cesta `lw_route_node`, event `world_events`.

---

## 1. Gameobjecty (klikacie predmety vo svete)

| entry | Meno | Type | Počet spawnov / kde |
|---|---|---|---|
| 9700004-9701383 | Worldforge loot (Atlas) | 10 goober | Dynamické cez `worldforge.lua` (`spawn_guid=1`, hráč príde → spawn). Meno = item (napr. 9700004 Alteraci Avenger). |
| 9720001-9723399 | Worldforge loot (World) | 10 goober | Statické `gameobject` guid 3100000001-3100004320 (4320 spawnov, 921× Mystic Scroll). Všetky mapy 0/1/530/571 + dungeony, 362 zón. |
| 9710001-9710805 | Mystic Scroll | GO | 3197 miest `world.mystic_spawn` (všetky kontinenty). Klik → enchant do `mystic_collection`. |
| 9709997 | Room Door | 10, display 2751 | **438 hostincov** (guid 3100200001-438, 13 miest + 396 dedín). Hore pri najvyššej stoličke. Otvára kľúč 9730001 (`living_world4.lua .room`). |
| 9709998 | Lost Satchel | GO | High-Risk zóny, denná bounty (`ascension_world.lua`). |
| 9709999 | Mystic Altar / Oltár | GO | Hlavné mestá + 4 open world (`mystic_altars.sql`, guid 3100100001+). |

Komu patrí: **nikomu – neutrálne**, použije každý (Horda aj Aliancia).
Kontinent: **všetky** (Atlas classic Eastern+Kalimdor, World všetky expanzie).

---

## 2. Fázy (phasing)

| fáza | Meno | Kde / čo robí |
|---|---|---|
| 9600 | Living World Main Phase | Kozmetická (`phase Flags=16`), `phase_area` pre 538 zón všetkých máp. V nej spawny 3001000900-1004 (civilisti, karavány, hliadky) + GM karavány. Súbory `lw_main_phase*.sql`. |
| 9511 | Warden Campaign Prototype Phase | Len prototyp questu 95017 (`phase_area` 186→9511, conditions SourceType 26). |
| 169 | Retail fáza | Pôvodné spawny, z ktorých kopírujeme pozície (PhaseId 0/169 filter). |

---

## 3. Cesty, karavány, hliadky (Living World engine)

- `world.lw_route_node`, `world.lw_caravan`, `world.lw_patrol` + Lua
  `lw_engine.lua`, `lw_patrol.lua`, `lw_guards.lua`, `lw_town.lua`, `living_world4.lua`.
- Trasa 1: Orgrimmar→Razor Hill→Sen'jin (63 bodov, 3 zastávky, podľa braziers).
  Trasa 2: nočný okruh Orgrimmarom (27 bodov).
- Route 100+: 33 ciest (`living_roads.sql`), karavány **9900300+**, hliadky **9900400+**,
  kodo 9900299, guid 3002400001+. Fáza 9600.
- NPC: 9900110 Grukk + 9900111 Kodo (vehicle 419) + 9900112 Guard + 9900113 Sergeant
  + 9900114 Captain. Všetci faction 35, Kalimdor (Durotar/Barrens).
- Mesto: `lw_town.lua` rutiny (nákup, spánok, siroty, vyvolávači), `orgrimmar_alive.lua`
  hovorové balíky (human/dwarf/forsaken/sindorei/draenei/shattrath/dalaran/valdrakken/
  earthen) v 13 mestách + 396 dedinách. `lw_ambient.lua` zver bez DB.
- Počasie: `lw_weather.sql` (19 zón `game_weather`). Ekonomika: `world.lw_economy`,
  `characters.inn_room`, `hero_bounty`, `city_rep`, `we_hostile_faction`.
- Eventy: `world_events.sql` + `world_events.lua` – útoky na dediny, migrácie, búrky,
  eskorta/prepad karavány, warlord boss po 3 obránených útokoch. `lw_combat.lua`
  ALL_ZONES (lore kúzla mobov v celom svete).

---

## 4. Systémy (Hero / Wildcard / Ascension / Challenges / Manastorm)

| Systém | Tabuľky / kľúčové ID | Lua / C++ |
|---|---|---|
| Wildcard / Classless | `wildcard_path` (0/1/2), `wildcard_classless`, `wildcard_coa`, `warden_honors`, `wildcard_state` | `wildcard.lua` (+Fortuna gossip), `coa_kits.lua` (21 CoA kitov), addon Wildcard (/ca, roll okno). Cesty: Fel Warden, Archmage, Templar + CoA cesta 3. |
| Hero Essence/Talents | bar 9990, aura 1400010, `hero_class_spells` (1134), talenty 1400100-27, `hero_talents`, `hero_bounty`, `hero_challenge`, `hero_collection`, `hero_saga` | `hero_class.lua`, `potions.lua`, `challenges.lua`, `saga_zones.lua`. C++: aura vypne retail strom. |
| Mystic | `mystic_enchant` (805), `mystic_spawn` (3197), `mystic_collection`, `mystic_runes`, enchanter/trainer/bounty 9900130-32 | `mystic_sources.lua`, `worldforge.lua`. |
| Worldforge loot | `worldforge_item`, `worldforge_looted`, itemy 97xxxxx | `worldforge.lua`. |
| Inn rooms | dvere 9709997, kľúč 9730001, `inn_room` | `living_world4.lua` (.room). |
| Challenges | master 9900133 (25 spawnov), tituly 1400-06, `hero_challenge` | `challenges.lua`. |
| Manastorm | keeper 9900134, kúzla 1402000-2107, `manastorm_pool`, `manastorm` | `manastorm.lua`, aréna GM Island. |
| Ascension | rare/boss odmeny, tiers .tier 0-5, zbierky tituly 1407-08, mounty 41252/230987 | `ascension_world.lua`, `ascension_extra.lua`. |
| Ostatné Lua (41) | WorldChat, Flightswitch (1900000-02), CollectorsBounty, appearance, campsites, gm_panel/tool, diag, spell_audit, progression, org_adventurers, org_guard_backup, stormwind_alive, spyglass (vypnutý), fel_mob_spells, warden_mob_spells, warden_story, imp_talk, bugreport, aaa_perf, peons | Všetko SYNC v `lua_scripts`. |

---

## 5. Komu patrí / kontinent (systémy)

- Systémoví NPC: **všetci faction 35 Friendly** (nikoho neaggujú), **Kalimdor**
  (Orgrimmar/Durotar/Barrens) okrem Manastorm Keepera (všade) a Room Door
  (438 hostincov na všetkých mapách).
- Quest texty/gossip: `npc_text` 95000-95005, `broadcast_text` 9900000-9900005
  (hotfixes, Velarys story). Preklady 1041 textov do EN (20261004_english_texts).
- Názvy: 497 prepisov na Wowhead EN (20261004_english_names). Dedup: 10742
  duplicitných spawnov zmazaných (20261004_dedupe). Všetko s undo a backup tabuľkami.
