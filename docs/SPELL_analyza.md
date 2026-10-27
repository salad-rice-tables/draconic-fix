# Analýza všetkých custom spellov – podľa Wowheadu

Zdroj: `Custom/REGISTRY.md` + `Custom/sql/hero_essence.sql`, `hero_talents.sql`,
`hero_class_spells.sql`, `mystic_enchants.sql`, `manastorm.sql`, `coa_spells.sql`,
`dice_item.sql`, `potions.sql`, `warden_ch1-ch6.sql`, `challenges.sql`, `ascension_extra.sql`.
Metodika Wowhead: `spell_name` (meno) + `spell` (popis/school) + `spell_misc`
(school/mana/cooldown/range) + `spell_effect` (čo robí) + `spell_power` (cena) +
trieda / talent / quest odmena / zóna.

> Custom ID 14xxxxx na Wowheade neexistujú. Wowhead odkazy vedú na retail spell,
> ktorého mechaniku kopírujú, alebo na Wowhead školu/triedu.

---

## 1. Legenda – ako čítať spell (Wowhead Spell Details)

- `SchoolMask`: 1 Physical, 2 Holy, 4 Fire, 8 Nature, 16 Frost, 32 Shadow, 64 Arcane, 124 Chaos (Fire+Shadow+Frost…).
- `Power`: mana / rage / energy / nový `Hero Essence` (UnitPowerBar 9990, max 100).
- `Effect`: 6 Apply Aura (pasívka), 3 Dummy / Trigger (on-use), 6+346 Enable Alt Power…
- Hotfix tabuľky: `spell_name`, `spell`, `spell_misc`, `spell_effect`, `spell_power`,
  `spell_cooldowns`, `spell_x_spell_visual`. Push ID: `hotfix_data.Id`
  (1900013 test, 1900100 essence, 1900110 talenty, 1900120/1900140 worldforge,
  1900130 mystic, 1900150 challenge, 1900160 manastorm, 1900170 collection,
  1900180 inn, 1900210 codex, 1900600 potions, 1900700 CoA).
- Trieda: custom pasívky sú „pre všetky triedy“ alebo viazané (`mystic_enchant.classes`,
  `hero_class_spells`, CoA kity). Quest odmeny sú retail DH/rogue spelly.

---

## 2. Sumár – koľko čoho máme

| Skupina | ID | Počet | Súbor / push |
|---|---|---|---|
| TEST | 1400000 Fel Glaive (Weak) | 1 | wildcard? push 1900013. Len test. |
| Hero Essence systém | 1400010 + bar 9990 + SpellPower pool | 1 aura + **239 schopností** (96 base + 143 v3, riadky 9500000+ + retail ID) | hero_essence.sql, push 1900100. Cena: Common 10, Uncommon 15, Rare 20, Epic 30 Essence. |
| Hero talenty (všeobecné pasívky) | 1400100-1400127 | **28 rankov = 10 talentov** | hero_talents.sql, push 1900110. `characters.hero_talents`. Essence 1/level od 10. |
| Hero class pool (čisté triedy) | `world.hero_class_spells` | **1134 triednych kúziel** | hero_class_spells.sql. Retail kúzla ako pool pre Classless/Wildcard. |
| Mystic Enchants | 1401000-1401804 custom + 176 retail | **629 custom pasívok + 176 retail = 805** | mystic_enchants.sql, push 1900130. `world.mystic_enchant` (id, name, spell, quality, classes), scrolly 9710001-805. |
| Manastorm | 1402000-09 mob empower + 1402100-07 player boon | **10 + 8 = 18** | manastorm.sql, push 1900160. `world.manastorm_pool`. |
| Dice / Codex / Potions / Elixíry | 1402301, 1402310-15, 1402320-25 | 1 + 6 + 6 = 13 | dice_item.sql (1900210), potions.sql (1900600). |
| CoA Pyromancer | 1403000-1403007, 1403010-11 | **10** | coa_spells.sql, push 1900700. Fire škola. |
| Warden quest odmeny (retail, nie custom) | 36554, 5277, 31224, 195072, 185123, 203431, 198793, 196718, 366962 + tituly 342/367 | 9 + 2 tituly | warden_ch1-ch6.sql. Natívne DH/rogue kúzla ako odmeny. |
| Challenge / Collection tituly | CharTitles 1400-08 (Mask 900-906) | 9 titulov | challenges.sql (1900150), ascension_extra.sql (1900170). Mounty 41252/230987. |
| Pre-existing (nie naše) | 1900000-1900002 | 3 | Flightswitch / Health Funnel – bolo pred nami. |

