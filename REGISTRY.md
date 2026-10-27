# Register nášho vlastného obsahu

Všetko, čo sme pridali my (nie retail/TDB). Slúži na audit a kompletné
odstránenie. Súbory: `Custom/sql/`, `Custom/lua/`.

## NPC (creature_template entry)

| Entry | Meno | Súbor |
|---|---|---|
| 95000 | Fortuna Fatecaller (gossip draft UI) | wildcard_pack.sql |
| 95104 | Warden Kaelis (vendor) | wildcard_pack.sql |
| 95106 | Keeper Juzan (vendor) | legends_armory.sql |
| 95113 | Warden Velarys (questgiver) | warden_ch1.sql |
| 95114 | Felsong Renegade | warden_custom_mobs.sql (+felsong) |
| 95115 | Shadowfen Betrayer | warden_custom_mobs.sql |
| 95116 | Talonbreaker Renegade | warden_custom_mobs.sql |
| 95124 | Ashenfall Betrayer | warden_custom_mobs.sql |
| 95125 | Pineshadow Turncloak | warden_custom_mobs.sql |
| 95126 | Felbriar Warden | warden_custom_mobs.sql |
| 95127 | Duskwarden Turncoat | warden_ch3.sql |
| 95128 | Felsworn Warden | warden_ch3.sql |
| 95129 | High Betrayer Sarthis (boss) | warden_ch4.sql |
| 95140 | Felbound Hound | warden_ch5.sql |
| 95215 | Felwing Terror | warden_ch5.sql |
| 95218 | Fel Lasher | warden_ch5.sql |
| 95252 | Felsworn Marauder | warden_ch5.sql |
| 95257 | Phase Test Watcher (prototyp fázy) | 20261003_phase_prototype.sql |
| 95287 | Fel Commander Urgoz (boss) | warden_ch6.sql |
| 95293 | Felborne Overfiend (boss) | warden_ch6.sql |
| 96112 | Maiev Shadowsong (cameo) | warden_ch4.sql |

Spawny: guid 3001000732–3001000826 (vrátane). Modely/displaye sú požičané
z retail NPC (20628, 21020, 21349, 63393, 66480, 4849…), nie vlastné.

## Questy (ID 95000–95017, len Night Elf, giver Velarys 95113)

Ch.1: 95000–95002 · Ch.2: 95003–95005 · Ch.3: 95006–95008 · Ch.4: 95009–95010 ·
Ch.5: 95011–95014 · Ch.6: 95015–95016 · prototyp fázy: 95017.
Objektívy 955000–955017. Súbory warden_ch1–ch6.sql, warden_poi.sql,
20261003_phase_prototype.sql (+ _undo.sql).

## Texty a fázy

* npc_text 95000 (Fortuna), 95001–95005 (Velarys gossip)
* broadcast_text (hotfixes) 9900000 (Fortuna), 9900001–9900005 (Velarys)
* Fáza 9511 'Warden Campaign Prototype Phase' + phase_area (186→9511)
  + conditions (SourceType 26, quest 95017, maska 10) — len prototyp

## Hero Classes v1 (prototyp)

* NPC **9900100** Hero Master Arvenne (Orgrimmar, spawn guid 3001000900)
* Tabuľka `characters.hero_class`; súbory hero_class.sql (+ _undo.sql), lua/hero_class.lua
* Cesty: Fel Warden, Archmage, Templar (retail spelly, nie vlastné)

## Living World engine v1

