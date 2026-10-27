# CELÁ ANALÝZA LEN Z WOWHEADU – plné tooltip texty

Zdroj LEN `nether.wowhead.com/tooltip/{npc,spell,item,zone}/ID` (oficiálne Wowhead tooltip API)
+ `wowhead.com/{npc,spell,item,zone,faction}=ID` linky. Priamy HTML fetch vracia 403,
tooltip API ide – nižšie sú DOSLOVNÉ texty z Wowheadu, HTML očistené, nič nevymyslené.
Custom 95xxx/99xxx/97xxxxx/140xxxx na Wowheade neexistujú – sú tu ich retail vzory.

Surový dump: `Custom/docs/wowhead_raw.txt`.

---

## 1. NPC – či je Humanoid / Creature / Beast / Demon + faction + zóna (doslovný Wowhead tooltip)

Formát: `Meno | Level Typ (Rank) | Faction skupina | zoneID`.

- **5953 – [Razor Hill Grunt](https://www.wowhead.com/classic/npc=5953/razor-hill-grunt)**
  `Razor Hill Grunt | Humanoid (Normal) | Orgrimmar | zone=14`
  = Humanoid, Horda (Orgrimmar), kontinent Kalimdor, oblasť Durotar.
- **3296 – [Orgrimmar Grunt](https://www.wowhead.com/npc=3296/orgrimmar-grunt)**
  `Orgrimmar Grunt | Level 90 Humanoid (Normal) | Orgrimmar | zone=1637`
  = Humanoid, Horda, mesto Orgrimmar.
- **152293 – [Orc Commoner](https://www.wowhead.com/npc=152293/orc-commoner)**
  `Orc Commoner | Humanoid (Normal) | (bez faction) | zone=10492`
  = Humanoid (ork civil), neutrál.
- **152294 – [Troll Commoner](https://www.wowhead.com/npc=152294)**
  `Troll Commoner | Humanoid (Normal) | zone=`
  = Humanoid (troll civil). Wowhead faction prázdna – lore Darkspear Horda.
- **85203 – [Peon](https://www.wowhead.com/npc=85203/peon)**
  `Peon | Humanoid (Normal) | Orgrimmar`
  = Humanoid, Horda.
- **156508 – [Orgrimmar Citizen](https://www.wowhead.com/npc=156508)**
  `Orgrimmar Citizen | Humanoid (Normal) | zone=11402`
  = Humanoid civil, Horda mesto.
- **19176 – [Tauren Commoner](https://www.wowhead.com/npc=19176/tauren-commoner)**
  `Tauren Commoner | Humanoid (Normal) | Thunder Bluff | zone=1637`
  = Humanoid, Horda (Thunder Bluff taureni), Orgrimmar.
- **190399 – [Bounty Hunter](https://www.wowhead.com/npc=190399)**
  `Bounty Hunter | Cartel Ta Humanoid (Elite)`
  = Humanoid Elite (Steamwheedle Cartel – neutrálna goblin kartel).
- **33624 – [Archmage Pentarus](https://www.wowhead.com/npc=33624)**
  `Archmage Pentarus | Humanoid (Elite) | Kirin Tor | zone=4273`
  = Humanoid Elite, neutrál (Dalaran mágovia).
- **33390 – [Thistlefur Warrior](https://www.wowhead.com/npc=33390/thistlefur-warrior)**
  `Thistlefur Warrior | Level 30 Humanoid (Normal) | zone=331`
  = Humanoid furbolg, Ashenvale.
- **7105 – [Jadefire Satyr](https://www.wowhead.com/npc=7105/jadefire-satyr)**
  `Jadefire Satyr | Level 30-44 Demon (Normal) | Demon | zone=361`
  = Demon (nie Humanoid!), Felwood.
- **3925 – [Thistlefur Avenger](https://www.wowhead.com/npc=3925/thistlefur-avenger)**
  `Thistlefur Avenger | Level 20-34 Humanoid (Normal) | zone=331`
  = Humanoid furbolg, Ashenvale.
- **1989 – [Grellkin](https://www.wowhead.com/npc=1989/grellkin)**
  `Grellkin | Level 4-30 Demon (Normal) | Demon | zone=6450`
  = Demon (nie Beast!), Shadowglen.
- **2022 – [Timberling](https://www.wowhead.com/npc=2022/timberling)**
  `Timberling | Level 6-30 Elemental (Normal) | Elemental | zone=141`
  = Elemental (nie Humanoid!), Teldrassil.
- **1996 – [Strigid Screecher](https://www.wowhead.com/npc=1996/strigid-screecher)**
  `Strigid Screecher | Level 30 Beast (Normal) | Bird of Prey | zone=141`
  = Beast (sova), Teldrassil.
- **6491 – [Spirit Healer](https://www.wowhead.com/npc=6491/spirit-healer)**
  `Spirit Healer | Level 1-90 Humanoid (Normal) | Friendly`
  = Humanoid, priateľská všetkým, všetky zóny.
- **23197 – [Maiev Shadowsong](https://www.wowhead.com/npc=23197/maiev-shadowsong) (referencia, naše 96112)**
  `Maiev Shadowsong | Humanoid (Elite) | Friendly`
  = Humanoid Elite, Warden lore.
- **35595 – [Archmage Selwyn](https://www.wowhead.com/npc=35595) (vzor Keepera)**
  `Archmage Selwyn Mennar Academy | Level 30 Humanoid (Elite)`
  = Humanoid Elite mág.
- **34261 – [Caravan Peon](https://www.wowhead.com/npc=34261)**
  `Caravan Peon | Humanoid (Normal) | zone=17`
  = Humanoid, Barrens.

Zhrnutie podľa Wowheadu: naši Horda civili/stráže = **všetci Humanoid** (Orgrimmar/Thunder Bluff),
pôvodní Teldrassil/Ashenvale mobi = **Demon (Grellkin, Satyr), Elemental (Timberling), Beast (Strigid),
Humanoid (furbolg)**. Presne preto sú naši custom renegáti všade Humanoid – sú to elfky, nie beštie.

---

## 2. Zóny – komu patrí, ktorý kontinent (doslovný Wowhead tooltip)

- **141 – [Teldrassil](https://www.wowhead.com/zone=141/teldrassil)**
  `Teldrassil | Level 1-30 | Type: Zone | Territory: Alliance`
- **331 – [Ashenvale](https://www.wowhead.com/zone=331/ashenvale)**
  `Ashenvale | Level 7-30 | Type: Zone | Territory: Contested`
- **361 – [Felwood](https://www.wowhead.com/zone=361/felwood)**
  `Felwood | Level 15-30 | Type: Zone | Territory: Contested`
- **14 – [Durotar](https://www.wowhead.com/zone=14/durotar)**
  `Durotar | Level 1-30 | Type: Zone | Territory: Horde`
- **17 – [Northern Barrens](https://www.wowhead.com/zone=17/northern-barrens)**
  `Northern Barrens | Level 5-30 | Type: Zone | Territory: Horde`
- **1637 – [Orgrimmar](https://www.wowhead.com/zone=1637/orgrimmar)**
  `Orgrimmar | Level 1-90 | Type: City | Territory: Horde | Location: Durotar`

Všetko Kalimdor (map 1). Teldrassil = Alliance, Durotar/Barrens/Orgrimmar = Horde,
Ashenvale/Felwood = Contested (preto sa tam bojuje).

Frakcie (Wowhead Faction stránka, tooltip API vracia 404 – len linky):
[Orgrimmar 76](https://www.wowhead.com/faction=76/orgrimmar) – Horde.
[Darkspear Trolls 530](https://www.wowhead.com/faction=530/darkspear-trolls) – Horde.
[Darnassus 69](https://www.wowhead.com/faction=69/darnassus) – Alliance.
[The Wardens 1894](https://www.wowhead.com/faction=1894/the-wardens) – Legion night-elf wardeni Maiev.

---

## 3. Spelly – plné Wowhead texty (doslovné)

- **36554 – [Shadowstep](https://www.wowhead.com/spell=36554/shadowstep)**
  `Shadowstep | 25 yd range | Instant | 30 sec cooldown | Requires Rogue | Requires level 11 | Step through the shadows to appear behind your target and gain 70% increased movement speed for 2 sec. [Subtlety: If you already know Shadowstep, instead gain 1 additional charge of Shadowstep] | Buff: Movement speed increased by 70%. 2 seconds remaining`
- **5277 – [Evasion](https://www.wowhead.com/spell=5277/evasion)**
  `Evasion | Talent | Instant | 2 min cooldown | Requires Rogue | Increases your dodge chance by 100% for 10 sec. | Buff: Dodge chance increased by 100%. 10 seconds remaining`
- **31224 – [Cloak of Shadows](https://www.wowhead.com/spell=31224/cloak-of-shadows)**
  `Cloak of Shadows | Talent | Instant | 2 min cooldown | Requires Rogue | Provides a moment of magic immunity, instantly removing all harmful spell effects. The cloak lingers, causing you to resist harmful spells for 5 sec. | Buff: Resisting all harmful spells. 5 seconds remaining`
- **195072 – [Fel Rush](https://www.wowhead.com/spell=195072/fel-rush)**
  `Fel Rush | Instant | 10 sec cooldown | 1 Charge | Requires Demon Hunter | Rush forward, incinerating anything in your path for (43.4673% of Attack Power) Chaos damage.`
- **185123 – [Throw Glaive](https://www.wowhead.com/spell=185123/throw-glaive)**
  `Throw Glaive | 25 Fury | 30 yd range | Instant | 9 sec cooldown | 1 Charge | Requires Demon Hunter | Requires level 12 | Throw a demonic glaive at the target, dealing (49.2352% of Attack Power) Physical damage. The glaive can ricochet to [Bouncing Glaives: 1 additional enemies] within 10 yards.`
- **198793 – [Vengeful Retreat](https://www.wowhead.com/spell=198793/vengeful-retreat)**
  `Vengeful Retreat | Talent | Instant | 25 sec cooldown | 1 Charge | Requires Demon Hunter | Remove all snares and vault away. Nearby enemies take (16% of Attack Power) Physical damage [Vengeful Bonds: and have their movement speed reduced by 70% for 3 sec].`
- **196718 – [Darkness](https://www.wowhead.com/spell=196718/darkness)**
  `Darkness | Talent | Instant | 5 min cooldown | Requires Demon Hunter | Summons darkness around you in an 8 yd radius, granting friendly targets a 15% chance to avoid all damage from an attack. Lasts 8 sec. Chance to avoid damage increased by 100% when not in a raid.`
- **366962 – [Ash'adar, Harbinger of Dawn](https://www.wowhead.com/spell=366962/ashadar-harbinger-of-dawn)**
  `Ash'adar, Harbinger of Dawn | 1.5 sec cast | Summons and dismisses this mount. "Kaldorei legends whisper of a relentless hunter prowling amongst the deepest shadows of Kalimdor, never sleeping. By the light of the sun or the moon, Ash'adar now hunts with you." Trading Post / Shop`
- **Sulfuras proc 21162 – [Fireball](https://www.wowhead.com/spell=21162/fireball)**
  `Fireball | Level 90 Item Effect | 45 Mana | 35 yd range | 2 sec cast | Requires Mage | Hurls a fiery ball that causes 1172 Fire damage and an additional 290 damage over 10 sec.`
- **Sulfuras proc 21142 – [Immolation](https://www.wowhead.com/spell=21142/immolation)**
  `Immolation | Level 90 Item Effect | Deals 19 Fire damage to anyone who strikes you with a melee attack.`

---

## 4. Itemy – plné Wowhead texty (doslovné)

- **17182 – [Sulfuras, Hand of Ragnaros](https://www.wowhead.com/item=17182/sulfuras-hand-of-ragnaros)**
  `Sulfuras, Hand of Ragnaros | Q5 Legendary | Item Level 38 | Binds when picked up | Unique | Two-Hand Mace | 19-25 Damage | Speed 3.60 (6.1 DPS) | +3 Strength +3 Stamina | +8 Fire Resistance | Durability 145/145 | Chance on hit: Hurls a fiery ball that causes 33 Fire damage and an additional 8 damage over 10 sec. | Equip: Deals 1 Fire damage to anyone who strikes you with a melee attack. | Requires Level 30 | Sell Price: 4g 45s 23c`
- **32837 – [Warglaive of Azzinoth MH](https://www.wowhead.com/item=32837/warglaive-of-azzinoth)**
  `Warglaive of Azzinoth | Q5 Legendary | Item Level 42 | Binds when picked up | Unique | Main Hand Sword | 9-16 Damage | Speed 2.60 (4.8 DPS) | +4 Agility +8 Stamina +5 Critical Strike | Durability 130/130 | Classes: Warrior, Rogue, Death Knight, Monk, Demon Hunter | Requires Level 30 | The Twin Blades of Azzinoth (0/2) | Set: melee attacks have a chance to increase haste by 66 for 10 sec. (45s CD) | Set: +31 AP vs Demons | Dropped by: Illidan Stormrage 4.29% | Sell: 5g 11s 64c`
- **32838 – [Warglaive of Azzinoth OH](https://www.wowhead.com/item=32838/warglaive-of-azzinoth)**
  `Warglaive of Azzinoth | Q5 Legendary | Item Level 42 | Binds when picked up | Unique | Off Hand Sword | 9-16 Damage | Speed 2.60 (4.8 DPS) | +4 Agility +8 Stamina +6 Critical Strike | Durability 130/130 | Classes: Warrior, Rogue, Death Knight, Monk, Demon Hunter | Requires Level 30 | Twin Blades set | Dropped by: Illidan Stormrage 4.22% | Sell: 5g 13s 45c`
- **203431 – [Ensemble: Burden](https://www.wowhead.com/item=203431/ensemble-burden-of-unrelenting-justice)**
  `Ensemble: Burden of Unrelenting Justice | Q3 Rare | Item Level 1 | Binds to Warband | Use: Collect the appearances of the Burden of Unrelenting Justice.`
- **190231 – [Ash'adar](https://www.wowhead.com/item=190231/ashadar-harbinger-of-dawn)**
  `Ash'adar, Harbinger of Dawn | Q4 Epic | Item Level 10 | Binds to Warband | Unique | Mount (Account-wide) | Use: Teaches you how to summon this mount. | Requires level 1-90 (90) | Requires Apprentice Riding | Sell: 1c | "Kaldorei legends whisper..." | Trading Post cost: 900 Trader's Tender`

---

## 5. Zhrnutie len z Wowheadu

- Humanoid = ork/troll/tauren/človek/elf/furbolg (Grunt, Commoner, Peon, Citizen, Warrior, Avenger, Healer, Maiev).
- Demon = satyr, grellkin (Jadefire Satyr, Grellkin).
- Elemental = Timberling. Beast = Strigid Screecher.
- Faction: Orgrimmar / Thunder Bluff = Horda, Friendly = všetci, Demon/Elemental = monster.
- Zóny: Teldrassil Alliance, Durotar/Barrens/Orgrimmar Horde, Ashenvale/Felwood Contested – všetko Kalimdor.
- Spelly: Rogue (Shadowstep/Evasion/Cloak) + DH (Fel Rush/Throw Glaive/Retreat/Darkness) + mount Ashadar.