Celkom custom spellov: **~1 + 1 + 28 + 629 + 18 + 13 + 10 = ~700** (+ 1134 retail v poole + 239 v Essence poole + 9 retail odmien).

---

## 3. Skupina A – TEST + Essence (základ Hero systému)

| ID | Meno | Škola / efekt | Komu patrí / kde |
|---|---|---|---|
| 1400000 | TEST Fel Glaive (Weak) | Physical, dummy | Len testovacie (skupina 1900013). Nikomu, nikde. |
| 1400010 | Hero Essence (aura) | `EffectAura 346 ENABLE_ALT_POWER, Misc 9990` | Dáva ju Lua (wildcard.lua) Hero postavám. Zapne lištu 9990 „The power of a Hero…“. Všetky triedy, všetky kontinenty. |
| bar 9990 | Hero Essence (power) | Max 100, start 100, regen 0 | Alternatívny zdroj – vidí ho každá trieda. |
| pool 9500000+ | 239 schopností (96 + 143) | Cena 10/15/20/30 podľa rarity | `spell_power` riadky: retail ID + nové 9500xxx. Hráč si kupuje cez Character Advancement (N). Príklad Common 10 Essence. |

---

## 4. Skupina B – Hero talenty 1400100-1400127 (10 talentov, všeobecné pasívky)

Súbor: `hero_talents.sql`, generované `talents_build.py`. Každý rank = samostatné kúzlo, ranky sa sčítajú.
`characters.hero_talents`. Talent Essence 1/level od 10, Wildcard roll na párnych leveloch.

| ID | Meno (ranky) | Efekt (Wowhead typ: pasívny stat) |
|---|---|---|
| 1400100-02 | Hero's Fortitude (3) | +Stamina 3% / rank. |
| 1400103-05 | Hero's Might (3) | +Damage 2% / rank. |
| 1400106-08 | Keen Edge (3) | +Crit 1% / rank. |
| 1400109-11 | Quickening (3) | +Haste? (rýchlosť). |
| 1400112-14 | Mending Hands (3) | +Healing. |
| 1400115-17 | Iron Hide (3) | +Armor. |
| 1400118-19 | Fleet Foot (2) | +Movement speed. |
| 1400120-22 | Versatile Hero (3) | +Versatility 1% / rank. |
| 1400123-24 | Lifebinder (2) | Heal 1% z damage/healing. |
| 1400125-27 | Essence Attunement (3) | Essence regen +1 / 2s. |

Plus 165 (v3: 320) retail talentov naviazaných na Hero schopnosti vo `wildcard.lua` (TALENTS) –
tie sú z DB2, nie custom. C++: Essence aura vypne retail talent strom (diff `draconic-local.patch`).

---

## 5. Skupina C – Mystic Enchants 1401000-1401804 (629 custom + 176 retail = 805)

Súbor: `mystic_enchants.sql`, zdroj AzerothHub, generované `mystic_build.py`.
Tabuľka `world.mystic_enchant (id, name, spell, quality 3-6, classes, custom 0/1, scroll)`.
Príklad: `(1, 'A New Dawn', 1401000, 4, 'paladin', 1, 9710001)` – paladin-only, Epic, scroll 9710001.
`(12, 'Agent of Chaos', 331576, 4, 'warlock', 0, 9710012)` – retail reuse (custom=0).

- Quality = sila: 3 Rare, 4 Epic, 5 Legendary, 6 Mythic (príklad Alter Time 1401015, Angelic Feather 1401019).
- Classes: `paladin`, `warrior`, `mage`, `priest`, `rogue`, `warlock`, `shaman`, `druid`… alebo multi `paladin,shaman,warrior`.
- Efekt podľa mena: Ward (absorb), Haste, Mastery, Heal, Leap… – pasívky (Effect 6 Aura).
- Kde: scrolly 9710001-805 na 3197 miestach po celom svete (všetky mapy), zbierka `characters.mystic_collection`.

Patrí: **triedam podľa stĺpca classes, kontinent všetky** (scroll hunt po svete).

---

## 6. Skupina D – Manastorm 1402000-1402107, CoA Pyromancer, Dice/Potions

