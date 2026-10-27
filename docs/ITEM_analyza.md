# Analýza všetkých custom itemov – podľa Wowheadu

Zdroj: `Custom/REGISTRY.md` + `Custom/sql/worldforge_*.sql`, `mystic_enchants.sql`,
`inn_rooms.sql`, `potions.sql`, `dice_item.sql` (Hero Codex), `legends_armory.sql`,
`mystic_altars.sql`, `ascension_world.sql`.
Metodika Wowhead: `ClassID` (Weapon 2 / Armor 4 / Consumable 0 / Misc 15…) +
`SubclassID` + `InventoryType` (slot) + `Quality` + `ItemLevel` + zóna / kontinent
(`world.worldforge_item`, `world.mystic_spawn`, `gameobject` spawny).

> Custom ID 97xxxxx na Wowheade neexistujú. Wowhead odkazy vedú na význam
> Class/Subclass/InventoryType a na retail vzor / zónu, podľa ktorej je item robený.

---

## 1. Legenda – ako čítať item (Wowhead ItemType)

Podľa https://www.wowhead.com + https://warcraft.wiki.gg/wiki/ItemType :

| ClassID | Wowhead typ | Subclass príklady |
|---|---|---|
| 2 | Weapon (zbraň) | 0 Axe 1H, 1 Axe 2H, 2 Bow, 3 Gun, 4 Mace 1H, 5 Mace 2H, 6 Polearm, 7 Sword 1H, 8 Sword 2H, 9 Warglaive, 10 Staff, 13 Fist, 15 Dagger, 18 Crossbow, 19 Wand |
| 4 | Armor (zbroj) | 0 Misc (trinket/ring/neck), 1 Cloth, 2 Leather, 3 Mail, 4 Plate, 5 Cosmetic, 6 Shield |
| 0 | Consumable | 2 Potion / Elixir (naše 9730010-25) |
| 15 | Miscellaneous | 0 Junk, 5 Mount |
| 12 | Quest | quest item |

`InventoryType` = slot: 1 Head, 2 Neck, 3 Shoulder, 5 Chest, 7 Legs, 8 Boots, 9 Wrist,
10 Hands, 11 Finger, 13 Weapon 1H, 17 Weapon 2H, 18 Ranged, 21 Main Hand, 23 Off Hand / Trinket…
`Quality`: 1 Common (biela), 2 Uncommon (zelená), 3 Rare (modrá), 4 Epic (fialová).
Hotfix tabuľky: `hotfixes.item` (Class/Subclass/Icon), `item_sparse` (meno/quality/level/stats),
`item_modified_appearance` (vzhľad), `item_effect` + `item_x_item_effect` (on-use spell).

Kontinent / zóna: `world.worldforge_item (item, name, zone, x, y, quality)` +
`world.mystic_spawn (entry, map, wx, wy)` + `gameobject (guid, id, map, zoneId, areaId)`.
Map: 0 Eastern Kingdoms, 1 Kalimdor, 530 Outland, 571 Northrend… Zone: klasické
Wowhead ID – napr. Wetlands, Winterspring, Teldrassil 141, Ashenvale 331, Felwood 361…

---

## 2. Sumár – koľko čoho máme