* NPC **9900110** Caravan Master Grukk, **9900111** Caravan Kodo (vozidlo 419), **9900112** Caravan Guard
* Tabuľky `world.lw_route_node`, `world.lw_caravan`; súbory lw_engine.sql (+ _undo.sql), lua/lw_engine.lua, ROADMAP.md
* Hliadky: NPC **9900113** Patrol Sergeant, **9900114** Night Watch Captain, tabuľka `world.lw_patrol` (lw_patrol.sql + _undo), lua/lw_patrol.lua
* Trasy 1 (Orgrimmar–Razor Hill, 31 bodov podľa braziers) a 2 (nočný okruh Orgrimmarom, 27 bodov), spawny 3001000961–963 vo fáze 9600 (lw_routes_durotar.sql + _undo)
* Zvieratá: lua/lw_ambient.lua (bez DB)
* **Hlavná fáza 9600** 'Living World Main Phase' (lw_main_phase.sql + _undo): kozmetická (hotfixes.phase Flags=16, lw_main_phase_v2.sql), phase_area pre všetkých 538 zón všetkých máp; aj prototyp 9511 je kozmetický; naše living world spawny (3001000900–960) a GM spawny karaván/hliadok sú v nej
* Vlastné NPC (lw_npcs.sql + _undo): **9900115** Durotar Road Grunt, **9900116** Orgrimmar Night Watch, **9900120** Orgrimmar Citizen (24 spawnov), **9900121** Darkspear Villager (8), **9900122** Orgrimmar Laborer (8); spawny guid 3001000901–3001000960
* Stráže: lua/lw_guards.lua (obchôdzky okolo postu, bez DB)
* Razor Hill (lw_razorhill.sql + _undo): **9900123** Razor Hill Villager ×10, robotníci ×4, trolovia ×3, guid 3001000964–980, fáza 9600; lw_town podporuje aj areaId (362)
* Sen'jin Village (lw_senjin.sql + _undo): trolovia ×9, robotníci ×2, guid 3001000981–991, fáza 9600; trasa 1 predĺžená do Sen'jin (63 bodov, 3 zastávky)
* Crossroads (lw_crossroads.sql + _undo): **9900124** Crossroads Settler ×8, **9900125** Mulgore Wanderer (tauren) ×3, robotníci ×2, guid 3001000992–1004, fáza 9600; rečové sady barrens + tauren
* Mesto: lua/lw_town.lua (Orgrimmar: obyvatelia nakupuju, spia v hostinci, siroty sa hraju, predavaci vyvolavaju; bez DB)
* Pocasie: lw_weather.sql (+19 zon v game_weather, _undo maze len tie)

## Spelly a tabuľky

* Vlastný spell: **1400000** TEST Fel Glaive (Weak) — hotfixes.spell_name,
  spell_effect, spell_misc + 4× hotfix_data (skupina 1900013)
* Tabuľky: `characters.wildcard_state`, `characters.warden_honors`,
  `characters.spyglass` (Spyglass je vypnutý, tabuľka prázdna)
* POZOR — toto NIE JE naše (bolo pred nami): custom spelly 1900000–1900002
  (Flightswitch/Health Funnel), custom NPC 95584 Marin Bladewing

## Hero (Classless + Wildcard)

* Tabuľky `characters.wildcard_path` (cesta 0/1/2), `characters.wildcard_classless` (kúpené schopnosti a ich cena) – hero_paths.sql (+ _undo)
* **Hero Essence** (hero_essence.sql + _undo): hotfix UnitPowerBar 9990, aura-spell 1400010, SpellPower pre 96 kúziel poolu (push 1900100, nové riadky 9500000+)
* **Čistý Hero**: `world.hero_class_spells` (1 134 triednych kúziel; hero_class_spells.sql + _undo)
* **C++** build zo Source/Draconic-RoleplayCore (diff: cpp/draconic-local.patch), nasadený 2026-10-04, starý exe v bin/RelWithDebInfo/_backup_prebuild_20261004
* Klientský addon Custom/addon/Wildcard (roll okno, /ca panel, výber cesty), grafika z mod-classless-wildcard (GPL-2.0)

## Lua (Custom/lua → lua_scripts, všetko SYNC)

wildcard.lua (+wildcard_npc časť v ňom: Fortuna gossip), warden_story.lua
(Velarys gossip + honors), warden_mob_spells.lua, fel_mob_spells.lua,
spyglass.lua (vypnutý presunom client addonu na Spyglass_OFF),
org_adventurers.lua, orgrimmar_alive.lua (+klebety), stormwind_alive.lua,
org_guard_backup.lua, appearance.lua, CollectorsBounty.lua, Flightswitch.lua,
WorldChat.lua