**Manastorm** (`manastorm.sql`, aréna GM Island):
- 1402000-09 Manastorm Empowerment (10x rovnaké meno, rôzne ranky) – posilnenie mobov v `manastorm_pool`.
- 1402100 Storm-Touched Might, 1402101 Arcane Bulwark…1402107 (8 boonov pre hráčov).
- Keeper 9900134 má spawn na každej mape (0/1/530/571/1136/2195…).

**CoA Pyromancer** (`coa_spells.sql`, push 1900700, Fire school 4):
1403000 Sulfuron's Descent (meteor), 1403001 Firelands Ward, 1403002 Blackwing Leap,
1403003 Emberbloom Touch (heal), 1403004 Deathwing's Wake, 1403005 Ring of Cinders,
1403006 Molten Carapace, 1403007 Ragnaros' Fury, 1403010 Kindled Haste (+5% haste),
1403011 Flameward Mastery (+5% Fire). Hero cesta 3, 21 CoA tried ako kity (`coa_path.sql`).

**Dice / Potions:**
- 1402301 Dice of Destiny – „Enables Wildcard Mode“ (item 9730003).
- 1402310-15 Essence Potion spelly (obnova % Essence), 1402320-25 Elixir buffy (1h aury Fortitude/Might/Keen…).

---

## 7. Skupina E – Warden quest odmeny (retail, Wowhead)

Nie custom, ale natívne kúzla ako odmeny kampane (dôvod: Warden = DH/rogue fantasy).
Všetky Night Elf only, giver Velarys 95113.

| Quest | Spell (Wowhead) | Škola / trieda | Čo robí |
|---|---|---|---|
| 95001 | 36554 Shadowstep – https://www.wowhead.com/spell=36554/shadowstep | Physical, Rogue Subtlety | Step za cieľ +70% speed. |
| 95002 | 5277 Evasion | Physical, Rogue | +Dodge (warden's dance). |
| 95004 | 31224 Cloak of Shadows – https://www.wowhead.com/spell=31224/cloak-of-shadows | Physical, Rogue | Magic immunity 5s. |
| 95005 | 195072 Fel Rush – https://www.wowhead.com/spell=195072/fel-rush | Chaos, DH | Rush vpred, Chaos damage. |
| 95006 | 185123 Throw Glaive – https://www.wowhead.com/spell=185123/throw-glaive | Physical, DH | Hod glaive, ricochet. |
| 95007 | 203431 Burden ensemble (transmog) | – | Raiment of the Watch. |
| 95008 | 198793 Vengeful Retreat | DH | Skok vzad + damage. |
| 95009 | 196718 Darkness | Shadow, DH | AoE avoid. |
| 95010 | 366962 Ash'adar, Harbinger of Dawn – https://www.wowhead.com/spell=366962/ashadar-harbinger-of-dawn + titul 342 Vengeance Incarnate | Mount | Spectral saber, Warden tematika (slnko/mesiac). |
| 95016 | titul 367 Demonslayer | – | Finálny titul. |

---

## 8. Odpovede „kto je kto / komu patrí / kam patrí“

1. **Aké skupiny?** – Podľa školy/účelu: Physical (rogue/DH mobilita), Fire (Pyromancer), Shadow/Chaos (DH), Holy/Nature (heal/tank talenty), pasívne staty (Mystic/Hero talenty).
2. **Horda / Aliancia / Warden?** – Spelly **nemajú frakciu**. Väzba je cez triedu alebo quest: Warden odmeny = Night Elf (Aliancia lore, ale quest flag len rasa 8), Mystic = trieda (`paladin`, `mage`…), Hero = všetky triedy, Manastorm = mobi vs hráči, CoA = Hero cesta 3.
3. **Kontinent / oblasť?** – Väčšina **bez zóny** (inventár / aura). Výnimky: Manastorm (aréna + všetky mapy), Mystic (3197 scroll miest všade), Warden odmeny (Teldrassil/Ashenvale/Felwood/Mardum quest huby).
4. **Wowhead:** Shadowstep – https://www.wowhead.com/spell=36554/shadowstep ; Cloak – https://www.wowhead.com/spell=31224/cloak-of-shadows ; Fel Rush – https://www.wowhead.com/spell=195072/fel-rush ; Throw Glaive – https://www.wowhead.com/spell=185123/throw-glaive ; Ash'adar – https://www.wowhead.com/spell=366962/ashadar-harbinger-of-dawn .
