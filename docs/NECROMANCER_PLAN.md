# CoA Necromancer on Midnight — plan (2026-11-06)

Source of truth: `Custom/data/coa/necromancer.md` (Ascension export: 3 specs Animation/Death/Rime, 427 talent entries, 208 spells, Life Force) + CoA source `src/server/coa/AscensionNecromancer*.cpp` (Abilities, Auras, Contracts, Summons, Events, Data).
Backup before any change: `Custom/backup_coa_port_20261106` (lua, addon, sql).

## Done
- Path window removed: `wildcard.lua` COA_ONLY=true -> every new hero is auto-set to Conquest (no Wildcard/Classless/CoA choice window). Set `COA_ONLY = false` to restore. Takes effect at next worldserver start (server was offline when edited).

## Resources
- Life Force (CoA class mechanic) = custom UnitPowerBar like Hero Essence (bar 9990 pattern, hotfix spell_power) — new bar id needed.
- Runic Power = retail power type 6 (already in client).

## Build order
1. Animation spec (summons): Raise Crypt Leaper, Grave Mage, Summoning Stone, Lesser Summoning, Foul Bidding (Protect/Slaughter), Contracts. Needs: creature templates + SmartAI/Lua pet AI, hotfix spells (id range reserved 1450000+), Life Force + Runic Power costs.
2. Death spec (plague DoTs: Crypt Plague, Harvest Plague, Plaguewither, Putrefy, Rotten, Vile).
3. Rime spec (frost lich: Tundra Warriors, Glacial Runes, Arctic Blast, Frozen Wrath, Glacial Flip).
4. Class tree (52 nodes) + extra Midnight-level talents (more tiers to level 90).

## Open technical risk
- Custom trait tree in the retail talent window is untested (hotfix tables trait_* are empty). Fallback: existing Character Advancement window (addon Advancement.lua/TalentLayout.lua + CoaData.lua).

## Findings 2026-11-06 (CoA source + local Ascension data)
- CoA C++ (`AscensionNecromancer*.cpp`, 134 KB) only HOOKS custom spells (coefficient table of ~65 spells, summon table of ~45 spell->creature rows, procs, contracts). The spell/creature/talent DEFINITIONS are DBC/SQL data, not in the C++.
- We have that data locally: `Custom/data/ascension-data/exiles/tables/` (spell.csv.gz 240 858 spells with full effect JSON, talent, talent_tab, class_spell, creature(+spell_data/loot/spawn), icon; 80k icon images in `supplemental/exiles-db-export`; talent trees also in `supplemental/coa-databank`).
- Extracted: `Custom/data/coa/necromancer_spells_raw.json` = 208 spellbook spells + triggered-spell closure = 330 spells. Effects used: Apply Aura 288 (mostly proc/mod/dummy: auras 42 proc, 4 dummy, 107/108 class-mask mods, 23 periodic trigger), School Damage 282, Summon 28 (+ 51 dummy/trigger), power types: mana 274, runic power 41, rage 6, energy 4, focus 3.
- Existing precedent: Pyromancer hotfix spells `sql/coa_spells.sql` (push 1900700), custom power bar Hero Essence.
## Next
1. Converter `tools/coa_spell_to_hotfix.py`: 3.3.5 spell row -> hotfixes (spell_name, spell, spell_misc, spell_effect, spell_power, spell_cooldowns, spell_categories, spell_class_options, spell_x_spell_visual). Reserved ID range 1450000+ (old id + offset) so nothing collides.
2. Summon creatures (50067.. etc.) from exiles `creature` -> world creature_template (new entry range) + display ids mapped to Midnight models.
3. Port the C++ hook logic (coefficients, summons, procs, contracts) to Eluna / server hooks, Animation spec first.

## Icons (2026-11-06)
- `data/coa/necromancer_icons.json`: spellId -> retail `fileDataID` (164 icons found in the community listfile) or `custom` texture path (96 CoA-custom icons, 65 unique, converted PNG->64x64 TGA into `addon/Wildcard/art/coa_icons/`).
- Native client UI (action bars/spellbook) can only show retail FileDataIDs: custom-art spells get a themed retail fallback there; our addon windows (Character Advancement, talent tree) show the custom TGAs. A client patch could add real custom BLPs later.

## Built 2026-11-06
- `tools/coa_spell_to_hotfix.py` -> `sql/20261106_coa_necromancer_spells.sql` (+_undo): 330 spells = 7000000+old id, push 1950100 (hotfixes: spell_name/spell/misc/effect/cooldowns/categories/class_options/levels/power/visual). APPLIED to DB (needs worldserver restart + client hotfix refresh to see).
- `tools/coa_creatures_to_world.py` -> `sql/20261106_coa_necromancer_creatures.sql` (+_undo): 20 summon creatures = 7000000+old id (templates, models, pet-like difficulty row, spells). 
- Known approximations: 3.3.5 duration/cast/range/radius indices used as-is only when they exist in 12.x tables (else 0); mana cost -> % of base mana (cost/80); visuals = generic shadow/frost/fire bolt stand-ins; attribute bits copied for Attributes1-8 only; talent rows, Life Force bar, Eluna hooks and windows NOT done yet.

## 2026-11-06 — class slots instead of new class ids
- The retail client lists only classes 1..13 on the creation screen and rejects any other id (Wow.exe code is Arxan-obfuscated; no safe patch). So the 13 creation slots now ARE CoA classes (tools/coa_class_slots.py, sql/20261106_class_slots.sql, push 1950400):
  Warrior=Barbarian, Paladin=Sun Cleric, Hunter=Ranger, Rogue=Venomancer, Priest=Cultist, Death Knight=Necromancer, Shaman=Witch Doctor, Mage=Runemaster, Warlock=Bloodmage, Monk=Templar, Druid=Primalist, Demon Hunter=Felsworn, Evoker=Chronomancer.
