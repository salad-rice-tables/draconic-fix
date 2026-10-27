# VŠETKO – kompletný audit custom obsahu (Wowhead metodika)

Vstup: `Custom/sql` (105 súborov) + `Custom/lua` (41) + `Custom/docs` analýzy
(NPC, ITEM, SPELL, QUEST, OBJECT_SYSTEM) + `Custom/REGISTRY.md`.
Výstupné súbory: `NPC_analyza.md`, `ITEM_analyza.md`, `SPELL_analyza.md`,
`QUEST_analyza.md`, `OBJECT_SYSTEM_analyza.md`, tento `VSETKO_audit.md`.

---

## 1. Čísla – všetko na jednej strane

| Kategória | Počet | ID rozsahy |
|---|---|---|
| Custom NPC templaty | ~40 | 95000, 95104/06/13-14-15-16/24-29/40, 95215/18/52/57/87/93, 96112, 9900100/110-116/120-125/130-137, 9900299/0300+/0400+ |
| NPC spawny (custom guid) | ~700 + 6270 fauna + 736 healers | 3001000732-0826, 3001000900-1004, 3002000001-736, 3002100001+, 3002200001+, 3002300001+, 3002400001+, 3002500001+ |
| Questy | 17 (95000-95016 + 95017) | objektívy 955000-955017, giver 95113, ender 95113/96112 |
| Itemy custom | 4796 (1383 + 3399 + 14) | 9700001-383, 9720001-3399, 9730001/03/10-25 |
| Objekty (GO) | 805 scroll + 4782 loot + 3 systém | 9710001-805, 9700004-383/9720001-399, 9709997/98/99 |
| GO spawny | 4320 worldforge + 438 dvere + 3197 scroll miest | guid 3100000001-320, 3100200001-438 |
| Spelly custom | ~700 (28 talent + 629 mystic + 18 storm + 13 dice/potion + 10 CoA + 1 test + 1 aura) | 1400000/010/100-127/1000-1804/2000-2107/2301/2310-25/3000-11 |
| Retail reuse (pool) | 1134 class + 239 essence + 176 mystic + 9 odmien + 3 vendor | hero_class_spells, spell_power 9500xxx, npc_vendor 95106 |
| Fázy / cesty / počasie | 9600 + 9511 / 2 + 33 ciest / 19 zón | lw_main_phase, living_roads, lw_weather |
| Lua skriptov | 41 | wildcard, warden, lw_*, worldforge, manastorm, challenges… |
| SQL súborov | 105 (+ undo) | Custom/sql |

---

## 2. Komu patrí – frakcie (FactionTemplate, nie reputácia)

- **16 Monster (nepriateľ všetkých): 14 NPC** – renegáti, fel, bossovia (Kalimdor + Mardum).
- **35 Friendly (priateľ všetkých): ~25 NPC + všetky systémy** – Velarys, Maiev, vendori,
  karavány, trainery, keeperi, cestovatelia. Dôvod: testovateľnosť pre Hordu aj Alianciu.
- **Horda (85 stráž / 29 civil / 126 Darkspear / 104 Thunder Bluff): 8 NPC** –
  Durotar/Barrens/Orgrimmar civilisti a hliadky. Wowhead: Orgrimmar
  (https://www.wowhead.com/faction=76/orgrimmar), Darkspear, Thunder Bluff.
- **Aliancia: 0 custom NPC s Alliance faction** – elfovia (Warden/Darnassus lore –
  https://www.wowhead.com/faction=69/darnassus) sú mechanicky Friendly.
- **Itemy/spelly/questy/GO frakciu nemajú** – viažu sa cez NPC/zone/triedu/rasu
  (quest len Night Elf rasa 8, mystic via trieda, loot via zóna).

---

## 3. Kam patrí – kontinent / zóna (map / zoneId)

- **Kalimdor (map 1): ~99%** – Teldrassil 141/Dolanaar 186, Ashenvale 331/Den 412/
  Satyrnaar 428, Felwood 361/1769, Durotar 14/Razor 362/Sen'jin 367,
  Barrens 17/Crossroads 380, Orgrimmar 1637.
- **Mardum (map 1481 / 7705): 1 NPC + 1 quest** – Urgoz 95287 / 95015.
- **Všetky mapy (0/1/530/571/…):** Worldforge World (362 zón + dungeony),
  Mystic scrolly (3197), Manastorm keeper, Room Door (438 hostincov),
  fauna (130 zón map 0+1), spirit healers (celý svet).
- **Eastern Kingdoms (map 0):** len fauna + Worldforge + scrolly/dvere (žiadny custom NPC).

---

## 4. Kto je kto – lore skupiny

- **Warden/Watch (noční elfovia, 12+3):** Velarys, Kaelis, Juzan, Maiev +
  8 renegátov + Sarthis + Urgoz/Overfiend (fel). Kampaň 17 questov,
  odmeny DH/rogue (Shadowstep, Evasion, Cloak, Fel Rush, Throw Glaive, Darkness,
  Ashadar mount, tituly 342/367). Zóny Teldrassil→Ashenvale→Felwood→Mardum.
- **Horda Living World (8+3):** grunti, watch, citizeni, villageri, laboreri,
  settleri, wanderer + cestovatelia. Fáza 9600, karavány/hliadky/cesty/počasie/
  ekonomika/izby. Durotar/Barrens/Orgrimmar.
- **Systém (13+):** Hero/Arvenne, Caravan/Kodo/Guard, Sergeant/Captain, Mystic/
  Trainer/Bounty, Challenge, Manastorm. Neutráli pre funkčnosť.
- **Loot/Enchant/Magic:** 4796 itemov (Atlas+World), 805 enchantov (629 custom),
  ~700 spellov, 1134 class pool, 239 essence pool. Všade, pre všetky triedy.

---

## 5. Wowhead zdroje (overené linky)

- NPC: /npc=5953 Razor Hill Grunt, /npc=3296 Orgrimmar Grunt, /npc=152293 Orc Commoner,
  /npc=54959 Maiev (referencia).
- Zóny: /zone=141 Teldrassil, /zone=331 Ashenvale, /zone=361 Felwood.
- Frakcie: /faction=76 Orgrimmar, /faction=530 Darkspear, /faction=69 Darnassus,
  /faction=1894 The Wardens (len lore).
- Spelly: /spell=36554 Shadowstep, /spell=31224 Cloak, /spell=195072 Fel Rush,
  /spell=185123 Throw Glaive, /spell=366962 Ashadar.
- Itemy: /item=17182 Sulfuras, /item=32837 Warglaive. Typy: ItemType wiki.
- DB význam: trinitycore.info creature_template (type), azerothcore.org factiontemplate.

---

## 6. Riziká / duplicity (rýchly audit)

- Fortuna 95000 = zároveň NPC entry aj quest ID 95000 – **kolízia v hlave, funkčne OK**
  (creature_template vs quest_template iná tabuľka), ale mätúce – zvážiť premenovanie.
- Kaelis 95104 npcflag 129 vs 131 história – ustrážiť aby undo nevrátilo quest flag.
- Pineshadow 95125 presun Den→Jadefire – POI musí sedieť (density.sql to rieši).
- Thunderfury 13550 chýba v DB – vendor skip je správne.
- 1900000-02 + 95584 nie naše – nesiahať.
- Všetky custom ID 95/97/99/140xxxx sú mimo retail rozsahu – bezpečné, add-only
  (výnimky: dedupe 10742, english_names 497, english_texts 1041 – majú undo + backup).
