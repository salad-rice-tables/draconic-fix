# Dungeon boss work-list (in-game placement, Claude/3004 pattern)

Pattern: spawn bosses with `.npc add <entry>` (default mask `0,1,2,8,14,15,16,17,23,24,205`
= visible in default/normal instance), position in-game like map 3004
(Nek'zali 253563, Sszorak 257347, Vexhul 257361, Ithraz 257368, Breath 258557,
Blood 258558, Vashnik 259181, Malacrass 259854, Morzahi 267077, Ulatek 268956).
Portals: add guid rows to `Custom/lua/dungeon_pads.lua` DEST (object 204386).

## Empty maps with encounters (DungeonEncounter.csv 12.1.0)

- 2792 Blackrock Depths (raid): 9025 Lord Roccor, 9017 Lord Incendius,
  9016 Bael'Gar, 9033 General Angerforge, 8983 Golem Lord Argelmach,
  9156 Ambassador Flamelash, 9019 Emperor Dagran Thaurissan (+The Seven 3048:
  use encounter adds). NOTE: 2263xx variants are Timewalking versions, use 90xx.
- 2574 (raid): 193535 Basrikron, 193534 Strunraan, 193533 Liskanoth, 193532 Bazual.
- 2930 Midnight (raid): 238015/248864 Predaxas, 244424 Cragpine,
  244762 Lu'ashal, 249776 Thorm'belan.
- 2774 Khaz Algar (raid): 238319 Reshanor.
- 2987 Tidebound Grotto (raid): 252959 Nymrissa Wavecaller.
- 2950/2972 story raids: Raszageth (182416/182492/184983/185411/188882/189492 -
  pick version in-game), Fyrakk (185409/194923/197721/197934/200832/200846).
- 2235 Anniversary, 3029 Keystone, 3105 Dummy Dome: system/test, skip.

## Fixed 2026-10-12 (no placement needed)

- 1754/2097/2993: 81 spawns had mask `0` = skipped at load
  (`20261012_dungeon_mask_default.sql`). Now default mask. NEEDS worldserver restart.
