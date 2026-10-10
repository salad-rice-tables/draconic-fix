# Quest 86734 Diplomacy — fix (2026-10-10)

Chain: `86733 Silvermoon Negotiations` → `86734 Diplomacy` → `86735 Paved in Ash`. Giver/ender: Lor'themar Theron (235787).
Objective `Listen to the discussion` is a kill credit (235787) that retail gives when a scripted conversation ends; the server had nothing that gave it.

## What the fix does (`lua/diplomacy86734.lua`)

1. Accepting the quest closes the gossip window (creature event 31).
2. While the quest is incomplete, Lor'themar's gossip hello shows only the Diplomacy window (npc_text 9500132, menu 38452: **Listen to the discussion** / **Skip conversation**), otherwise the normal quest list (hello hook returns `false` so the core opens it).
3. Listen plays the 8-line discussion (Lor'themar, Halduron, Umbric, Rommath, Umbric, Turalyon, Lor'themar, Turalyon), each line spoken by its NPC and with its voice; the credit is given when the scene ends. Skip gives the credit at once.

## Umbric

In retail Umbric is a purple Void projection and teleports away after his last line. The projection look is the sniffed aura `166452` (`sql/20261011_umbric_projection.sql` gives it to the phased spawn; the script also adds it at scene start). After his second line the script casts `1246091` (Cosmetic - Void Teleport Away) and despawns him (he respawns with the normal timer).

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
