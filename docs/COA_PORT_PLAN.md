# CoA content port plan (what the CoA repo has that this Midnight server does not)

Source: https://github.com/Conquest-of-AzerothCore/azerothcore-wotlk-coa (AzerothCore 3.3.5 schema, ids and C++ API; this server is Midnight 12.1.5 on a TrinityCore core, so nothing imports as is).
Local cache of the repo file list: `Custom/data/coa/repo_tree.json`. Raw files: `https://raw.githubusercontent.com/Conquest-of-AzerothCore/azerothcore-wotlk-coa/master/<path>`.

## Status 2026-11-16
| Area | Repo size | Here |
|---|---|---|
| 21 CoA classes (spells, talents, kits, slot 13 = free choice) | done | data verified 0 diffs, in-game test pending |
| Necromancer minions | done | 4 missing creatures added (Muckworm, Rotling, Banshee, Greater Zombie) |
| Worldforged pickups (`modules/mod-worldforged-pickups`, 1,742 pickups, 17 KB C++ + 3.3 MB SQL) | data + small module | OUR OWN version exists: lua/worldforge.lua (objects spawn near players, once per character, 1,383 items 9700001+, 7,134 item rows, Mystic Enchants). Not the CoA data; compare counts/positions to CoA (1,742) later |
| Worldforged items (Ascension item ids) | thousands of item rows | our items are 9700001+ (own ids) |
| Manastorm (`modules/mod-manastorm-endless`, 316 files / ~30 MB, affix engine, caches, client bridge) | big C++ module | OUR OWN simple version: lua/manastorm.lua (276 lines, Keeper 9900134). CoA's affixes/caches/floor safety/UI not ported |
| Custom dungeon bosses (Molten Core, Basalthane, RFD, BFD, Deadmines, RFC, mythic encounters) | ~100 SQL + scripts | Molten Core bosses present, rest to check |
| mod-coa-mythic-plus, raid-difficulty, challenges, legendary items, prestige, lottery ... | modules | NOT ported |

## Porting rules learnt
* New ids: old id + 7,000,000 (spells, creatures); gameobject spawn guids in their own range; 302 of the 1,555 Worldforged object entries collide with our own templates, so entries need an offset.
* Worldforged loot items are Ascension-only items: item rows must be built as Midnight hotfix records (pattern: tools/coa_spell_to_hotfix.py, coa_starter.py).
* A C++ module needs its AzerothCore API calls rewritten for the TrinityCore core (Source/Draconic-RoleplayCore, build with MSBuild from PowerShell, copy exe to MyServer\...\RelWithDebInfo).

## Phase 1 done 2026-11-16 (own Hero/Wildcard layer switched off)
* Backup of everything (Lua, addons, DB dumps, SQL, tools): `C:\WowServer\Backup\own_coa_20261116\` (see its README.txt).
* Moved out of `Custom/lua` (and `bin/.../lua_scripts`) into `Custom/lua_disabled_own/`: wildcard, hero_class, hero_items, hero_power, paragon, challenges, manastorm, worldforge (+Mystic Enchants), mystic_sources, ascension_extra, ascension_world. All callers of their globals are guarded (`if MYS_AddRunes then`), so story scripts still load.
* Class choice is now `lua/coa_choose.lua` (slot 13 = Conquest Hero picks any of 21 classes; saved in characters.wildcard_coa; COA_KEY(player) everywhere; coa_necromancer_main exports COA_LEARN).
* Restore the old system: move the files back and restart (tools/restart_world.ps1).
* Next: Phase 2 original Worldforged (mod-worldforged-pickups data + items as Midnight hotfix rows), Phase 3 original Manastorm (mod-manastorm-endless C++ -> our core), Phase 4 other modules.

## Phase 2 (Worldforged, original CoA data) 2026-11-16
* Tool: `tools/coa_worldforged_import.py apply|undo` (+ `tools/worldforged_logic.lua`). Replays CoA module SQL (40 files) into scratch schema `cow_scratch`, imports the pickups that have BOTH a display the Midnight client resolves AND an item we already have: 413 of 1,750 templates / 623 spawns (entry 900000000+CoA entry, guid 960000000000000000+CoA guid, type 10 goober, once per character: characters.worldforged_pickup).
* Remaining: 1,083 pickups need a display (CoA custom gob displays: 561 of 1,023 ids are not in Midnight; export from the CoA client GameObjectDisplayInfo.dbc + models), 692 need item rows (687 Ascension items not in worldforge_item). Z positions are CoA's (3.3.5 terrain) - check floating/buried objects in game.
* Server log shows `Invalid spell modifier type 41/42/127 ... consider increasing MAX_SPELLMOD` for CoA spells (Ascension-only spellmod ids, same family as the aura/effect numbering problem).

## Worldforged status 2026-11-16 (late)
* In game: 1,231 pickup templates / 1,879 spawns (CoA ids +900000000 / guid block 960000000000000000). Tools: coa_worldforged_import.py, coa_worldforged_items.py (items 9760001+, 644 built), coa_gob_displays_to_hotfix.py (523 displays, push 1952300).
* Not in game: 357 pickups. 328 need one of 38 CoA-only models (e.g. item/objectcomponents/weapon/custom_weapon_10mp_toolshovel01.mdx; 3.3.5 M2 v264 + embedded skins, needs conversion to the Midnight chunked M2 + .skin + new FileDataIDs) and 29 items have no attributes anywhere.
* Manastorm: NOT portable 1:1 (custom client opcodes 0x651.. + Ascension_Manastorm addon); do it as Lua + CoANative UI after the UI base works.
