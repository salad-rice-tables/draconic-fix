# Retail sniff: how to get the Curse of Ula'tek (and any other retail content) into our DB exactly

Why: objectives, NPC spawns, phases and quest texts are server-side data. The client does not have them, Wowhead only shows part of them.
A sniff records everything the real retail server sends you, and WowPacketParser (WPP) turns it into TrinityCore SQL.

## 1. Sniff (you, once, on a retail account)
1. Install Npcap (https://nmap.org/npcap/) in **WinPcap compatibility mode**.
2. Take `C:\WowServer\Tools\sniff\ymir_retail_12.1.0.69933.zip`, unpack it somewhere outside the game folder.
3. Delete the retail `Cache` folder (a retail install, not our private client: use the Battle.net retail game, build 12.1.0.69933).
4. Start `ymir_retail.exe`, then start WoW via Battle.net, log in on a **Horde or Alliance level 90** character.
5. Play: do Curse of Ula'tek from the Adventure Guide (Orweyna, Liadrin, Amani'Zar, Atal'Utek vaults), take 5-10 world quests on the Coiled Isle, let every NPC talk, open every quest.
   Sniffs are saved to `dump\` next to ymir as `.pkt`. Close WoW normally when done.
6. Send the `.pkt` file(s) to Claude (copy them to `C:\WowServer\Tools\sniff\dump\`).
   The file contains your account/character data, so share it only here.

## 2. Parse (Claude)
`C:\WowServer\Tools\WowPacketParser` is the TrinityCore parser (already downloaded). It needs the .NET 10 SDK to build; the machine has .NET 8. The SDK is installed locally into
`C:\WowServer\Tools\dotnet10` (no admin rights, no system changes). Then `dotnet build -c Release` and run with the `.pkt`; output is a text parse plus SQL for quest_template, quest_objectives,
creature, creature_template, gossip, smart scripts, phasing (`phase_area`, `conditions`) and `world_quest` data.

## 3. Import (Claude)
The generated SQL goes into a staging schema first, is compared with what we have (`tools/midnight_main_audit.py`), then applied with an undo script like all other changes.
