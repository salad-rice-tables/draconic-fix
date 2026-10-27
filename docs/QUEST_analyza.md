# Analýza všetkých custom questov – podľa Wowheadu

Zdroj: `Custom/sql/warden_ch1-ch6.sql`, `warden_poi.sql`, `warden_taunts.sql`,
`20261003_phase_prototype.sql`. Giver/ender: Warden Velarys 95113 (Dolanaar),
finále Maiev 96112. Všetky `AllowableRaces 8` = len Night Elf, `QuestType 2`,
`Flags 540672`, `ScriptName SmartQuest`.

Legenda Wowhead: `QuestSortID` = zóna (141 Teldrassil, 331 Ashenvale, 361 Felwood,
1481 Mardum), `RewardSpell` = natívny spell, `RewardTitle` = titul, `ObjectID` v
`quest_objectives` = kill target entry, `quest_poi` (UiMap 57 Teldrassil, 63 Ashenvale,
77 Felwood) = mapa blob.

---

## 1. Sumár

| Kapitola | Questy | Zóna (Wowhead) | Odmeny (Wowhead spell) |
|---|---|---|---|
| Ch.1 The Release | 95000-95002 | Teldrassil 141 / Dolanaar 186 | – / 36554 Shadowstep / 5277 Evasion |
| Ch.2 Umbral Trials | 95003-95005 | Ashenvale 331 / Thistlefur Den 412 | – / 31224 Cloak of Shadows / 195072 Fel Rush |
| Ch.3 Hunt the Betrayers | 95006-95008 | Ashenvale 331 / Jadefire Run 412 | 185123 Throw Glaive / 203431 Burden ensemble / 198793 Vengeful Retreat |
| Ch.4 Avatar's Shadow | 95009-95010 | Ashenvale 331 / Den 412 | 196718 Darkness / 366962 Ashadar mount + titul 342 Vengeance Incarnate |
| Ch.5 Fel Hunt | 95011-95014 | Satyrnaar 428 / Jadefire 412 / Felwood 361/1769 | gold / XP (rozšírenie sveta, bez spell odmeny) |
| Ch.6 Commanders of Fel | 95015-95016 | Mardum 1481/7705 + Jadefire 412 | gold / titul 367 Demonslayer |
| Prototyp | 95017 | fáza 9511 | test fázy |

Celkom: **17 questov (95000-95016 + 95017 prototyp)**, objektívy 955000-955017,
reťaz `RewardNextQuest / PrevQuestID`: 95000→95001→…→95016 súvisle, Ch.1→Ch.2 link
`RewardNextQuest 95003` v 95002. Turn-in portrait: 95000-95008 Velarys, 95009-95010
Velarys→Maiev cameo, 95011-95016 Velarys.

---

## 2. Detail – kto, kde, koho zabiť (podľa Wowhead zón)

### Ch.1 (Dolanaar, Teldrassil – https://www.wowhead.com/zone=141/teldrassil)
- **95000 The Fel Within / Warden's Summons** – zabi 6x 95114 Felsong Renegade
  (lesy okolo Dolanaaru 10600,633). Text: Cordana Felsong lore, fel črep.
- **95001 First Trial of Shadows** – zabi 8x 95115 Shadowfen Betrayer (10531,1065).
  Odmena **36554 Shadowstep** (https://www.wowhead.com/spell=36554/shadowstep).
- **95002 Trial of the Talon / Resolve** – zabi 8x 95116 Talonbreaker Renegade
  (10426,546 + Strigid 9717,1852). Odmena **5277 Evasion**.

### Ch.2 (Ashenvale – https://www.wowhead.com/zone=331/ashenvale)
- **95003 Whispers in the Pines** – 8x 95124 Ashenfall Betrayer (Den 3439,-365).
  Pôvodne Thistlefur Warrior 33390, retarget na custom.
- **95004 The Unseen Blade** – 8x 95125 Pineshadow Turncloak (Jadefire Run, po
  relokácii z Denu). Odmena **31224 Cloak of Shadows**.
  Pôvodne Jadefire Satyr 7105.
- **95005 Ride the Wind** – 10x 95126 Felbriar Warden. Odmena **195072 Fel Rush**
  (https://www.wowhead.com/spell=195072/fel-rush). Pôvodne Thistlefur Avenger 3925.

### Ch.3 (Jadefire + Den)
- **95006 The Turncoat Trail** – 8x 95127 Duskwarden Turncoat (Jadefire 3750,-870).
  Odmena **185123 Throw Glaive** (https://www.wowhead.com/spell=185123/throw-glaive).
- **95007 Raiment of the Watch** – 8x 95128 Felsworn Warden. Odmena **203431 Burden** ensemble.
- **95008 (Vengeance prelude)** – dorážka Ch.3, odmena **198793 Vengeful Retreat**.

### Ch.4 (finále I – Sarthis)
- **95009 Whispers of the Dreadlord** – 10x 95128 Felsworn. Odmena **196718 Darkness**.
- **95010 The Avatar's Shadow** – 1x 95129 High Betrayer Sarthis (Den boss).
  Odmena **366962 Ash'adar, Harbinger of Dawn**
  (https://www.wowhead.com/spell=366962/ashadar-harbinger-of-dawn) + **titul 342**.

### Ch.5 (Fel Hunt – Satyrnaar / Felwood – https://www.wowhead.com/zone=361/felwood)
- **95011 Hounds of Satyrnaar** – 8x 95140 Felbound Hound (Satyrnaar 2619,-2116).
- **95012 (Felwing)** – 95215 Felwing Terror (vzduch 210z).
- **95013 (Lasher)** – 95218 Fel Lasher (Jadefire korene, Movement 0).
- **95014 (Marauder)** – 95252 Felsworn Marauder (Felwood 6923,-2274, UiMap 77).

### Ch.6 (finále II – velitelia)
- **95015 The Commander's Head** – 1x 95287 Fel Commander Urgoz
  (**Mardum map 1481 / 7705**, 1184,3232 – jediný quest mimo Kalimdoru).
- **95016 Fall of the Overfiend** – 1x 95293 Felborne Overfiend (Jadefire 3820,-730).
  Odmena **titul 367 Demonslayer**. Respawn 600s (world boss tempo).

---

## 3. Komu patrí / kontinent / frakcia

- Giver **vždy Velarys (Horda/Aliancia neutrál, faction 35)**, lokácia **Kalimdor**:
  Dolanaar (Teldrassil) → Ashenvale → Felwood → Mardum (Legion planéta).
- Frakcia questu: **len Night Elf (rasa 8)** – lore Warden/Watch, Aliancia pôvod
  (Darnassus – https://www.wowhead.com/faction=69/darnassus), mechanicky prístupné
  každému testerovi (giver Friendly).
- Kill targeti: **všetci faction 16 Monster** (červení pre Hordu aj Alianciu).
- POI: UiMap 57 (Teldrassil), 63 (Ashenvale), 77 (Felwood) – blob + per-kill body
  na presných spawnoch. `warden_poi.sql`, `warden_density.sql` (respawn 40s).
