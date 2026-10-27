# Analýza všetkých custom NPCs – podľa Wowheadu

Zdroj: `C:\WowServer\Custom\REGISTRY.md` + `Custom/sql/*.sql`
Metodika: každý custom `creature_template.entry` rozobraný podľa Wowhead logiky:
`Type` (Humanoid / Beast / Demon …) + `FactionTemplate` (komu je priateľský / nepriateľský –
Horda / Aliancia / Monster / Neutral) + `map` (kontinent) + `zoneId / areaId` (zóna / oblasť)
+ lore „kto je kto“ + Wowhead odkazy na vzory, zóny a frakcie.

> Poznámka: custom entry 95xxx / 99xxx na Wowheade neexistujú. Wowhead odkazy preto
> vedú na (a) retail vzor, z ktorého je NPC okopírované, (b) zónu / frakciu / display model.

---

## 1. Legenda – ako čítať analýzu (všetko podľa Wowhead / TrinityCore DB)

### 1.1 `type` – skupina tvora (Wowhead: Humanoid, Beast, Demon…)

Podľa `creature_template.type` (TrinityCore / AzerothCore wiki):

| type | Wowhead skupina | Čo to je |
|---|---|---|
| 7 | Humanoid | elf, ork, troll, tauren, človek – väčšina našich NPC |
| 1 | Beast | zviera – vlk, medveď, netopier |
| 3 | Demon | démon – satyr, felguard, overfiend |
| 8 | Critter | drobné zvieratko – králik, had, škorpión |
| 6 | Undead | nemŕtvy |
| 4 | Elemental | elementál |
| 9 | Mechanical | mechanický |

Zdroj: https://trinitycore.info/en/database/335/world/creature_template – sekcia `type`
(0=None, 1=Beast, 2=Dragonkin, 3=Demon, 4=Elemental, 5=Giant, 6=Undead, 7=Humanoid, 8=Critter…).

### 1.2 `faction` – FactionTemplate (nie reputácia, ale správanie)

Toto je najdôležitejšie a najčastejšie mýlené. `creature_template.faction` = `FactionTemplate.dbc`
rozhoduje, na koho NPC útočí / komu je zelené.

Overené podľa https://www.azerothcore.org/wiki/factiontemplate (3.3.5a):

| faction | Meno v DBC | ourMask / friendly / hostile | Zjednodušene = komu patrí |
|---|---|---|---|
| 16 | Monster | 8 / 0 / 1 – hostile na všetkých hráčov | **Nepriateľ všetkých – červený pre Hordu aj Alianciu.** Naši „zradcovia Wardeni“, fel moby, bossovia. |
| 35 | Friendly | 0 / 1 / 0 – friendly na všetkých hráčov | **Neutrál – zelený pre všetkých.** Questgiveri, vendori, cestovatelia. Neútočí nikdy. |
| 85 | Orgrimmar (guard) | 5 / 4 / 10 – Horde + hráč, friendly Horde, hostile Aliancia + Monster | **Horda – stráž.** Orgrimmar Grunt, Road Grunt, Night Watch. Aliancia ho vidí červeného, Horda zeleného. |
| 29 | Orgrimmar (civilian) | 4 / 4 / 2 – Horde, friendly Horde, hostile Aliancia | **Horda – civilista.** Citizen, Laborer, Villager, Settler. Neaggrí, ale Aliancia ho vidí červeného. |
| 126 | Darkspear Trolls | 4 / 4 / 2 | **Horda – Darkspear trollovia.** Valley of Spirits, Sen’jin. Wowhead: https://www.wowhead.com/faction=530/darkspear-trolls |
| 104 | Thunder Bluff | 4 / 4 / 2 | **Horda – taureni.** Mulgore Wanderer v Crossroads. Wowhead Tauren lore. |
| 14 | Monster (classic) | 8 / 0 / 1 | Starý „monster“ template, funkčne ako 16. |
| 7 | Creature | 0 / 0 / 0 | Neutrálne zviera / critter, neútočí. Použité vo faune. |

