# Quest 86734 Diplomacy — fix (2026-10-10)

Chain: `86733 Silvermoon Negotiations` → `86734 Diplomacy` → `86735 Paved in Ash`. Giver/ender: Lor'themar Theron (235787).
Objective `Listen to the discussion` is a kill credit (235787) that retail gives when a scripted conversation ends; the server had nothing that gave it.

## What the fix does (`lua/diplomacy86734.lua`)

1. Accepting the quest closes the gossip window (creature event 31).
2. While the quest is incomplete, Lor'themar's gossip hello shows only the Diplomacy window (npc_text 9500132, menu 38452: **Listen to the discussion** / **Skip conversation**), otherwise the normal quest list (hello hook returns `false` so the core opens it).
3. Listen plays the 8-line discussion (Lor'themar, Halduron, Umbric, Rommath, Umbric, Turalyon, Lor'themar, Turalyon), each line spoken by its NPC and with its voice; the credit is given when the scene ends. Skip gives the credit at once.

## Umbric (per-player phase)

In retail Umbric is a purple Void projection that is there for the discussion and leaves afterwards. Here it is done with phases (`sql/20261011_diplo_umbric_phase.sql`, undo included):

- new phase `9600002` (area 15969) is active while quest 86734 is **incomplete**; it holds a new Umbric spawn (guid 3001001200) with auras `166452` (sniffed projection look) and `261627` (purple hologram);
- the two existing Umbric spawns (phases 45584 and 46726) moved to `9600003`/`9600004`, which keep their original condition and add "NOT 86734 incomplete/complete" - so there is only one Umbric at a time;
- the Lua scene gives the credit 46 s after the start (right after his last line), the quest becomes complete, his phase ends **for that player only**, and he disappears. Abandon and re-take the quest and everything resets.

Just before the credit (44 s) Umbric casts the cosmetic **Arcane Dissolve Out (1244360)** on himself, so he dissolves instead of popping out. Not used: `1246091` (Cosmetic - Void Teleport Away) showed nothing in game; a global despawn would hide him for everybody.

## Exact retail text and voice

The lines are BroadcastText **285180–285189** (wago `BroadcastText` CSV, build 12.1.0.69587); their `SoundKitID_0` are **299863–299870**, which are exactly the numbers on Wowhead `sound=` pages.
A Wowhead sound id is a **SoundKit id**: `.debug play sound 299863` and `creature:PlayDistanceSound(299863, player)` work. `PlaySoundFile(299863)` (FileDataID) is silent.
The server's `hotfixes.broadcast_text` is an older snapshot without these lines; get the retail rows with
`https://wago.tools/db2/BroadcastText/csv?build=12.1.0.69587`.

| Line | Speaker | BroadcastText | SoundKit |
|---|---|---|---|
| 1 | Lor'themar | 285180 | 299863 |
| 2 | Halduron | 285181 | 299864 |
| 3 | Umbric | 285184 | 299865 |
| 4 | Rommath | 285185 | 299866 |
| 5 | Umbric | 285186 | 299867 |
| 6 | Turalyon | 285187 | 299868 |
| 7 | Lor'themar | 285188 | 299869 |
| 8 | Turalyon | 285189 | 299870 |

## Gotchas found

- Eluna gossip hello: return `false` = the core shows its normal window; returning nothing/true means "handled", so no window opens at all.
- A per-player cooldown that skips the whole scene looks like "nothing happens" when testing repeatedly (now 60 s).
- Client addons are enabled per character; a new addon folder needs a full client restart.

## Apply

Copy `lua/diplomacy86734.lua` to `lua_scripts/` and `.reload eluna` (no restart needed). SQL part (menu 38452, texts, link) is in `sql/20261011_diplo86734.sql`.