| Skupina | ID rozsah | Počet | Súbor | Komu patrí / kde |
|---|---|---|---|---|
| Worldforge Atlas (Ascension classic) | 9700001-9701383 | **1383 itemov** + objekty 9700004-9701383 | worldforge_items.sql + worldforge_objects.sql | 362? zón classicu, príklad Wetlands, Winterspring. Objekt = goober, entry = item. Loot cez `worldforge.lua`, `characters.worldforge_looted`. Hotfix push 1900120. |
| Worldforge World (všetky expanzie + dungeony) | 9720001-9723399 | **3399 itemov** + objekty | worldforge_world.sql | 362 zón + dungeony všetkých expanzií, meno podľa podzóny, vzhľad/scaling z retail itemu danej expanzie. Statické spawny `gameobject` guid 3100000001-3100004320. Push 1900140. |
| Mystic Scroll objekty | 9710001-9710805 | **805 objektov** | mystic_enchants.sql | 3197 miest `world.mystic_spawn`, spawn cez worldforge.lua. Každý scroll = 1 enchant. |
| Systémové objekty | 9709997, 9709998, 9709999 | 3 | inn_rooms.sql, ascension_world.sql, mystic_altars.sql | 9709997 Room Door (438 hostincov, guid 3100200001-438), 9709998 Lost Satchel (High-Risk zóny), 9709999 Mystic Altar (oltár). Type 10 (goober). |
| Kľúč / Codex / Potions / Elixíry | 9730001, 9730003, 9730010-15, 9730020-25 | 1+1+6+6 = **14** | inn_rooms.sql, dice_item.sql, potions.sql | 9730001 Inn Room Key (push 1900180), 9730003 Hero's Codex / Dice of Destiny (push 1900210, use = spell 1402301), potions (push 1900600). Class 0 Consumable / 15 Misc. |
| Legends Armory vendor stock | 17182, 32837, 32838 | 3 retail | legends_armory.sql (vendor 95106) | 17182 Sulfuras, 32837/32838 Warglaives – ikonické zbrane, nie custom, len vendor stock. Thunderfury 13550 v tejto DB neexistuje – skip. |

Celkom custom itemov: **1383 + 3399 + 14 = ~4796** (+ 805 scroll objektov + 3 systémové objekty).
Všetky custom majú `VerifiedBuild 69933`.

---

## 3. Skupina A – Worldforge Atlas 9700001-9701383

Súbor: `worldforge_items.sql` (+ objekty `worldforge_objects.sql`).
Pôvod: Ascension `Worldforged Atlas` – meno, flavor, kvalita a staty z Ascension,
vzhľad / itemlevel / armor / damage z retail šablóny rovnakého typu a levelu.

Príklad hlavičky:
`(9700001, 4, 0, 3, 2, …)` = Class 4 Armor, Subclass 0 Misc (trinket/ring), Inventory 2 Neck.
`(9700002, 1, 0, …)` – pozor Class 1 = Container (vak), nie zbraň.
`(9700003, 2, 19, … 26 …)` = Class 2 Weapon, Subclass 19 Wand, Inventory 26 Ranged.

Mapovanie: `world.worldforge_item`:
- `(9701364, 'Swiftgear Sniper', 'Wetlands', 28, 22, 2, 521254)` – puška, Wetlands (Eastern Kingdoms, map 0), quality 2 Uncommon.
- `(9701371, 'Chillbane Cleaver', 'Winterspring', 35, 45, 3, 410082)` – sekera, Winterspring (Kalimdor, map 1), quality 3 Rare.

Frakcia/alias: **nikomu – neutrálny loot.** Komu „patrí“ = zóne, kde leží.
Kontinent: **oba – Eastern Kingdoms aj Kalimdor** (classic zóny).
Wowhead zóny: Wetlands, Winterspring – bežné classic farm zóny.

Objekty: `gameobject_template entry 9700004-9701383, type 10 goober`,
napr. `(9700004, 10, 259, 'Alteraci Avenger', …)` – klikací predmet vo svete,
spawn dynamický (`spawn_guid=1` cez worldforge.lua keď príde hráč).

---

## 4. Skupina B – Worldforge World 9720001-9723399 (všetky expanzie)

Súbor: `worldforge_world.sql`, generované `wf_world.py`.
Rozdiel proti Atlasu: **názov podľa podzóny, vzhľad/scaling z retail itemu danej expanzie.**
Teda Outland item vyzerá ako Outland, Northrend ako Northrend…

Príklad: `(9720001, 4, 3, …)` = Armor Mail, `(9720002, 2, 1, …)` = Weapon Axe 2H.
Statické spawny: `gameobject guid 3100000001-3100004320` (4320 spawnov, z toho 921 Mystic Scrollov).
Tabuľka `world.worldforge_item` má aj 972xxx riadky.

Kontinent: **všetky – 0 Eastern, 1 Kalimdor, 530 Outland, 571 Northrend, 1136, 1220, 2195…**
+ dungeony (362 zón celkom). Najväčšia skupina, endgame loot po celom svete.

---

## 5. Skupina C – Mystic Scrolls + systémové objekty