Reputačné frakcie (Wowhead Faction stránka) vs FactionTemplate:
- `Orgrimmar` – https://www.wowhead.com/faction=76/orgrimmar – Horda, hlavné mesto orkov.
- `Darkspear Trolls` – https://www.wowhead.com/classic/faction=530/darkspear-trolls – Horda, trollovia.
- `Thunder Bluff` – Horda, taureni.
- `Darnassus` – https://www.wowhead.com/faction=69/darnassus – Aliancia, noční elfovia. Naši Wardeni sú lore-ovo odtiaľ, ale mechanicky majú faction 35 (priateľskí ku všetkým, aby questy mohol robiť každý).
- `Wardens / Watchers` ako reputácia (Legion `Court of Farondis`-typ, `The Wardens` – https://www.wowhead.com/faction=1894/the-wardens) – to NIE JE náš `faction=16/35`. Naši Wardeni sú custom skupina „Watch of Velarys / Maiev“, nie retail rep. Preto v tabuľke píšem „Warden (lore) + Friendly / Monster (mechanika)“.

### 1.3 `map` – kontinent / svet

| map | Svet | Wowhead |
|---|---|---|
| 1 | Kalimdor | https://www.wowhead.com/zone=141/teldrassil (príklad zóny na mape 1) |
| 0 | Eastern Kingdoms | klasický východný kontinent |
| 530 | Outland | – |
| 571 | Northrend | – |
| 1481 | Mardum, the Shattered Abyss (Legion DH štart) | boss Urgoz 95287 |
| 169 | Emerald Dream / fázy – u nás len `PhaseId 169` = retail fáza, nie mapa |

Všetky naše spawny okrem jedného sú `map=1` = **Kalimdor**.

### 1.4 `zoneId / areaId` – zóna / podoblasť

| zone | Meno (Wowhead) | area príklady |
|---|---|---|
| 141 | Teldrassil – https://www.wowhead.com/zone=141/teldrassil | 186 Dolanaar (dedina, quest hub) |
| 331 | Ashenvale – https://www.wowhead.com/zone=331/ashenvale | 412 Thistlefur Den / Jadefire Run (brloh + satyri), 428 Satyrnaar (fel satyri) |
| 361 | Felwood – https://www.wowhead.com/zone=361/felwood | 1769 Felwood war-camp (Marauder) |
| 14 | Durotar | 362 Razor Hill, 367 Sen’jin Village |
| 17 | Northern Barrens | 380 Crossroads |
| 1637 | Orgrimmar (mesto, zone aj area) | 5169 Valley of Spirits? / Cleft of Shadow okolie (Fortuna, Kaelis, Juzan) |
| 7705 | Mardum (zone=area, map 1481) | boss Urgoz |

---

## 2. Sumár – koľko čoho máme

- **Celkom custom NPC templates: ~40** (21 Warden + 1 Fortuna + 1 Kaelis + 1 Juzan + ~16 Living World / systém).
- Podľa `type`:
  - **Humanoid (7): ~34** – všetci Wardeni, všetci Horda civilisti, stráže, vendori, cestovatelia, challenge/manastorm keeperi.
  - **Demon (3): 2** – 95140 Felbound Hound (type 3), 95218 Fel Lasher (type 3) – pozor, Hound je pes ale DB typ Demon (fel corrupt), Lasher je rastlina ale Demon (fel).
  - **Beast (1): 1** – 95215 Felwing Terror (type 1, netopier).
  - Ostatné: fauna spawny (retail critters type 8 + peaceful beasts type 1, ~6270 spawnov, nie nové templaty).
- Podľa `faction` (komu patrí):
  - **Monster 16 – nepriateľ všetkých: 14** (6 Dolanaar/Ashenvale renegáti + 2 Ch3 + 1 boss Sarthis + 4 Ch5 fel + 2 Ch6 bossovia).
  - **Friendly 35 – priateľ všetkých: ~13** (Velarys, Kaelis, Juzan, Fortuna, Maiev, Hero Master, Caravan 3x, Patrol 2x, Mystic/Hero/Bounty 3x, Challenge, Manastorm, 3 cestovatelia).
  - **Horda guard 85: 2** (9900115 Road Grunt, 9900116 Night Watch).
  - **Horda civil 29: 3** (9900120 Citizen, 9900122 Laborer, 9900123 Razor Hill Villager, 9900124 Settler – teda 4 s 29).
  - **Horda Darkspear 126: 1** (9900121 Villager).
  - **Horda Thunder Bluff 104: 1** (9900125 Mulgore Wanderer).
- Podľa kontinentu:
  - **Kalimdor (map 1): všetko okrem 1** – Teldrassil, Ashenvale, Felwood, Durotar, Barrens, Orgrimmar.
  - **Mardum (map 1481): 1** – 95287 Urgoz.
  - Cestovatelia 9900135-137 behajú po cestách Kalimdoru (Living World v4), spawn dynamický cez Lua.

---

## 3. Skupina A – Warden kampaň – priatelia (faction 35 Friendly, type 7 Humanoid)

Všetci `map=1`, `type=7 Humanoid`, `faction=35` (zelení pre Hordu aj Alianciu, aby kampaň bola testovateľná).
Lore: noční elfovia, „Watch“ – Wardenky Maiev Shadowsong. Mechanicky NIE Darnassus faction, ale Friendly.

| entry | Meno – subname | Kde (zone/area) | Kto je kto | Wowhead vzor |
|---|---|---|---|---|
| 95113 | **Warden Velarys – Watcher of Dolanaar** | Teldrassil 141 / Dolanaar 186, 9799,984 – pri hostinci, guid 3001000735 | Hlavná questgiverka celej kampane (17 questov 95000-95016, len Night Elf). Lore: veliteľka stráže v Dolanaare. Model 20628 (Warden). npcflag 3 (gossip+quest). | Zóna: https://www.wowhead.com/zone=141/teldrassil – Dolanaar. Model Warden archetyp. |
| 96112 | **Maiev Shadowsong – Warden of the Watch** | Teldrassil 141 / Dolanaar 186, vedľa Velarys, guid 3001000799 | Cameo – legendárna vodkyňa Wardeniek, príde len na finále 95010. Silent witness, npcflag 0. Model 21349 (Maiev). | Lore: https://www.wowhead.com/npc=54959/maiev-shadowsong (retail Maiev – referenčná). |
| 95104 | **Warden Kaelis – Warden Armory** | Orgrimmar 1637 / 5169, 1437,-4421, guid 3001000733 | Vendor (pôvodne questgiver, teraz npcflag 129 gossip+vendor). „Naša“ Wardenka v Hordom hlavnom meste – lore break pre test, mechanicky Friendly. Model 63393. | Mesto: Orgrimmar. Pôvodne wildcard_pack.sql. |
| 95106 | **Keeper Juzan – Hall of Legends** | Orgrimmar 1637 / 5169, vedľa Kaelis, guid 3001000734 | Vendor Hall of Legends (legends_armory.sql). Neutral helper. Model 19780. | – |
| 95000 | **Fortuna Fatecaller – Dice of Destiny** | Orgrimmar 1637 / 5169, guid 3001000732 | Gossip / dice UI test NPC (wildcard_pack.sql). Nie questová, len draft UI. Model 21020. faction 35, type 7. | – |
| 95257 | Phase Test Watcher | prototyp fázy 9511 | Technický NPC na test fázy, nie lore. | – |

Spoločné: `Classification 0` (normal), `npcflag` 1/3/129 (gossip/quest/vendor), `scale 1`.

---

## 4. Skupina B – Warden kampaň – nepriatelia (faction 16 Monster, hostile všetkým)

Všetci `faction=16` (červení pre každého), väčšina `type=7 Humanoid` (zradné Wardenky),
výnimky: Hound/Lasher type 3 Demon, Terror type 1 Beast.
`Classification 0` normal, bossovia 1 elite (Sarthis, Urgoz, Overfiend).
Spawny guid 3001000736-3001000825, respawn 40s (warden_density.sql).

### 4.1 Dolanaar – Teldrassil 141 / 186 (Ch.1)

| entry | Meno – subname | Type / Faction | Kto je kto + Wowhead |
|---|---|---|---|
| 95114 | **Felsong Renegade (pôvodne Duskwatch Renegade) – Fel-corrupted Warden / Oathbreaker of the Watch** | 7 Humanoid / 16 Monster | 8+4 spawny okolo Dolanaaru (10600,633…). Quest 95000 (6 kill). Model 66480 = Cordana Felsong (fel-corrupted warden) – pozri warden_felsong.sql. Lore: vlastné Wardenky čo pili fel z črepu. |
| 95115 | **Shadowfen Betrayer – Oathbreaker** | 7 / 16 | 8 spawny južné húštiny (10531,1065…). Quest 95001 (8 kill, odmena Shadowstep). Model 21349 (Maiev basic). |
| 95116 | **Talonbreaker Renegade – Oathbreaker** | 7 / 16 | 8+4 spawny divočina + Strigid grounds (10426,546 + 9717,1852). Quest 95002 (8 kill, odmena Evasion). Model 63393. |

### 4.2 Ashenvale – 331 / 412 Thistlefur Den + Jadefire Run (Ch.2-3)

| entry | Meno | Type / Faction | Kde + quest |
|---|---|---|---|
| 95124 | **Ashenfall Betrayer – Satyr-Sworn Turncloak** | 7 / 16 | Den 3439,-365… Quest 95003 (8 kill). Model 20628. Lore: renegátky čo sa skrývajú medzi Thistlefur furbolgami, predávajú hliadky satyrom. |
| 95125 | **Pineshadow Turncloak – Satyr-Sworn** | 7 / 16 | Presunutý z Denu do Jadefire Run (density move) – go-between so satyrmi. Quest 95004 (8 kill, Cloak of Shadows). Model 21349. |
| 95126 | **Felbriar Warden – Satyr-Sworn** | 7 / 16 | Den 3445,-360… Quest 95005 (10 kill, Fel Rush). Model 63393 (1.05 scale). |
| 95127 | **Duskwarden Turncoat – Satyr-Sworn Turncloak** | 7 / 16 | Jadefire Run 3750,-870… x6. Quest 95006 (8 kill, Throw Glaive 185123). Model 20628. Ch.3. |
| 95128 | **Felsworn Warden – Satyr-Sworn** | 7 / 16 | Den 3442,-363… x6 + quest 95009 (10 kill, Darkness 196718). Model 21349. Ch.3-4. |
| 95129 | **High Betrayer Sarthis – Voice of the Dreadlord** | 7 / 16, **Classification 1 elite, scale 1.15** | Boss Thistlefur Den 3439,-365, guid 3001000798. Quest 95010 FINÁLE Ch.4 (Ashadar mount 366962 + titul Vengeance Incarnate 342). Model 63393. Lore: kedysi Warden Západnej stráže, teraz hlas dreadlorda. |

Wowhead zóna pre všetky: https://www.wowhead.com/zone=331/ashenvale – Thistlefur Den / Jadefire Run / Satyrnaar sú satyr + furbolg huby (retail Thistlefur Warrior 33390, Jadefire Satyr 7105 – pôvodné objektívy pred retargetom na custom).

### 4.3 Fel hunt – Satyrnaar / Jadefire / Felwood (Ch.5) + finále (Ch.6)

| entry | Meno – subname | Type / Faction | Kde (map/zone/area) + quest |
|---|---|---|---|
| 95140 | **Felbound Hound – Hound of Satyrnaar** | **3 Demon** / 16 | Ashenvale 331 / 428 Satyrnaar, 2619,-2116 x6. Quest 95011 (8 kill). Model 1913 (felhound). Jediný „pes“ ale DB Demon – fel corrupt. |
| 95215 | **Felwing Terror – Terror of the Pines** | **1 Beast** / 16 | Satyrnaar 331/428 vzduch 210z, wander 8. Quest 95012. Model 65307 (felbat). Jediný Beast v kampani. |
| 95218 | **Fel Lasher – Rooted in Fel** | **3 Demon** / 16, Movement 0 (korene, nechodí) | Jadefire Run 331/412, 3746,-877 x6. Quest 95013. Model 79783 (lasher, 1.2 scale). |
| 95252 | **Felsworn Marauder – Marauder of Felwood** | 7 Humanoid / 16 | Felwood 361 / 1769, 6923,-2274 + 7372,-2205 x6. Quest 95014. Model 62676. Prvý NPC mimo Teldrassil/Ashenvale – expanzia do Felwoodu. Zóna: https://www.wowhead.com/zone=361/felwood |
| 95287 | **Fel Commander Urgoz – Commander of the Mardum Remnant** | 7 / 16, **elite 1, scale 1.1, HP mod 5.0** | **Mardum map 1481 / zone 7705**, 1184,3232, guid 3001000824. Quest 95015 (1 kill). Model 18526 (felguard commander). Jediný NPC mimo Kalimdoru – Legion DH planéta. |
| 95293 | **Felborne Overfiend – Terror of Jadefire** | 7 / 16, **elite 1, scale 1.2, HP mod 8.0** | Ashenvale 331 / 412, 3820,-730, guid 3001000825. Quest 95016 FINÁLE (titul Demonslayer 367). Model 61981 (overfiend). |

---

## 5. Skupina C – Living World – Horda (Durotar / Barrens / Orgrimmar)

Všetci `map=1 Kalimdor`, `type=7 Humanoid`, `npcflag=1` (gossip), kopie retail šablón (Wowhead vzory).
Fáza 9600 Living World Main Phase. Spawny guid 3001000901-3001001004.

| entry | Meno (kópia retail entry) | Faction – komu patrí | Kde | Kto je kto + Wowhead |
|---|---|---|---|---|
| 9900115 | **Durotar Road Grunt** (kópia 5953 Razor Hill Grunt) | **85 Orgrimmar guard – Horda stráž** | Orgrimmar–Razor Hill cesta (lw_patrol route 1, 31 bodov) | Cestná hliadka. Wowhead vzor: https://www.wowhead.com/npc=5953/razor-hill-grunt – „found in Durotar“, Faction Orgrimmar, Type Humanoid. |
| 9900116 | **Orgrimmar Night Watch** (kópia 3296 Orgrimmar Grunt) | **85 – Horda stráž** | Nočný okruh Orgrimmarom (route 2, 27 bodov) | Nočná stráž. Vzor: https://www.wowhead.com/npc=3296/orgrimmar-grunt – React AH (Alliance hostile, Horde friendly), Type Humanoid, Faction Orgrimmar. |
| 9900120 | **Orgrimmar Citizen** (kópia 156508, 23 vzhľadov) | **29 Orgrimmar civilian – Horda civil** | Orgrimmar 1637, 24 spawnov posunutých od gossip NPC | Obyvateľ mesta, nakupuje / spí v hostinci (lw_town.lua). |
| 9900121 | **Darkspear Villager** (kópia 152294) | **126 Darkspear – Horda troll** | Orgrimmar Valley of Spirits 8x + Razor Hill 3x + Sen’jin 9x | Troll civil. Faction Darkspear = Horda. |
| 9900122 | **Orgrimmar Laborer – peon** (kópia 85203) | **29 – Horda civil** | Orgrimmar 8x + Razor Hill 4x + Crossroads 2x + Sen’jin 2x | Robotník/peon. |
| 9900123 | **Razor Hill Villager** (kópia 152293 Orc Commoner) | **29 – Horda civil** | Durotar 14 / Razor Hill 362, 10x, guid 3001000964-980 | Dedinský civil. Vzor: https://www.wowhead.com/npc=152293/orc-commoner – Orc (Humanoid), Orgrimmar. |
| 9900124 | **Crossroads Settler** (kópia 152293) | **29 – Horda civil** | Barrens 17 / Crossroads 380, 8x, guid 3001000992-1004 | Osadník. Rovnaký vzor ako vyššie. |
| 9900125 | **Mulgore Wanderer – tauren** (kópia 19176 Tauren Commoner) | **104 Thunder Bluff – Horda tauren** | Crossroads 3x | Tauren cestovateľ. Vzor Tauren Commoner – Type Humanoid, Faction Thunder Bluff (Horda). |
| 9900135 | **Wandering Merchant – Traveler** (kópia 190399) | **35 Friendly – neutrál všetkých** | Cesty Kalimdoru (living_world4.lua, dynamický) | Cestujúci obchodník. Neutrál aby ho nikto nezabil. |
| 9900136 | **Pilgrim of the Light – Traveler** (kópia 33624) | **35 – neutrál** | Cesty | Pútnik. |
| 9900137 | **Wandering Adventurer – Traveler** (kópia 9900120) | **35 – neutrál** | Cesty | Dobrodruh. |

Vysvetlenie 85 vs 29 vs 126 vs 104: všetko **Horda**, rozdiel je len agresivita (85 = stráž útočí na Alianciu, 29/126/104 = civil neútočí) a reputačná podfrakcia (Orgrimmar orkovia / Darkspear trollovia / Thunder Bluff taureni). Podľa Wowhead Factions: Orgrimmar = https://www.wowhead.com/faction=76/orgrimmar, Darkspear = Horde, Thunder Bluff = Horde.

---

## 6. Skupina D – Systémoví / služobní (všetci faction 35 Friendly, type 7 Humanoid, Kalimdor)

| entry | Meno | Kde | Úloha |
|---|---|---|---|
| 9900100 | Hero Master Arvenne – Hero Paths | Orgrimmar, guid 3001000900 | Výber Hero cesty (Fel Warden / Archmage / Templar). Model 20628. |
| 9900110 | Caravan Master Grukk | Cesty route 100+ (living_roads.sql) | Karavána Orgrimmar–Razor Hill–Sen’jin–Crossroads. |
| 9900111 | Caravan Kodo (vozidlo 419) | Cesty | Nákladný kodo karavány. Jediný „mount/vehicle“ NPC. |
| 9900112 | Caravan Guard | Cesty | Ochrana karavány. |
| 9900113 | Patrol Sergeant | Durotar hliadky (lw_patrol) | Denná hliadka. |
| 9900114 | Night Watch Captain | Orgrimmar noc | Nočná hliadka. |
| 9900130 | Mystic Enchanter | Hostince hlavných miest (mystic_altars.sql, guid 3002100001+) | Mystic Enchanty. |
| 9900131 | Hero Trainer | Hostince | Classless & Wildcard tréning. |
| 9900132 | Bounty Master | Hostince | Bounty / ascension. |
| 9900133 | Challenge Master | 25 spawnov (challenges.sql, guid 3002200001+) | Challenges, tituly 1400-1406. |
| 9900134 | Manastorm Keeper | GM Island + zóny (manastorm.sql, guid 3002300001+) | Manastorm eventy, kúzla 1402000+. |

Všetci zámerne `faction 35`, aby ich žiadny hráč (Horda/Aliancia) nemohol omylom aggrovať a rozbiť systém.

---

## 7. Skupina E – Ostatné (retail reuse, nie nové templaty)

- **Spirit Healers (entry 6491, retail):** 736 spawnov guid 3002000001-736 pri cintorínoch bez healera (spirit_healers.sql). `Type 7 Humanoid? / Faction – neutrál (Angel).` Wowhead: Spirit Healer – neutrálny anjel, kontinent: všetky (Eastern Kingdoms + Kalimdor + Outland + Northrend – 355 graveyard_zone riadkov).
- **Fauna (retail entry reuse, fauna.sql):** 6270 spawnov guid 3002500001+ v 130 zónach. Druhy brané zo zóny samotnej – napr. Elwynn: 14881, 890, 47194…; Durotar/Barrens orkovia vlci/kanci atď. `Type 8 Critter` (králiky, hady) + `Type 1 Beast` (mierumilovné vlky, medvede). `Faction 7 Creature / 35 Friendly` – neútočia. Kontinent: **oba – map 0 Eastern Kingdoms aj map 1 Kalimdor** (jediná skupina čo je na oboch).
- **Pre-existing custom (nie naše, len info):** 95584 Marin Bladewing, spelly 1900000-1900002 – bolo pred nami, nemeniť.

---

## 8. Odpovede na otázky „kto je kto / komu patrí“

1. **Je to Humanoid, Creature, Beast…?** – 95% našich NPC je **Humanoid (7)** – elf/orc/troll/tauren. Výnimky: Hound/Lasher = Demon (3), Terror = Beast (1), fauna critters = Critter (8). Wowhead „Type“ stĺpec.
2. **Je to Horda alebo Aliancia alebo niečo iné?** – Mechanicky: **Monster (16) = nepriateľ všetkých, Friendly (35) = priateľ všetkých, 85/29/126/104 = Horda** (stráž/civil/Darkspear/Thunder Bluff). **Aliancia (Darnassus/Stormwind faction) nemá žiadne custom NPC** – naši „Alianční“ elfovia (Wardeni) sú zámerne Friendly, aby fungovali pre každého testera.
3. **Je to Warden alebo niečo iné?** – **Warden (lore) = 12 NPC**: Velarys, Kaelis, Juzan, Maiev + 8 renegátov/zradcov (95114-16, 95124-28) + boss Sarthis. Ostatní Wardeni-lore bossovia (Urgoz, Overfiend) sú už **fel/démon**, nie Wardeni. Zvyšok sú **Horda civilisti/stráže** (Living World) a **systémoví neutráli**.
4. **Komu patrí – ktorý kontinent – ktorá oblasť?**
   - **Teldrassil 141 / Dolanaar 186 (Kalimdor)** – Velarys, Maiev, 3 renegátske bandy (Ch.1).
   - **Ashenvale 331 / Thistlefur Den + Jadefire Run 412 + Satyrnaar 428 (Kalimdor)** – 8 fel/zradca NPC + 2 bossovia (Ch.2-3, Ch.5-6).
   - **Felwood 361 / 1769 (Kalimdor)** – Marauder (Ch.5).
   - **Mardum 1481 / 7705 (mimo Kalimdoru)** – Urgoz (Ch.6).
   - **Orgrimmar 1637 + Durotar 14 (Razor Hill 362, Sen’jin 367) + Barrens 17 (Crossroads 380) (Kalimdor)** – celá Living World Horda + Fortuna/Kaelis/Juzan/Hero Master.
   - **Všade (fauna + spirit healers)** – retail reuse.

---

## 9. Zdroje – Wowhead (overené)

- NPC vzory: https://www.wowhead.com/npc=5953/razor-hill-grunt, https://www.wowhead.com/npc=3296/orgrimmar-grunt, https://www.wowhead.com/npc=152293/orc-commoner, https://www.wowhead.com/npc=19176/tauren-commoner (lore: Orc/Tauren Commoner = Humanoid, Orgrimmar/Thunder Bluff, Horde).
- Zóny: https://www.wowhead.com/zone=141/teldrassil, https://www.wowhead.com/zone=331/ashenvale, https://www.wowhead.com/zone=361/felwood.
- Frakcie: https://www.wowhead.com/faction=76/orgrimmar, https://www.wowhead.com/faction=530/darkspear-trolls (Darkspear Trolls – Horde), The Wardens (Legion rep – https://www.wowhead.com/faction=1894/the-wardens – len lore referenica, nie náš faction template).
- DB význam: https://trinitycore.info/en/database/335/world/creature_template (`type`), https://www.azerothcore.org/wiki/factiontemplate (`faction` 16/35/85/29/126/104).
- Maiev referenica: https://www.wowhead.com/npc=54959/maiev-shadowsong.

Interné: `Custom/REGISTRY.md` (zoznam entry), `Custom/sql/warden_*.sql`, `lw_npcs.sql`, `lw_razorhill.sql`, `lw_crossroads.sql`, `lw_senjin.sql`, `living_world4.sql`, `wildcard_pack.sql`, `legends_armory.sql`, `hero_class.sql`, `mystic_altars.sql`, `challenges.sql`, `manastorm.sql`, `fauna.sql`, `spirit_healers.sql`.
