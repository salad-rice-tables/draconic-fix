# Core audit (Draconic-RoleplayCore, 12.1.0.69587) - what is missing compared with retail

Measured on 2026-10-11 from `src/server/game/Server/Protocol/Opcodes.cpp`, the last 67 server logs and the source tree. The core is a manual fork of TrinityCore master
(last pull "TC pull Sep26-Oct11"), so it is as complete as upstream; the gaps below are gaps of TrinityCore itself, not a stale merge.

## 1. Numbers
- Client opcodes (CMSG): 1027, of them **367 are `STATUS_UNHANDLED`** (stub, the packet is read and thrown away) = 36 %.
- Server opcodes (SMSG): 1408, 664 `STATUS_UNHANDLED` (there is no code that could ever send them).
- Full list of the 367: `data/core_unhandled_cmsg.txt`.

By area (stubbed client opcodes): Housing 56 + Neighborhood 22 + House 3 = **81**, Garrison 23, LFG 12, Crafting (orders) 11, Lobby 11, Pet 10, Chat 7, Commentator 7, Quick Join 5, RAF 5, Discord 5.

## 2. What the client really asks for (from our logs, "Received not handled opcode")
| opcode | times | effect in the game |
|---|---|---|
| CMSG_QUERY_QUEST_ITEM_USABILITY | 696 | quest items are never reported usable/unusable (the "use" glow, tooltips) |
| CMSG_QUICK_JOIN_AUTO_ACCEPT_REQUESTS | 184 | Quick Join (group finder) |
| CMSG_OPEN_TRADESKILL_NPC | 146 | profession NPC window / crafting orders |
| CMSG_SET_EXCLUDED_CHAT_CENSOR_SOURCES | 128 | chat censor settings |
| CMSG_LFG_LIST_GET_STATUS, CMSG_REQUEST_LFG_LIST_BLACKLIST | 77 each | Group Finder "Premade groups" tab |
| CMSG_REQUEST_INSTANCE_ENCOUNTER_EVENT_SYNC | 77 | dungeon/raid encounter sync |
| CMSG_GET_LANDING_PAGE_SHIPMENTS | 77 | expansion landing page (Midnight) |
| CMSG_GET_CHARACTER_CURRENCY_TRANSFER_LOG | 77 | currency transfer UI |
| **CMSG_HOUSING_SVCS_GET_PLAYER_HOUSES_INFO** | 68 | housing dashboard (no answer = it never loads) |
| CMSG_REQUEST_WEEKLY_REWARDS | 60 | Great Vault |
| CMSG_REQUEST_MYTHIC_PLUS_SEASON_DATA | 60 | Mythic+ season window |
| CMSG_GET_REMAINING_GAME_TIME, CMSG_GET_RAF_ACCOUNT_INFO, CMSG_GET_ACCOUNT_CHARACTER_LIST, CMSG_GET_LAST_CATALOG_FETCH | 60-64 | account services, shop |
| CMSG_HOUSING_DECOR_REQUEST_STORAGE | 3 | housing storage |

## 3. Player housing
Only one housing packet is handled (`DeclineNeighborhoodInvites`, `Handlers/HousingHandler.cpp`, 28 lines). Everything else is `Handle_NULL`:
- 56 HOUSING opcodes: blueprint, decor (place/move/remove/storage/dye), fixture, room (add/move/rotate/theme), house status, photo sharing, reset, tutorial, teleport to plot, ...
- 22 NEIGHBORHOOD opcodes: invites, ownership, plots, charter, guild neighborhoods, house finder.
- 664 SMSG opcodes are not written anywhere, so the client never gets a house, a plot or a neighborhood.
The DB2 side exists (Neighborhood*, House*, Decor* tables are in the client data). The server side (accounts' houses, plots, decor storage, room layouts, instance maps "Founder's Point" /
"Razorwind Shores") is a project of its own: new DB schema, 80 handlers and the matching update fields. It needs the packet layouts, which WowPacketParser does not have yet for 12.1
(no parser for these packets), so they would have to come from a retail sniff (`SNIFF_POSTUP.md`).

## 4. Done in this pass
- World quests (WorldQuests.h, QuestHandler.cpp, Player.cpp): CMSG_REQUEST_WORLD_QUEST_UPDATE answered, pick-up in the area, automatic reward. Rotation in `lua_scripts/world_quest_rotation.lua`.
- Adventure Guide quest entries (ender added), phasing by quest progress (`conditions` type 32), TDB 12.1.0 data import (`tdb_import.py`).

## 5. Next, by value
1. QUERY_QUEST_ITEM_USABILITY + response (quest items) - small.
2. Great Vault (REQUEST_WEEKLY_REWARDS) and Mythic+ season data - medium, needs the layout.
3. Group Finder: LFG list status/blacklist, Quick Join - medium.
4. Crafting orders / OPEN_TRADESKILL_NPC - large.
5. Housing - very large.
All of 1-5 need the client packet layouts: from a Ymir sniff of retail 12.1 (WowPacketParser then prints the structure), or from the TrinityCore master once somebody there implements them.