## Výnimky z pravidla add-only (spravené PRED zavedením pravidla)

* 2026-10-04: zmazaných 10 742 presných duplicitných spawnov (20261004_dedupe_creatures.sql); riadky uložené v `world.custom_removed_creature`, undo súbor, záloha daily_20261004_013247.7z.
* 2026-10-04: 497 názvov NPC/objektov/questov prepísaných na angličtinu podľa Wowhead (20261004_english_names.sql), pôvodné v `world.custom_name_backup`, undo súbor.
* 2026-10-04: 1 041 cudzojazyčných textov preložených do angličtiny (839 replík NPC, 137 broadcast textov, 54 gossip možností, 11 opisov questov; 20261004_english_texts.sql), pôvodné v `world.custom_text_backup`, undo súbor.

Upstream DB fixy (15 v world.updates), Nargol vendor, class_expansion_requirement
(vrátane opraveného preklepového riadku), TRUNCATE failed_logins, captcha configy
(www+ssl), worldserver.conf logging, AIO.lua guard, npcflag Kaelis 129/131.
Tieto menili pôvodné riadky a nedajú sa vrátiť jedným undo súborom.

## Hero talenty, Worldforge, Mystic Enchants (2026-10-04)

* **Hero talenty** (hero_talents.sql + _undo): vlastné pasívne kúzla **1400100–1400127** (10 všeobecných talentov po ranky), hotfix push 1900110; 165 retail talentov naviazaných na Hero schopnosti je v `wildcard.lua` (TALENTS, generuje scratch talents_build.py). Tabuľka `characters.hero_talents`. Talent Essence 1/level od 10, Wildcard roll talentu na párnych leveloch od 10.
* **C++**: Hero Essence aura vypne retail talentový strom (SpellAuraEffects HandleEnableAltPower, Player::ApplyTraitEntry, TraitHandler commit) – diff v cpp/draconic-local.patch, starý exe v bin/RelWithDebInfo/_backup_pretalents_20261004
* **Worldforge itemy** (worldforge_items.sql + _undo): hotfix item/item_sparse/item_modified_appearance **9700001–9701383** (1 383 itemov z Worldforged Atlas), push 1900120; tabuľka `world.worldforge_item` (zóna, súradnice, svetová poloha)
* **Worldforge objekty** (worldforge_objects.sql + _undo): gameobject_template **9700004–9701383** (goober, entry = item), spawny ukladá `worldforge.lua` do `gameobject` keď príde hráč (spawn_guid=1); `characters.worldforge_looted`
* **Mystic Enchants** (mystic_enchants.sql + _undo): `world.mystic_enchant` (805), vlastné pasívy **1401000–1401804** (629 ks), push 1900130; Mystic Scroll objekty **9710001–9710805**, `world.mystic_spawn` (3 197 miest); `characters.mystic_collection`
* Zdrojové dáta: Custom/data (worldforged.csv, worldforged_atlas.json, ascension_markers.csv, coa/)
* **Worldforge pre všetky expanzie** (worldforge_world.sql + _undo, 2026-10-04): itemy + objekty **9720001–9723399** (3 399 v 362 zónach a dungeonoch, vzhľad/scaling z retail itemov danej expanzie), statické spawny `gameobject` guid **3100000001–3100004320** (aj 921 Mystic Scrollov), hotfix push 1900140
* **Hero pool v3**: +143 schopností (spolu 239), Essence ceny regenerované (hero_essence.sql), talenty 320 retail + 28 všeobecných (hero_talents.sql, talents_build.py)

## Playability + living world v2 (2026-10-04)

