# draconic-fix — Some quests fixes

Verified faithful fixes for *12** quests
(Into the Abyss chain + related SM City quests) on a TrinityCore-based
(updated `master`, ~12.x) server.

Every text, NPC, reward and line of dialogue is verified against
**Wowhead** (tooltip API), **Warcraft Wiki** and the core sources.
No fan-fiction, no guessed IDs. Each fix ships with an `_undo.sql`.

## Covered quests

| Quest | ID | Status |
|---|---|---|
| Voidstorm (optional pre-quest) | 89388 | starter fixed |
| Rising Storm (Into the Abyss #1) | 92061 | full fix: texts, rewards, gossip, credits, says, phases |
| Magisters' Terrace: Homecoming (#2) | 86543 | completion, next quest, accept/terrace says |
| You Know This Evil? (83-88) | 91967 | full fix: menus, buttons, credits, Anduin scene, rewards |
| Diplomacy (Silvermoon) | 86734 | full fix: retail gossip flow, 8-line scene with retail voices, credit at the end (`docs/quest_86734_diplomacy_fix.md`) |

Details: `docs/quest_92061_rising_storm_fix.md`.
Reusable recipe: `docs/gossip_credit_quest_pattern.md`.

## 2026-10-27 archive sync

The repository now also contains the later server-fix archive through
**2026-10-27**:

- **Midnight campaign** — VO/soundkit wiring, scenes, gossip/credit flows,
  objective/phase corrections and the later chain fixes.
- **Suramar** — missing quest gameobject spawns, NPC questgiver flags,
  phasing corrections and side-quest fixes.
- **Broken Shore** — quest props and dressing object spawns.
- **Harandar / Legion** — quest-chain, reward, spawn and audit fixes.
- Updated `addon/`, `lua/`, `docs/` and the SQL fix files from the live
  server archive.

The table above is the original verified set; the archive contains the
broader working history. Apply only the SQL/Lua files relevant to the
content you are restoring.

## Apply order

SQL files are prefixed by date — **apply alphabetically** against MySQL
(`world` + `hotfixes` databases, statements are fully qualified):

```sql
SOURCE sql/20261010_rising_storm_wiki.sql;
-- ... one by one in alphabetical order ...
SOURCE sql/20261011_evil91967.sql;
```

Then copy `lua/*.lua` to the server's `lua_scripts/` folder and **restart
worldserver** (gossip/smart/lua load at startup).

Verify: `ready` in `Server.log`, empty `DBErrors` log, Eluna
`Successfully loaded` for both lua files, then test in game
(EN window text → button → credit + NPC say).

## Revert

Fix files are paired with an `*_undo.sql` where a safe rollback exists.
Apply rollback SQL in reverse alphabetical order.

## Layout

- `sql/` — fixes + undo files (English comments, sources cited per file)
- `lua/` — Eluna dialogue/credit scripts (primary credit path)
- `docs/` — patterns, quest write-ups, audits and worklists
- `addon/` — client-side addon sources used by the server fixes
- `cpp/` — core patch snapshots for reference

No credentials, no client binaries, and no raw database dumps. Audit and
worklist CSV/JSON files live under `docs/`.
