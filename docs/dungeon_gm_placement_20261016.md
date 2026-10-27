# GM dungeon placement 2026-10-16 (retail-verified entry IDs)

Všetky entry ID overené: Wowhead tooltip API + TDB/DB mená sedia
(`dungeon_boss_tooltip_20261016.json`, Wiki Sporefall→Rotmire).
Hotové SQL (už v DB, ča na reštart): 2792 (7 bossov, `20261016_dungeon2792_bosses.sql`).

## POSTUP (GM v hre): `.go zonexy X Y` → `.npc add` → `.gps` → pošli mi výstup

Na každej pozícii: dojdi cez `.go zonexy`, over že miesto sedí (aréna/dielňa),
`.npc add <entry>`, potom `.gps` a skopíruj mi CELÝ výstup (map, zone, x, y, z,
orientácia). Ja z toho spravím finálne SQL (guidy + undo) a nasadím. Bez `.gps`
výstupu neaplikujem nič s odhadnutým Z (staged súbor `20261016_dungeon3_STAGED_gps.sql`).

## Vashj'ir enders bez spawnu (questové objektívy už nasadené 2026-10-16)

- `.npc add 41750` (Legionnaire Nazgrim, Kelp'thar ~[39,31] loď Immortal Coil; ender 25948)
- `.npc add 40916` (Captain Vilethorn, Shimmering Expanse; ender 25958)
- `.npc add 40917` (Legionnaire Nazgrim, Legion's Rest; ender 25973)
- `.npc add 40643` (Admiral Dvorek, Tranquil Wash; ender 25583/25747)
- `.npc add 40919` (Wavespeaker Tulra, Horde camp; starter 25958/26006)
- `.npc add 41810` (Legionnaire Nazgrim, Nespirah; ender 25991)
- `.npc add 42410` (Legionnaire Nazgrim, Stygian Bounty; ender 26006)
- 25863 ender live `40586` na mape 643 (retail ender `42076` Lady Naz'jar nespawnutá) — GM over reachability v hre.

## Erunak hub enders (objektívy nasadené 2026-10-16, `20261016_vashjir_erunak.sql`)

- `.npc add 41711` (Legionnaire Nazgrim [39.0,32.1]; ender 25941)
- `.npc add 41324` (Private Pollard, Deepmist Grotto [64.0,59.8]; ender 25812)
- `.npc add 41863` (Gurrok, Deepmist Grotto [64.0,59.8]; ender 26000)

## 2097 Operation: Mechagon (6/8 → 8/8) — retail súradnice z Wowhead tooltip API

- `.go zonexy 45.7 38.7` (zóna 10225 Mechagon) → `.npc add 144246` (K.U.-J.0.)
- `.go zonexy 28 70.7` (zóna 10225 Mechagon) → `.npc add 144244` (The Platinum Pummeler)
- Zdroj: `dungeon_boss_map_20261016.json` (tooltip `map.zone/coords`); scrape pinov sedí na rovnaké %.

## 2830 Eco-Dome Al'dani (duo encounter Taahbat+A'wazj) — retail súradnice z tooltip API

- `.go zonexy 56.6 44.6` (zóna 16104 Eco-Dome) → `.npc add 234933` (Taah'bat — vedľa A'wazj 237514, duo-fight)
- A'wazj ponechaný `237514` (TDB-verified); core script opravený (`ecodome_aldani.h`
  BOSS_AWAZJ 241375→237514, commit `38d8c243c3`, treba rebuild+reštart).

## 2574 Dragon Isles (0/4)

- `.npc add 193535` Basrikron, `.npc add 193534` Strunraan,
  `.npc add 193533` Liskanoth, `.npc add 193532` Bazual (príbuzná skupina, jedno miesto).

## 2930 Midnight raid (0/5)

- `.npc add 238015` Predaxas (main verzia; alt `248864` len ak GM potvrdí druhú fázi/verziu),
  `.npc add 244424` Cragpine, `.npc add 244762` Lu'ashal, `.npc add 249776` Thorm'belan.

## 2774 Khaz Algar (0/1) · 2987 Tidebound (0/1) · 1592 Sporefall (0/1)

- `.npc add 238319` Reshanor
- `.npc add 252959` Nymrissa Wavecaller
- `.npc add 254176` Rotmire (journal-boss verzia; `238693` je world-verzia — neumiestňovať)

## Po session

Z každého `.npc add` zapísať guid+coords do `Custom/sql/20261016_dungeon_<map>_place.sql`
(+ `_undo.sql`), reštart, `.diag` kontrola. Updatnúť `dungeon_audit_20261016.md`.