| entry | Meno | Type | Kde / komu patrí |
|---|---|---|---|
| 9710001-9710805 | Mystic Scroll (805) | GameObject | 3197 miest `world.mystic_spawn` po celom svete (všetky mapy). Klikneš – dostaneš enchant. Wowhead ekvivalent: „scroll / treasure“. |
| 9709997 | Room Door | GO 10, display 2751 | 438 hostincov (inn_rooms.sql, guid 3100200001-438) – dvere do prenajatej izby. Otvára `living_world4.lua` s kľúčom 9730001. |
| 9709998 | Lost Satchel | GO | High-Risk zóny (ascension_world.sql) – denná bounty odmena. |
| 9709999 | Mystic Altar | GO | Oltáre v hlavných mestách + 4 v open world (mystic_altars.sql, guid 3100100001+). |

---

## 6. Skupina D – Kľúč, Codex, Potions, Elixíry (973xxxx)

| entry | Meno | Class / Quality / Level | Účel – komu patrí |
|---|---|---|---|
| 9730001 | Inn Room Key | Misc / spotrebný | Kľúč od izby (1900180). Kúpiš cez `.room`, dvere 9709997. Platí 1 deň (`characters.inn_room`). |
| 9730003 | Hero's Codex / Dice of Destiny | 15 Misc, display 'Dice of Destiny' | Use = spell 1402301 (Wildcard Mode). Popis: „reroll starter spells cez Character Advancement (N) pred levelom 10“. Via `item_effect (9730003 → 1402301)`. |
| 9730010-9730015 | Minor / Lesser / Essence / Greater / Major / Supreme Essence Potion | 0 Consumable (Potion), Q 1-4, lvl 1/10/20/35/50/65 | Obnovia % Hero Essence (`lua/potions.lua`). Stack 20. Ceny 40c – 40000c. Wowhead typ: mana/health potion analóg. |
| 9730020-9730025 | Elixir of Fortitude / Might / Keen Edge / Quickening / Mending / Iron Hide | 0 Consumable (Elixir), 1h buff aury | Hodinové buffy kopírujúce Hero talenty. |

Všetky **neutrálne – pre každého hráča**, predajné ceny v `item_sparse` (Sell/Buy).

---

## 7. Skupina E – Legends Armory (retail, nie custom)

Vendor Keeper Juzan 95106 (`npc_vendor`):
- 17182 Sulfuras, Hand of Ragnaros – https://www.wowhead.com/item=17182/sulfuras-hand-of-ragnaros – 2H Mace, legendárka.
- 32837/32838 Warglaive of Azzinoth (main/off) – https://www.wowhead.com/item=32837/warglaive-of-azzinoth – Warglaive, Illidan.
- Thunderfury 13550 v tejto DB neexistuje – zámerne vynechané.

Komu patrí: **nikomu / vendorovi v Orgrimmari (Horda mesto, ale faction 35 Friendly – kúpi každý).**

---

## 8. Odpovede „kto je kto / komu patrí / ktorý kontinent“

1. **Aké skupiny?** – Podľa ClassID: **Weapon (2) + Armor (4) = ~95%** (Worldforge loot), Consumable (0) = potions/elixíry, Misc (15) = codex/kľúč, GO (objekty) = scrolly/dvere/oltáre.
2. **Horda / Aliancia?** – Itemy **nemajú frakciu** (nie sú NPC). „Komu patrí“ = kde leží / kto predáva: Worldforge = zóne (oba kontinenty, všetky expanzie), vendor = Juzan (Orgrimmar, ale kúpi každý), kľúč/potions = každý hráč.
3. **Kontinent / oblasť?** – Atlas: classic Eastern + Kalimdor (Wetlands, Winterspring…). World: **všetky mapy 0/1/530/571… + dungeony (362 zón)**. Scrolly: 3197 miest všade. Dvere: 438 hostincov (13 hlavných miest + 396 dedín). Potions/kľúč: inventár, bez zóny.
4. **Wowhead:** Class/Subclass/Inventory – https://warcraft.wiki.gg/wiki/ItemType ; Sulfuras – https://www.wowhead.com/item=17182/sulfuras-hand-of-ragnaros ; Warglaive – https://www.wowhead.com/item=32837/warglaive-of-azzinoth .