- Not placed (need >13 slots / exe patch): Starcaller, Tinker, Knight of Xoroth, Witch Hunter (+ Guardian, Pyromancer, Reaper, Stormbringer, Son of Arugal).
- Server: lua/coa_class_slots.lua (slot -> coa key), wildcard.lua auto-chooses the CoA class from the creation class (no window). Client: class icons are real files (files/Interface/Icons/coa/class_*.blp, mappings/coa_class_icons.txt, ids 9500201..9500213) shown by the glue override Blizzard_CharacterCreate.lua.
- Bloodmage has no data in data/coa yet (kit is a placeholder copy of Reaper's); Felsworn/Templar still use the retail Demon Hunter / Monk spell kits from coa_kits.lua.
- Class 15 experiment removed. Backup of the client before patching: C:\WowServer\Backup\wow_client_20261106.

## 2026-11-06 (late) — all-class build + CoA start logic
- DONE: `tools/coa_all_build.py` + `coa_spell_to_hotfix.py` + `coa_creatures_to_world.py`: ALL 21 CoA class books -> 6129 spells (hotfix push 1950500, ids 7000000+CoA id), 73 summon creatures (7000000+id), icons (retail ids / 865 custom BLP files in client `files/Interface/Icons/coa`, mapping `mappings/coa_icons_all.txt`, ids 9510000+), per-class learn schedule `lua/coa_class_schedule.lua` (1657 castable spells by level) used by `coa_necromancer_main.lua` (any CoA class, key from characters.wildcard_coa.class). Old necromancer-only push 1950100 removed.
- DONE: starts by race like CoA (Valley of Trials = orc/mag'har/vulpera/goblin/dracthyr horde, Echo Isles = troll, Narache = tauren/highmountain, Deathknell = undead/blood elf/nightborne, Shadowglen = night elf/draenei/lightforged/haranir, Coldridge = dwarf/gnome/dark iron/mechagnome/earthen, Northshire = human/worgen/void elf/kul tiran/dracthyr alliance; pandaren + zandalari keep theirs). Backup table playercreateinfo_bak_20261106.
- CoA facts found: CoA classes are real core classes 12..32 (client = custom Ascension client). Our client only has 13 slots (see mapping above). CoA seeds `playercreateinfo_action` per custom class, grants a "CoA live baseline" in C++ (OnPlayerCreateInitialItems), starter gear = exiles table `item_character_creation` (75 rows item 2000000+ -> class id), Worldforged = mod-worldforged-pickups/-upgrades modules + data in supplemental/worldforged.
- TODO (next stages): (1) starter gear: import the 75 starter items (item/item_sparse hotfix rows) and grant on creation per slot class; (2) action bars per class (playercreateinfo_action from CoA seeds); (3) Worldforged pickups + upgrade ladders; (4) talents + CoA windows (Character Advancement tree for each class); (5) resources per class (rage/energy/etc. bars), passives/procs hooks (C++ in CoA -> Eluna), unlock of further areas.

## 2026-11-06 stage: starter gear + action bars + Bloodmage fix
- tools/coa_starter.py: 75 CoA starter items -> hotfix item/item_sparse/item_modified_appearance (push 1950600, undo sql/20261106_coa_starter_undo.sql), look = retail template of same class/subclass/inv type; lua/coa_starter.lua (COA_STARTER) + lua/coa_starter_main.lua (grant+equip on first login, <2 min played).
- playercreateinfo_action classes 1..13 = first 12 scheduled spells of the slot's CoA class (old Mage copies removed; undo = copy class 8 rows).
- Slot 9 now key `sonofarugal` (Bloodmage); placeholder removed from coa_kits.lua.
- Needs worldserver restart (playercreateinfo*, class_expansion_requirement) + client relog (hotfixes). NOT yet verified in game.
- Still open: talents/Character Advancement windows, per-class resources, CoA C++ hook logic, area unlocks, 4 classes without a slot (Starcaller, Tinker, Knight of Xoroth, Witch Hunter), Worldforged verification.

## 2026-11-06 stage: companion books
- tools/coa_books.py: creatures 7900001 Book of Descension (class trainer; one gossip trainer option per slot class via class conditions, trainers 7901001..13 = COA_SCHEDULE spells with level>1, cost level^2*10 copper) and 7900002 Tome of Professions (15 profession trainers). Minipet summon spells 7900101/2 (hotfix push 1950700), learned at creation (spell_custom) and at login. Undo: sql/20261106_coa_books_undo.sql.
- Auto-learn by level removed: only level-1 spells are auto-learned; the rest is taught by the book. Starter gear now via playercreateinfo_item (auto-equip).
- NOT verified: that the client lets you right-click your own minipet (gossip), pet-journal entry (needs BattlePetSpecies; not done), summon properties 41 = minipet.
-- 2026-11-06: push 1951300 removes 643 retail SkillLineAbility rows on the 13 class lines (undo: DELETE FROM hotfixes.hotfix_data WHERE Id=1951300); gt/BaseMp.txt Death Knight column = Mage (backup C:/WowServer/Backup/BaseMp.txt.bak_20261106)
- 2026-11-06: spells now converted from the exact CoA trainer data (data/coa/class_trainer_spells.json from CoA repo rev_20260923_05): 9634 spells, schedule levels = trainer ReqLevel, book trainers use exact cost/ReqAbility1 (ranks). Level-1 trainer rows are auto-learned at login (Lua), rest from the Book of Ascension.
