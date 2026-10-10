# Gossip-credit quest (pattern: Rising Storm 92061)

Verified working procedure for quests of type "consult NPC via gossip button → credit + say".
Credit goes PRIMARILY through Eluna (the only verified click path); SmartAI rows are backup only.

## 1. DB: gossip menu + text (verbatim from Wiki)

- `hotfixes.broadcast_text` (ID 99xxxxx): `Text` = window text, **`LanguageID = 0`** (not 7!
  Common is scrambled for Horde players), `Text1 = ''`.
- `world.npc_text` (ID 95xxxxx): `Probability0 = 1`, `BroadcastTextID0` = broadcast ID.
- `world.gossip_menu` (MenuID 40xxx, free): `TextID` = npc_text ID.
- `world.gossip_menu_option`: `OptionNpc = 0` (None! 3 = Trainer = dead button),
  **`GossipOptionID` UNIQUE per button (`MenuID*10+OptionID`)** — with duplicate IDs
  the client only sends the first button (with 0 the core auto-generates negative IDs
  and SmartAI `(menu,action)` never matches — see `GossipDef.cpp`, `NPCHandler.cpp:344`),
  `OptionID` from 0, button text.
- `world.creature_template_gossip`: `CreatureID → MenuID` (without the link the button does not exist!).

## 2. Eluna: credit + replies (`Custom/lua/*.lua`, restart copies it over)

```lua
local SaidAt, COOLDOWN = {}, 180 -- cross reply max once per 180 s per player
RegisterCreatureGossipEvent(NPC_ENTRY, 2, function(_, player, creature, sender, intid)
    if sender == MENUID then -- gate by MENU (intids proved unreliable: all buttons report 0)
        pcall(function() player:KilledMonsterCredit(CREDIT_ENTRY) end)
        if creature then pcall(function() creature:SendUnitSay("...", 0) end) end
        -- cross reply from another NPC after 3000 ms (player:RegisterEvent, GetCreaturesInRange)
    end
end)
```

Note: the Eluna select-hook runs BEFORE SmartAI (`NPCHandler.cpp`) and may block it —
so credit must NEVER rely on SmartAI alone.

## 3. SmartAI backup (optional, credit is idempotent)

`smart_scripts`: `(ENTRY, 0, 0, link, '', 62, 0, 100, 0, UNIQUEID, 0, ...)` action 33
(`CALL_KILLEDMONSTER`, target 7 = invoker). **NOTE: `entryorguid` POSITIVE = template entry**
(all spawns); negative = specific spawn guid and the row never loads
(`SmartScriptMgr.cpp`, `LoadSmartAIFromDB`, error `guid (X) does not exist`)!
No post-button says via SmartAI (duplication with Eluna) — says belong to Eluna.

## 4. Phases and visibility

- Every quest NPC needs a spawn in the phase where the quest runs (retail phases:
  `phase_name`, key one `45749 'Rising Storm'`). Missing spawn = additive custom spawn
  (new guid 3001001xxx, copy of retail row, only different `PhaseId`).
- POI points (`quest_poi`/`quest_poi_points`) must match spawns (verify with SELECT).
- NOTE twins: same name ≠ same entry (Bellamy 250587 faction 14
  vs 9100622 faction 35) — always verify `creature_template.faction` + Wowhead tooltip.

## 5. Languages

- Custom texts English only, NO locale rows (fallback = default).
- Retail quest-locale rows (deDE/frFR in `quest_template_locale`, `quest_objectives_locale`,
  `quest_offer_reward_locale`, `quest_request_items_locale`) override the client:
  for always-English, overwrite with default English (JOIN UPDATE), originals into the undo file
  (generate from LIVE data BEFORE overwriting!).

## 6. Deploy + verify

1. SQL file + `_undo.sql` (convention `Custom/sql/YYYYMMDD_name.sql`).
2. Apply, verify with SELECT (links, menu→text→button, smart rows).
3. Restart `Custom/tools/restart_world.ps1` (gossip/smart/lua load at startup).
4. Check: `ready` in Server.log, empty `DBErrors`, Eluna `Successfully loaded`.
5. In-game test: EN text → click → credit + own say + cross say after 3 s.
