# draconic-fix — Custom CoA Midnight

Fixes and ports for a **World of Warcraft: Midnight (12.1.5)** private server built on
TrinityCore, aiming to play the **Conquest of AzerothCore (CoA)** classes and systems
on the Midnight client. CoA spell ids map to `+7,000,000`; CoA creatures likewise.

## What we are fixing

### Necromancer (CoA class port) — `cpp/necromancer`, `lua/coa_necro_*`, `sql/*necro*`
- Minions: autonomous abilities, scaling, role loops, Order / Command spells, correct display ids
- Undead stances (Assault / Pacify / Protect): mutually exclusive, applied to minions only;
  Assault speed no longer lands on the owner
- Ally buffs (Razorice, Mandates, Foul Mandate): refuse hostile targets, land on minions only
- Sacrifice Undead (all ranks): destroys every minion and heals per minion
- Phylactery / Shade chain, Corpse Explosion, Virulency / Infest, disease spread
- Talent procs (about 40) ported to a C++ aura script, proc data imported from the CoA repo
  (`tools/coa_spell_proc.py`, `tools/coa_aura_options.py`)
- Runic Power / Life Force UI bars in the `CoAUI` addon

### Quests and world (original scope of this repo)
- Retail-faithful Midnight quest fixes (Into the Abyss chain, Silvermoon), see `docs/`
- 2026-10-27 archive sync: Midnight campaign (VO/soundkit, scenes, gossip/credit, objectives, phases),
  Suramar (quest gameobjects, questgiver flags, phasing), Broken Shore props, Harandar / Legion chains
- Lua world scripts in `lua/` (Eluna), SQL in `sql/` (apply alphabetically; fixes have `_undo.sql`)

### Tools
- `tools/casc_*.py`, `tools/wow_casc.py`: read client files by FileDataID from CASC
- `tools/coa_*.py`: CoA data import (spells, creatures, display ids, procs, icons)

## Layout

| Folder | Content |
|---|---|
| `cpp/necromancer` | C++ scripts (defence rules, procs, abilities) for `src/server/scripts/Custom` |
| `cpp` | core patch snapshots for reference |
| `lua` | Eluna scripts, copy to the server's `lua_scripts/` |
| `sql` | world / hotfixes SQL, apply alphabetically; undo files where a safe rollback exists |
| `addon` | client addons (`CoAUI`: Life Force, Runic Power, talents, minion bar) |
| `tools` | Python data tools |
| `docs` | audits, patterns and notes |

## Apply order

SQL files are prefixed by date: apply alphabetically against MySQL (`world` + `hotfixes`),
statements are fully qualified. Then copy `lua/*.lua` to the server's `lua_scripts/` and restart
worldserver. Roll back with the `*_undo.sql` files in reverse order.

## Setup notes

- Python tools read the database password from the `DB_PASSWORD` environment variable.
  No credentials are stored in this repo.
- Register the C++ scripts in `custom_script_loader.cpp`
  (`AddSC_necromancer_defense`, `AddSC_necromancer_events`, `AddSC_necromancer_abilities`).
- Not ported yet: Ready charges, frost-damage proc 531135, Command-time summon procs.

## Status

Verified in game: stances, ally buffs, Sacrifice Undead, Phylactery / Shade, Corpse Explosion,
cast checks, minion spawns. Other CoA classes are not audited yet.
