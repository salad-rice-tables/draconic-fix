# Dungeon audit 2026-10-16 (live DB, 705 769 creature rows)

Metodika: `instance_template` (261 máp) JOIN `creature` + `creature_template`
(`Classification`: pozor — novší retail obsah má bossov často `0`, nie `3`;
`3` platí hlavne pre staré raidy/5-mans). Boss-ID zdroje: core hlavičky
(`murder_row.h`, `ecodome_aldani.h`), `dungeon_boss_worklist.md`, Wowhead
tooltip spot-check (`238887` Taz'Rah == DB meno ✓).
JSON: `dungeon_audit_20261016.json`. Predchádzajúci audit: `dungeon_audit.md` (10-12).

## Mask-fix (20261012_dungeon_mask_default.sql) — overené funkčné ✅

Server reštartnutý 10-16, predtým-flagované mapy sú dnes plné (ours ≥ TDB):

| mapa | predtým | dnes | TDB |
|---|---|---|---|
| 33 Shadowfang Keep | 394 | 471 | 468 |
| 616 Eye of Eternity | 12 | 14 | 14 |
| 643 Throne of Tides | 260 | 576 | 576 |
| 754 Throne Four Winds | 23 | 29 | 29 |
| 939 Well of Eternity | 245 | 269 | 269 |
| 1501 Black Rook Hold | 247 | 284 | 284 |
| 309 Ancient ZG | 3 | 5 | 4 |
| 2993 Altar of Fangs | 0 | 71 (Rav'i, Writhing Coil, Zul'jan cl=3 ✓) | — |
| 1754 Freehold | 0 | 5 bossov cl=3 ✓ komplet (Kragg, Jolly, Raoul, Eudora, Harlan) | 0 |
| 2805 Windrunner Spire | 0 | 5 unikátov (Emberdawn, Kalis, Latch, Kroluk, Restless Heart) | — |
| 2859 Blinding Vale | 0 | 6 unikátov (Meittik, Kezkitt, Lekshi, Ikuzz, Ruia, Ziekket) | — |
| 2923 Voidscar Arena | 0 | 3 (Taz'Rah ✓ tooltip, Atroxus, Charonus) | — |

## Bossovia overení po mene/ID ✅

- **2813 Murder Row**: 234648/234649/234647/237415 + Nibbles 234660 — všetci spawnutí (core `murder_row.h`).
- **3004 Venomous Abyss**: všetkých 10 z worklistu (253563…268956) — spawnutí.
- **2811 Magisters' Terrace**: Seranel Sunlash, Gemellus, Degentrius, Arcanotron Custos + trash.
- **2825 Den of Nalorakk**: Nalorakk 246404 ✓ (+ Zul'jarra, trash, RP objekty).
- **2859/2805/2912** (6 boss-like unikátov: Salhadaar, Vorasius, Averzian, Vaelgor, Ezzorak, Slaurna) **2913** (Throggar, Morinas, L'ura) **2915** (Decimus, Kasreth, Nysarra) **2939** (Chimaerus, Amarakk, Shul'ka, En'liahn).

## Chýbajúci bossovia (nové nálezy) 🔧

1. **2097 Operation: Mechagon 6/8**: chýba K.U.-J.0. `144246` a Platinum Pummeler `144244` (nikde v DB). Zvyšok (Gobbamak, Gunker, Naeno, HK-8, Trixie) spawnutý.
2. **2830 Eco-Dome Al'dani**: chýba Taahbat `234933` (nikde v DB); A'wazj spawnutý ako `237514`, ale core `ecodome_aldani.h` čaká `241375` — encounter kredit pre A'wazj pravdepodobne neprejde. Azhiccar + Soul-Scribe OK.
3. **Prázdne mapy (0 spawnov)**: `2792` BRD-raid (7 bossov z worklistu), `2574` (4), `2930` Midnight (5), `2774` (Reshanor), `2987` (Nymrissa), `1592` Sporefall. Riešenie: in-game GM placement (worklist postup), SQL pozície netipovať.
4. Skip (systém/test, bez encounterov): 2235 Anniversary, 3029 Keystone, 3105 Dummy Dome, 2950/2972 story, 2233, scenáre 1152–1245, 1330/1331, delves.

## Ďalej

- In-game session: placement bossov pre 6 prázdnych máp + Taahbat + 2× Mechagon (súradnice len z hry, nie z hlavy).
- Opraviť A'wazj entry 237514 → 241375 (alebo duálny spawn; overiť ktorý entry má retail encounter — tooltip check).
- Zvyšných ~190 máp s trash-spawnmi bez cl=3: bez chýb v počtoch (parita s 10-12 auditom + mask-fix), encounter logiku riešiť až pri hraní.