* **Spirit Healers** (spirit_healers.sql + _undo): 736 × 6491 pri cintorínoch bez viditeľného healera (creature guid **3002000001–3002000736**), 355 riadkov `graveyard_zone` s Comment 'custom: graveyard in zone'
* **Mystic Altare / Hero Traineri / Bounty Masteri** (mystic_altars.sql + _undo): NPC **9900130** Mystic Enchanter, **9900131** Hero Trainer, **9900132** Bounty Master, oltár GO **9709999**; spawny creature guid 3002100001–, gameobject guid 3100100001–; `characters.mystic_runes`, `characters.mystic_rune_claim`
* **ascension_world.lua** + ascension_world.sql: rare/world boss/dungeon boss odmeny, denné bounty (`characters.hero_bounty`), High-Risk zóny (Lost Satchel GO **9709998**)
* **Living world v2**: orgrimmar_alive.lua (nové rečové balíky human, dwarf, forsaken, sindorei, draenei, shattrath, dalaran, valdrakken, earthen; automatickí hovoriaci v 13 hlavných mestách + 396 dedinách s hostincom), lw_town.lua (rutiny vo všetkých týchto mestách)
* **world_events.lua** + world_events.sql (2026-10-04): útoky na dediny, migrácie, búrky, eskorta/prepad karavány, mestská reputácia (`characters.city_rep`, `world.we_hostile_faction`); lw_combat.lua ALL_ZONES = true (lore kúzla mobov v celom svete)
* **Challenges** (challenges.sql + _undo, lua/challenges.lua, 2026-10-04): NPC **9900133** Challenge Master (25 spawnov, creature guid 3002200001–), tituly CharTitles **1400–1406** (MaskID 900–906, hotfix push 1900150), `characters.hero_challenge`
* **Manastorms** (manastorm.sql + _undo, lua/manastorm.lua): NPC **9900134** Manastorm Keeper (creature guid 3002300001–), kúzla **1402000–1402009** (posilnenie mobov) a **1402100–1402107** (boony), hotfix push 1900160, `world.manastorm_pool`, `characters.manastorm`; aréna na GM Island (map 1)
* **Conquest of Azeroth cesta** (coa_path.sql + _undo, lua/coa_kits.lua): Hero cesta 3, 21 CoA tried ako kity retail kúziel, `characters.wildcard_coa`; addon PathChoice má 3. tlačidlo
* **ascension_extra.lua** + ascension_extra.sql: Dungeon Tiers (.tier 0-5), zbierky (`characters.hero_collection`, tituly **1407–1408**, hotfix push 1900170, mounty 41252/230987), ságy (`characters.hero_saga`, lua/saga_zones.lua); world_events.lua: warlord boss po 3 obránených útokoch v zóne
* **Living world v4** (2026-10-04): living_roads.sql + _undo (33 ciest route 100+, karavány **9900300+**, hliadky **9900400+**, kodo 9900299, creature guid 3002400001–), living_world4.sql + _undo (cestovatelia **9900135–9900137**, `characters.inn_room`, `world.lw_economy`), lua/living_world4.lua (práca, krčmy, herold, pohreby/oslavy, deň/noc, ekonomika, zver, izby, cestovatelia)
* **Izby v hostincoch** (inn_rooms.sql + _undo): Room Door GO **9709997** v 438 hostincoch (gameobject guid 3100200001–), kľúč **9730001** Inn Room Key (hotfix push 1900180)
* **Zver podľa zón** (fauna.sql + _undo, 2026-10-04): 6 270 spawnov domácich critterov a pokojných zvierat v 130 zónach (creature guid 3002500001–)

## Retail opravy questov (2026-10-19)

* **Loss Reduction (25179, Durotar)** (`20261019_loss_reduction.sql` + `_undo`, `lua/loss_reduction.lua`): podľa retailu quest začína na **Injured Razor Hill Grunt (39270)** — kredit do objektívu 256780 cez rozhovor — a je dostupný až po dokončení **25173** (`PrevQuestID` 0 → 25173). Rozhovor s gruntom = záchrana: vstane (dolu aura feign death **75511**), povie repliku (bcast **39302**), chvíľu ide za hráčom a potom odbehne (despawn). SmartAI riadky pre 39270 sú na tomto jadre mŕtve (každý tvor beží na Eluna AI), preto Lua. Add-only: Gar'Thokov starter riadok (3139) ostáva, ender (3139) bez zmeny.
